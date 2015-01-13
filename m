Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbbAMI4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 03:56:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:16794 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbbAMI4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 03:56:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,748,1413270000"; 
   d="scan'208";a="650296437"
Date: Tue, 13 Jan 2015 16:55:38 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: kbuild-all@01.org, Felipe Balbi <balbi@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [next:master 2818/3104] drivers/usb/gadget/function/f_uvc.c:816:41:
 sparse: incorrect type in assignment (different base types)
Message-ID: <201501131627.qyQasDGL%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   8fb4ab29bd8400e0060662208573d26b9d91656d
commit: 46919a23ee87bbc4eeb6d958471174e26836f0e1 [2818/3104] usb: gadget: uvc: configfs support in uvc function
reproduce:
  # apt-get install sparse
  git checkout 46919a23ee87bbc4eeb6d958471174e26836f0e1
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/usb/gadget/function/f_uvc.c:50:9: sparse: advancing past deep designator
   drivers/usb/gadget/function/f_uvc.c:113:35: sparse: incorrect type in initializer (different base types)
   drivers/usb/gadget/function/f_uvc.c:113:35:    expected unsigned short [unsigned] [usertype] wMaxTransferSize
   drivers/usb/gadget/function/f_uvc.c:113:35:    got restricted __le16 [usertype] <noident>
   drivers/usb/gadget/function/f_uvc.c:575:42: sparse: incorrect type in assignment (different base types)
   drivers/usb/gadget/function/f_uvc.c:575:42:    expected unsigned short [unsigned] [usertype] wTotalLength
   drivers/usb/gadget/function/f_uvc.c:575:42:    got restricted __le16 [usertype] <noident>
   drivers/usb/gadget/function/f_uvc.c:589:44: sparse: incorrect type in assignment (different base types)
   drivers/usb/gadget/function/f_uvc.c:589:44:    expected unsigned short [unsigned] [usertype] wTotalLength
   drivers/usb/gadget/function/f_uvc.c:589:44:    got restricted __le16 [usertype] <noident>
>> drivers/usb/gadget/function/f_uvc.c:816:41: sparse: incorrect type in assignment (different base types)
   drivers/usb/gadget/function/f_uvc.c:816:41:    expected unsigned short [unsigned] [usertype] wTerminalType
   drivers/usb/gadget/function/f_uvc.c:816:41:    got restricted __le16 [usertype] <noident>
>> drivers/usb/gadget/function/f_uvc.c:819:41: sparse: incorrect type in assignment (different base types)
   drivers/usb/gadget/function/f_uvc.c:819:41:    expected unsigned short [unsigned] [usertype] wObjectiveFocalLengthMin
   drivers/usb/gadget/function/f_uvc.c:819:41:    got restricted __le16 [usertype] <noident>
>> drivers/usb/gadget/function/f_uvc.c:820:41: sparse: incorrect type in assignment (different base types)
   drivers/usb/gadget/function/f_uvc.c:820:41:    expected unsigned short [unsigned] [usertype] wObjectiveFocalLengthMax
   drivers/usb/gadget/function/f_uvc.c:820:41:    got restricted __le16 [usertype] <noident>
>> drivers/usb/gadget/function/f_uvc.c:821:41: sparse: incorrect type in assignment (different base types)
   drivers/usb/gadget/function/f_uvc.c:821:41:    expected unsigned short [unsigned] [usertype] wOcularFocalLength
   drivers/usb/gadget/function/f_uvc.c:821:41:    got restricted __le16 [usertype] <noident>
>> drivers/usb/gadget/function/f_uvc.c:833:41: sparse: incorrect type in assignment (different base types)
   drivers/usb/gadget/function/f_uvc.c:833:41:    expected unsigned short [unsigned] [usertype] wMaxMultiplier
   drivers/usb/gadget/function/f_uvc.c:833:41:    got restricted __le16 [usertype] <noident>
>> drivers/usb/gadget/function/f_uvc.c:844:41: sparse: incorrect type in assignment (different base types)
   drivers/usb/gadget/function/f_uvc.c:844:41:    expected unsigned short [unsigned] [usertype] wTerminalType
   drivers/usb/gadget/function/f_uvc.c:844:41:    got restricted __le16 [usertype] <noident>
