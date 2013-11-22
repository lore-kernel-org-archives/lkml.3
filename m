Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab3KVCEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 21:04:20 -0500
Received: from mx-a.atmailcloud.com ([65.61.115.90]:64629 "EHLO
	ultra2.atmailcloud.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab3KVCER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 21:04:17 -0500
X-Greylist: delayed 1385 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Nov 2013 21:04:17 EST
MIME-Version: 1.0
Date: Thu, 21 Nov 2013 20:41:10 -0500
Message-ID: <CA+tRDaL=RSjG=Fdw4+6hia8WWM5oa_JoZBA+HFOA6mgqTunb0A@mail.gmail.com>
Subject: DisplayLink driver
From: Alejandro Bonilla <abonilla@linuxwireless.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a Lenovo ThinkVision LT1421 which I guess uses the DisplayLink
chipset 1.x, I'm also using kernel 3.11.6. The device is recognized
[  997.279496] usb 2-1.5: new high-speed USB device number 4 using ehci-pci
[  997.344494] usb 2-1.5: device descriptor read/64, error 64
[  997.534746] usb 2-1.5: New USB device found, idVendor=17e9, idProduct=03e0
[  997.534753] usb 2-1.5: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[  997.534756] usb 2-1.5: Product: Lenovo LT1421 wide
[  997.534759] usb 2-1.5: Manufacturer: DisplayLink
[  997.534761] usb 2-1.5: SerialNumber: 6V9BZHC1
[  997.543996] [drm] vendor descriptor length:17 data:17 5f 01 00 15
05 00 01 03 00 04
[  997.640811] udl 2-1.5:1.0: fb1: udldrmfb frame buffer device
[  997.640816] udl 2-1.5:1.0: registered panic notifier
[  997.640822] [drm] Initialized udl 0.0.1 20120220 on minor 1
[  997.640886] usbcore: registered new interface driver udl

But xrandr is not recognizing the device/screen.

So the question is, which driver supports it, the UDL or UDLFB driver?

(please cc me, I'm not subscribed)

Thanks
