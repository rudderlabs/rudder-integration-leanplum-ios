# What is RudderStack?

[RudderStack](https://rudderstack.com/) is a **customer data pipeline** tool for collecting, routing and processing data from your websites, apps, cloud tools, and data warehouse.

More information on RudderStack can be found [here](https://github.com/rudderlabs/rudder-server).

## Integrating Leanplum with RudderStack's iOS SDK

1. Add [Leanplum](https://www.leanplum.com) as a destination in the [Dashboard](https://app.rudderstack.com/) and provide ```applicationId``` and `clientKey` from your Leanplum dashboard. Provide the `devClientKey` if you have turned on the `Development Environment` flag. Provide the `prodClientKey` otherwise.

2. Setup the Hybrid Mode of integration:
  - Turning on the switch beside `Initialize Native SDK to send automated events` in the dashboard will initialize the LeanPlum native SDK in the application.
  - Turning on the switch beside `Use native SDK to send user generated events` in the dashboard will instruct your `data-plane` to skip the events for LeanPlum and the events will be sent from the LeanPlum SDK.

3. Rudder-Leanplum is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'Rudder-Leanplum'
```

## Initialize ```RSClient```

Put this code in your ```AppDelegate.m``` file under the method ```didFinishLaunchingWithOptions```
```
RSConfigBuilder *builder = [[RSConfigBuilder alloc] init];
[builder withDataPlaneUrl:DATA_PLANE_URL];
[builder withFactory:[RudderLeanplumFactory instance]];
[RSClient getInstance:WRITE_KEY config:[builder build]];
```

## Send Events

Follow the steps from the [RudderStack iOS SDK](https://github.com/rudderlabs/rudder-sdk-ios).

## Contact Us

If you come across any issues while configuring or using this integration, please feel free to start a conversation on our [Slack](https://resources.rudderstack.com/join-rudderstack-slack) channel. We will be happy to help you.