--
>> drivers/usb/gadget/function/uvc_configfs.c:46:28: sparse: symbol 'to_uvcg_control_header' was not declared. Should it be static?
>> drivers/usb/gadget/function/uvc_configfs.c:124:1: sparse: cast to restricted __le16
>> drivers/usb/gadget/function/uvc_configfs.c:124:1: sparse: incorrect type in assignment (different base types)
   drivers/usb/gadget/function/uvc_configfs.c:124:1:    expected unsigned short [unsigned] [usertype] bcdUVC
   drivers/usb/gadget/function/uvc_configfs.c:124:1:    got restricted __le16 [usertype] <noident>
>> drivers/usb/gadget/function/uvc_configfs.c:127:1: sparse: cast to restricted __le32
>> drivers/usb/gadget/function/uvc_configfs.c:127:1: sparse: incorrect type in assignment (different base types)
   drivers/usb/gadget/function/uvc_configfs.c:127:1:    expected unsigned int [unsigned] [usertype] dwClockFrequency
   drivers/usb/gadget/function/uvc_configfs.c:127:1:    got restricted __le32 [usertype] <noident>
>> drivers/usb/gadget/function/uvc_configfs.c:138:25: sparse: symbol 'uvcg_control_header_type' was not declared. Should it be static?
>> drivers/usb/gadget/function/uvc_configfs.c:156:41: sparse: incorrect type in assignment (different base types)
   drivers/usb/gadget/function/uvc_configfs.c:156:41:    expected unsigned short [unsigned] [usertype] bcdUVC
   drivers/usb/gadget/function/uvc_configfs.c:156:41:    got restricted __le16 [usertype] <noident>
>> drivers/usb/gadget/function/uvc_configfs.c:157:41: sparse: incorrect type in assignment (different base types)
   drivers/usb/gadget/function/uvc_configfs.c:157:41:    expected unsigned int [unsigned] [usertype] dwClockFrequency
   drivers/usb/gadget/function/uvc_configfs.c:157:41:    got restricted __le32 [usertype] <noident>
>> drivers/usb/gadget/function/uvc_configfs.c:164:6: sparse: symbol 'uvcg_control_header_drop' was not declared. Should it be static?
>> drivers/usb/gadget/function/uvc_configfs.c:238:1: sparse: cast to restricted __le16
>> drivers/usb/gadget/function/uvc_configfs.c:361:1: sparse: cast to restricted __le16
>> drivers/usb/gadget/function/uvc_configfs.c:364:1: sparse: cast to restricted __le16
>> drivers/usb/gadget/function/uvc_configfs.c:366:1: sparse: cast to restricted __le16
>> drivers/usb/gadget/function/uvc_configfs.c:368:1: sparse: cast to restricted __le16
>> drivers/usb/gadget/function/uvc_configfs.c:493:1: sparse: cast to restricted __le16
>> drivers/usb/gadget/function/uvc_configfs.c:721:20: sparse: symbol 'to_uvcg_format' was not declared. Should it be static?
>> drivers/usb/gadget/function/uvc_configfs.c:798:30: sparse: symbol 'to_uvcg_streaming_header' was not declared. Should it be static?
>> drivers/usb/gadget/function/uvc_configfs.c:950:25: sparse: symbol 'uvcg_streaming_header_type' was not declared. Should it be static?
>> drivers/usb/gadget/function/uvc_configfs.c:976:6: sparse: symbol 'uvcg_streaming_header_drop' was not declared. Should it be static?
>> drivers/usb/gadget/function/uvc_configfs.c:1020:19: sparse: symbol 'to_uvcg_frame' was not declared. Should it be static?
>> drivers/usb/gadget/function/uvc_configfs.c:1102:1: sparse: cast to restricted __le16
>> drivers/usb/gadget/function/uvc_configfs.c:1102:1: sparse: incorrect type in assignment (different base types)
   drivers/usb/gadget/function/uvc_configfs.c:1102:1:    expected unsigned short [unsigned] [usertype] w_width
   drivers/usb/gadget/function/uvc_configfs.c:1102:1:    got restricted __le16 [usertype] <noident>
>> drivers/usb/gadget/function/uvc_configfs.c:1104:1: sparse: cast to restricted __le16
>> drivers/usb/gadget/function/uvc_configfs.c:1104:1: sparse: incorrect type in assignment (different base types)
   drivers/usb/gadget/function/uvc_configfs.c:1104:1:    expected unsigned short [unsigned] [usertype] w_height
   drivers/usb/gadget/function/uvc_configfs.c:1104:1:    got restricted __le16 [usertype] <noident>
