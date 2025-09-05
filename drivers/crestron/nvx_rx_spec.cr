require "placeos-driver/spec"
require "uri"

DriverSpecs.mock_driver "Crestron::NvxRx" do
  # Connected callback makes some queries
  should_send "/Device/DeviceSpecific/DeviceMode"
  responds %({"Device": {"DeviceSpecific": {"DeviceMode": "Receiver"}}})

  should_send "/Device/XioSubscription/Subscriptions"
  responds %({"Device": {"XioSubscription": {"Subscriptions": {
    "00000000-0000-4002-0054-018a0089fd1c": {
      "Address": "https://10.254.47.133/onvif/services",
      "AudioChannels": 0,
      "AudioFormat": "No Audio",
      "Bitrate": 750,
      "Encryption": true,
      "Fps": 0,
      "MulticastAddress": "228.228.228.224",
      "Position": 2,
      "Resolution": "0x0",
      "RtspUri": "rtsp://10.254.47.133:554/live.sdp",
      "SessionName": "DM-NVX-E30-DEADBEEF1234",
      "SnapshotUrl": "",
      "Transport": "TS/RTP",
      "UniqueId": "00000000-0000-4002-0054-018a0089fd1c",
      "VideoFormat": "Pixel",
      "IsSyncDetected": false,
      "Status": "SUBSCRIBED"
    }
  }}}})

  should_send "/Device/Localization/Name"
  responds %({"Device": {"Localization": {"Name": "projector"}}})

  should_send "/Device/Osd/Text"
  responds %({"Device": {"Osd": {"Text": "Hearing Loop"}}})

  should_send "/Device/DeviceSpecific/ActiveVideoSource"
  responds %({"Device": {"DeviceSpecific": {"ActiveVideoSource": "Stream"}}})

  should_send "/Device/AvRouting/Routes"
  responds %({"Device": {"AvRouting": {"Routes": [
    {
      "Name": "Routing0",
      "AudioSource": "00000000-0000-4002-0054-018a0089fd1c",
      "VideoSource": "00000000-0000-4002-0054-018a0089fd1c",
      "UsbSource": "00000000-0000-4002-0054-018a0089fd1c",
      "AutomaticStreamRoutingEnabled": false,
      "UniqueId": "cc063ec3-d135-4413-9ee9-5a9264b5642c"
    }
  ]}}})

  should_send "/Device/DeviceSpecific/ActiveAudioSource"
  responds %({"Device": {"DeviceSpecific": {"ActiveAudioSource": "Input1"}}})

  should_send "/Device/AvioV2/Inputs"
  responds %({"Device":{"AvioV2":{"Inputs":{"Input1":{"Capabilities":{"IsAudioRoutingSupported":true,"IsStreamRoutingSupported":false,"IsUsbRoutingSupported":true,"IsVideoRoutingSupported":true},"InputInfo":{"Id":"Port1","Ports":{"Port1":{"AspectRatio":"No signal","Audio":{"Digital":{"Channels":0,"Format":"No Audio","SamplingFrequency":0}},"CurrentEdid":"01 DM default","CurrentEdidType":"system","CurrentResolution":"0x0@0","Digital":{"Cec":{"IsCecErrorDetected":false,"ReceiveCecMessage":""},"ColorDepth":"8 - bit","ColorSpace":"UNKNOWN","HdcpReceiverCapability":"HDCP Support Off","HdcpReceiverCapabilityOptions":["HDCP Support Off","Auto","HDCP 1.4 Support","HDCP 2.x Support"],"HdcpState":"NotRequired","IsSourceHdcpActive":false,"SourceContentStreamType":"Type 0 Content Stream","SourceHdcp":"No Signal","Status3D":"No 3D","UnsupportedVideoDetected":false},"EdidApplyError":"No err","FramesPerSecond":0,"HorizontalResolution":0,"IsInterlacedDetected":false,"IsSourceDetected":false,"IsSyncDetected":false,"PortType":"Hdmi","VerticalResolution":0}},"Version":"3.0.70"},"UserSpecifiedName":"HDMI 1"},"Input2":{"Capabilities":{"IsAudioRoutingSupported":true,"IsStreamRoutingSupported":false,"IsUsbRoutingSupported":true,"IsVideoRoutingSupported":true},"InputInfo":{"Id":"Port2","Ports":{"Port1":{"AspectRatio":"No signal","Audio":{"Digital":{"Channels":0,"Format":"No Audio","SamplingFrequency":0}},"CurrentEdid":"01 DM default","CurrentEdidType":"system","CurrentResolution":"0x0@0","Digital":{"Cec":{"IsCecErrorDetected":false,"ReceiveCecMessage":""},"ColorDepth":"8 - bit","ColorSpace":"UNKNOWN","HdcpReceiverCapability":"HDCP Support Off","HdcpReceiverCapabilityOptions":["HDCP Support Off","Auto","HDCP 1.4 Support","HDCP 2.x Support","HDCP Support Off","Auto","HDCP 1.4 Support","HDCP 2.x Support"],"HdcpState":"NotRequired","IsSourceHdcpActive":false,"SourceContentStreamType":"Type 0 Content Stream","SourceHdcp":"No Signal","Status3D":"No 3D","UnsupportedVideoDetected":false},"EdidApplyError":"No err","FramesPerSecond":0,"HorizontalResolution":0,"IsInterlacedDetected":false,"IsSourceDetected":false,"IsSyncDetected":false,"PortType":"Hdmi","VerticalResolution":0}},"Version":"3.0.70"},"UserSpecifiedName":"HDMI 2"},"Input3":{"Capabilities":{"IsAudioRoutingSupported":true,"IsStreamRoutingSupported":false,"IsUsbRoutingSupported":true,"IsVideoRoutingSupported":true},"InputInfo":{"Id":"Port3","Ports":{"Port1":{"AspectRatio":"No signal","Audio":{"Digital":{"Channels":0,"Format":"No Audio","SamplingFrequency":0}},"CurrentEdid":"01 DM default","CurrentEdidType":"system","CurrentResolution":"0x0@0","Digital":{"Cec":{"IsCecErrorDetected":false},"ColorDepth":"8 - bit","ColorSpace":"UNKNOWN","HdcpReceiverCapability":"HDCP Support Off","HdcpReceiverCapabilityOptions":["HDCP Support Off","Auto","HDCP 1.4 Support","HDCP 2.x Support","HDCP Support Off","Auto","HDCP 1.4 Support","HDCP 2.x Support","HDCP Support Off","Auto","HDCP 1.4 Support","HDCP 2.x Support"],"HdcpState":"NotRequired","IsSourceHdcpActive":false,"SourceContentStreamType":"Type 0 Content Stream","SourceHdcp":"No Signal","Status3D":"No 3D","UnsupportedVideoDetected":false},"EdidApplyError":"No err","FramesPerSecond":0,"HorizontalResolution":0,"IsInterlacedDetected":false,"IsSourceDetected":false,"IsSyncDetected":false,"PortType":"Usb","VerticalResolution":0}},"Version":"3.0.70"},"UserSpecifiedName":"USB-C1"},"Input4":{"Capabilities":{"IsAudioRoutingSupported":true,"IsStreamRoutingSupported":false,"IsUsbRoutingSupported":true,"IsVideoRoutingSupported":true},"InputInfo":{"Id":"Port4","Ports":{"Port1":{"AspectRatio":"No signal","Audio":{"Digital":{"Channels":0,"Format":"No Audio","SamplingFrequency":0}},"CurrentEdid":"01 DM default","CurrentEdidType":"system","CurrentResolution":"0x0@0","Digital":{"Cec":{"IsCecErrorDetected":false},"ColorDepth":"8 - bit","ColorSpace":"UNKNOWN","HdcpReceiverCapability":"HDCP Support Off","HdcpReceiverCapabilityOptions":["HDCP Support Off","Auto","HDCP 1.4 Support","HDCP 2.x Support","HDCP Support Off","Auto","HDCP 1.4 Support","HDCP 2.x Support","HDCP Support Off","Auto","HDCP 1.4 Support","HDCP 2.x Support","HDCP Support Off","Auto","HDCP 1.4 Support","HDCP 2.x Support"],"HdcpState":"NotRequired","IsSourceHdcpActive":false,"SourceContentStreamType":"Type 0 Content Stream","SourceHdcp":"No Signal","Status3D":"No 3D","UnsupportedVideoDetected":false},"EdidApplyError":"No err","FramesPerSecond":0,"HorizontalResolution":0,"IsInterlacedDetected":false,"IsSourceDetected":false,"IsSyncDetected":false,"PortType":"Usb","VerticalResolution":0}},"Version":"3.0.70"},"UserSpecifiedName":"USB-C2"}}}}})

  responds %({"Device":{"AvioV2":{"Inputs":{"Input3":{"InputInfo":{"Ports":{"Port1":{"VerticalResolution": 0}}}}}}}})
  responds %({"Device":{"AvioV2":{"Inputs":{"Input4":{"InputInfo":{"Ports":{"Port1":{"VerticalResolution": 1080}}}}}}}})

  status[:video_source].should eq("Stream-00000000-0000-4002-0054-018a0089fd1c")
  status[:audio_source].should eq("Input1")
  status[:device_name].should eq("projector")
  status[:osd_text].should eq("Hearing Loop")
  status[:input1_sync].should eq(false)
  status[:input2_sync].should eq(false)
  status[:input3_sync].should eq(false)
  status[:input4_sync].should eq(true)

  # we call this manually as the driver isn't loaded in websocket mode
  exec :authenticate

  # We expect the first thing it to do is authenticate
  auth = URI::Params.build { |form|
    form.add("login", "admin")
    form.add("passwd", "admin")
  }

  expect_http_request do |request, response|
    io = request.body
    if io
      request_body = io.gets_to_end
      if request_body == auth
        response.status_code = 200
        response.headers["CREST-XSRF-TOKEN"] = "1234"
        cookies = response.cookies
        cookies["AuthByPasswd"] = "true"
        cookies["iv"] = "true"
        cookies["tag"] = "true"
        cookies["userid"] = "admin"
        cookies["userstr"] = "admin"
      else
        response.status_code = 401
      end
    else
      raise "expected request to include login form #{request.inspect}"
    end
  end
end
