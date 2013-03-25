Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004Ab3CYWEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 18:04:16 -0400
Received: from solon01.hs-niederrhein.de ([194.94.120.28]:54593 "EHLO
	solon01.hs-niederrhein.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab3CYWEO convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 25 Mar 2013 18:04:14 -0400
Message-Id: <5150D7E70200009700005088@gwia02n.pmx.stud.hn.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Mon, 25 Mar 2013 23:04:07 +0100
From: "Florian Scholz" <florian.scholz@stud.hn.de>
To: <perex@perex.cz>, <tiwai@suse.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: ALSA: problems setting up usb devices using kernel 3.9.0-rc4+
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jarsolav and Takashi, 

I'm experiencing some ALSA problems during the set up of my Creative X-Fi HD USB sound card and the device isn't in the device list. The kernel is 3.9.0-rc4+ (GIT)

...
[   39.949914] ALSA sound/usb/pcm.c:346 5:4:1: usb_set_interface failed (-32)
[   39.950291] ALSA sound/usb/pcm.c:346 5:4:1: usb_set_interface failed (-32)
[   39.950918] ALSA sound/usb/pcm.c:346 5:4:1: usb_set_interface failed (-32)
[   39.951292] ALSA sound/usb/pcm.c:346 5:4:1: usb_set_interface failed (-32)
[   39.951665] ALSA sound/usb/pcm.c:346 5:4:1: usb_set_interface failed (-32)
[   39.952056] ALSA sound/usb/pcm.c:346 5:4:1: usb_set_interface failed (-32)
[   39.952542] ALSA sound/usb/pcm.c:346 5:4:1: usb_set_interface failed (-32)
[   39.953294] ALSA sound/usb/pcm.c:346 5:4:1: usb_set_interface failed (-32)
[   39.953665] ALSA sound/usb/pcm.c:346 5:4:1: usb_set_interface failed (-32)
[   39.954047] ALSA sound/usb/pcm.c:346 5:4:1: usb_set_interface failed (-32)
...

But after a replug, the sound card works until the next reboot

[  274.487794] usb 1-1.5: USB disconnect, device number 5
[  275.432461] usb 1-1.5: new full-speed USB device number 6 using ehci-pci
[  275.520713] usb 1-1.5: New USB device found, idVendor=041e, idProduct=30d7
[  275.520718] usb 1-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  275.520721] usb 1-1.5: Product: USB Sound Blaster HD
[  275.520724] usb 1-1.5: Manufacturer: Creative Technology
[  275.520726] usb 1-1.5: SerialNumber: 00000AFE
[  275.542566] ALSA sound/usb/mixer.c:932 2:0: cannot get min/max values for control 2 (id 2)
[  275.545621] input: Creative Technology USB Sound Blaster HD as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5:1.5/input/input7
[  275.546064] hid-generic 0003:041E:30D7.0006: input,hidraw4: USB HID v1.11 Device [Creative Technology USB Sound Blaster HD] on usb-0000:00:1a.0-1.5/input5
[  277.909789] ALSA sound/usb/mixer.c:2263 status interrupt: c0 02


Please help me to fix this problem!

Greets from Germany

Florian Scholz
 