>> drivers/usb/gadget/function/uvc_configfs.c:1106:1: sparse: cast to restricted __le32
>> drivers/usb/gadget/function/uvc_configfs.c:1106:1: sparse: incorrect type in assignment (different base types)
   drivers/usb/gadget/function/uvc_configfs.c:1106:1:    expected unsigned int [unsigned] [usertype] dw_min_bit_rate
   drivers/usb/gadget/function/uvc_configfs.c:1106:1:    got restricted __le32 [usertype] <noident>
>> drivers/usb/gadget/function/uvc_configfs.c:1108:1: sparse: cast to restricted __le32
>> drivers/usb/gadget/function/uvc_configfs.c:1108:1: sparse: incorrect type in assignment (different base types)
   drivers/usb/gadget/function/uvc_configfs.c:1108:1:    expected unsigned int [unsigned] [usertype] dw_max_bit_rate
   drivers/usb/gadget/function/uvc_configfs.c:1108:1:    got restricted __le32 [usertype] <noident>
>> drivers/usb/gadget/function/uvc_configfs.c:1110:1: sparse: cast to restricted __le32
>> drivers/usb/gadget/function/uvc_configfs.c:1110:1: sparse: incorrect type in assignment (different base types)
   drivers/usb/gadget/function/uvc_configfs.c:1110:1:    expected unsigned int [unsigned] [usertype] dw_max_video_frame_buffer_size
   drivers/usb/gadget/function/uvc_configfs.c:1110:1:    got restricted __le32 [usertype] <noident>
>> drivers/usb/gadget/function/uvc_configfs.c:1112:1: sparse: cast to restricted __le32
>> drivers/usb/gadget/function/uvc_configfs.c:1112:1: sparse: incorrect type in assignment (different base types)
   drivers/usb/gadget/function/uvc_configfs.c:1112:1:    expected unsigned int [unsigned] [usertype] dw_default_frame_interval
   drivers/usb/gadget/function/uvc_configfs.c:1112:1:    got restricted __le32 [usertype] <noident>
>> drivers/usb/gadget/function/uvc_configfs.c:1136:35: sparse: cast to restricted __le32
>> drivers/usb/gadget/function/uvc_configfs.c:1265:25: sparse: symbol 'uvcg_frame_type' was not declared. Should it be static?
>> drivers/usb/gadget/function/uvc_configfs.c:1285:49: sparse: incorrect type in assignment (different base types)
   drivers/usb/gadget/function/uvc_configfs.c:1285:49:    expected unsigned short [unsigned] [usertype] w_width
   drivers/usb/gadget/function/uvc_configfs.c:1285:49:    got restricted __le16 [usertype] <noident>
>> drivers/usb/gadget/function/uvc_configfs.c:1286:49: sparse: incorrect type in assignment (different base types)
   drivers/usb/gadget/function/uvc_configfs.c:1286:49:    expected unsigned short [unsigned] [usertype] w_height
   drivers/usb/gadget/function/uvc_configfs.c:1286:49:    got restricted __le16 [usertype] <noident>
>> drivers/usb/gadget/function/uvc_configfs.c:1287:49: sparse: incorrect type in assignment (different base types)
   drivers/usb/gadget/function/uvc_configfs.c:1287:49:    expected unsigned int [unsigned] [usertype] dw_min_bit_rate
   drivers/usb/gadget/function/uvc_configfs.c:1287:49:    got restricted __le32 [usertype] <noident>
>> drivers/usb/gadget/function/uvc_configfs.c:1288:49: sparse: incorrect type in assignment (different base types)
   drivers/usb/gadget/function/uvc_configfs.c:1288:49:    expected unsigned int [unsigned] [usertype] dw_max_bit_rate
   drivers/usb/gadget/function/uvc_configfs.c:1288:49:    got restricted __le32 [usertype] <noident>
>> drivers/usb/gadget/function/uvc_configfs.c:1289:49: sparse: incorrect type in assignment (different base types)
   drivers/usb/gadget/function/uvc_configfs.c:1289:49:    expected unsigned int [unsigned] [usertype] dw_max_video_frame_buffer_size
   drivers/usb/gadget/function/uvc_configfs.c:1289:49:    got restricted __le32 [usertype] <noident>
