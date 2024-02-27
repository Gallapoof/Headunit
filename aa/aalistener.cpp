#include "aalistener.h"

AAListener::AAListener(QQuickItem *parent) : QQuickItem(parent),
    ioService(),
    work(ioService),
    strand(ioService),
    usbWrapper((libusb_init(&usbContext), usbContext)),
    accessoryModeQueryFactory(usbWrapper, ioService),
    accessoryModeQueryChainFactory(usbWrapper, ioService, accessoryModeQueryFactory)
{
    usbHub = (std::make_shared<aasdk::usb::USBHub>(usbWrapper, ioService, accessoryModeQueryChainFactory));
    connectedAccessoriesEnumerator = (std::make_shared<aasdk::usb::ConnectedAccessoriesEnumerator>(usbWrapper, ioService, accessoryModeQueryChainFactory));

    auto ioServiceWork = [this]() 
    {
        ioService.run();
    };

    threadPool.emplace_back(ioServiceWork);
    threadPool.emplace_back(ioServiceWork);
    threadPool.emplace_back(ioServiceWork);
    threadPool.emplace_back(ioServiceWork);

    //Create USB threads
    auto usbWork = [this]()
    {
        timeval libusbEventTimeout{180, 0};

        while(!ioService.stopped())
        {
            libusb_handle_events_timeout_completed(usbContext, &libusbEventTimeout, nullptr);
        }
    };
    threadPool.emplace_back(usbWork);
    

    start();
}

AAListener::~AAListener()
{
    //TODO: Clean destruction of io service

    libusb_exit(usbContext);
}

void AAListener::start()
{
    //Setup USB
    auto promise = aasdk::usb::IUSBHub::Promise::defer(strand);
    promise->then(std::bind(&AAListener::aoapDeviceHandler, this, std::placeholders::_1));
    usbHub->start(std::move(promise));
    qInfo("USB started.");

    //Enumerate
    strand.dispatch([this, self = this]()
    {
        auto promise = aasdk::usb::IConnectedAccessoriesEnumerator::Promise::defer(strand);
        promise->then([this, self = this](auto result) {
            qInfo("[App] Devices enumeration result: " + (bool)result);
        },
        [this, self = this](auto e) {
            qInfo("[App] Devices enumeration failed: ");
        });

    connectedAccessoriesEnumerator->enumerate(std::move(promise));
    });
}

void AAListener::stop()
{
}

void AAListener::aoapDeviceHandler(aasdk::usb::DeviceHandle deviceHandle)
{
    qInfo("USB Device connected.");
    
}