>> drivers/usb/gadget/function/uvc_configfs.c:1290:49: sparse: incorrect type in assignment (different base types)
   drivers/usb/gadget/function/uvc_configfs.c:1290:49:    expected unsigned int [unsigned] [usertype] dw_default_frame_interval
   drivers/usb/gadget/function/uvc_configfs.c:1290:49:    got restricted __le32 [usertype] <noident>
>> drivers/usb/gadget/function/uvc_configfs.c:1315:6: sparse: symbol 'uvcg_frame_drop' was not declared. Should it be static?
>> drivers/usb/gadget/function/uvc_configfs.c:1338:26: sparse: symbol 'to_uvcg_uncompressed' was not declared. Should it be static?
>> drivers/usb/gadget/function/uvc_configfs.c:1548:25: sparse: symbol 'uvcg_uncompressed_type' was not declared. Should it be static?
>> drivers/usb/gadget/function/uvc_configfs.c:1586:6: sparse: symbol 'uvcg_uncompressed_drop' was not declared. Should it be static?
>> drivers/usb/gadget/function/uvc_configfs.c:1610:19: sparse: symbol 'to_uvcg_mjpeg' was not declared. Should it be static?
>> drivers/usb/gadget/function/uvc_configfs.c:1761:25: sparse: symbol 'uvcg_mjpeg_type' was not declared. Should it be static?
>> drivers/usb/gadget/function/uvc_configfs.c:1793:6: sparse: symbol 'uvcg_mjpeg_drop' was not declared. Should it be static?
>> drivers/usb/gadget/function/uvc_configfs.c:2326:1: sparse: cast to restricted __le16
>> drivers/usb/gadget/function/uvc_configfs.c:2326:1: sparse: cast to restricted __le16
>> drivers/usb/gadget/function/uvc_configfs.c:1163:18: sparse: incorrect type in assignment (different base types)
   drivers/usb/gadget/function/uvc_configfs.c:1163:18:    expected unsigned int [unsigned] [usertype] <noident>
   drivers/usb/gadget/function/uvc_configfs.c:1163:18:    got restricted __le32 [usertype] <noident>

Please review and possibly fold the followup patch.

vim +816 drivers/usb/gadget/function/f_uvc.c

   810	
   811		cd = &opts->uvc_camera_terminal;
   812		cd->bLength			= UVC_DT_CAMERA_TERMINAL_SIZE(3);
   813		cd->bDescriptorType		= USB_DT_CS_INTERFACE;
   814		cd->bDescriptorSubType		= UVC_VC_INPUT_TERMINAL;
   815		cd->bTerminalID			= 1;
 > 816		cd->wTerminalType		= cpu_to_le16(0x0201);
   817		cd->bAssocTerminal		= 0;
   818		cd->iTerminal			= 0;
 > 819		cd->wObjectiveFocalLengthMin	= cpu_to_le16(0);
 > 820		cd->wObjectiveFocalLengthMax	= cpu_to_le16(0);
 > 821		cd->wOcularFocalLength		= cpu_to_le16(0);
   822		cd->bControlSize		= 3;
   823		cd->bmControls[0]		= 2;
   824		cd->bmControls[1]		= 0;
   825		cd->bmControls[2]		= 0;
   826	
   827		pd = &opts->uvc_processing;
   828		pd->bLength			= UVC_DT_PROCESSING_UNIT_SIZE(2);
   829		pd->bDescriptorType		= USB_DT_CS_INTERFACE;
   830		pd->bDescriptorSubType		= UVC_VC_PROCESSING_UNIT;
   831		pd->bUnitID			= 2;
   832		pd->bSourceID			= 1;
 > 833		pd->wMaxMultiplier		= cpu_to_le16(16*1024);
   834		pd->bControlSize		= 2;
   835		pd->bmControls[0]		= 1;
   836		pd->bmControls[1]		= 0;
   837		pd->iProcessing			= 0;
   838	
   839		od = &opts->uvc_output_terminal;
   840		od->bLength			= UVC_DT_OUTPUT_TERMINAL_SIZE;
   841		od->bDescriptorType		= USB_DT_CS_INTERFACE;
   842		od->bDescriptorSubType		= UVC_VC_OUTPUT_TERMINAL;
   843		od->bTerminalID			= 3;
 > 844		od->wTerminalType		= cpu_to_le16(0x0101);
   845		od->bAssocTerminal		= 0;
   846		od->bSourceID			= 2;
   847		od->iTerminal			= 0;

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
