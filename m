Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964955AbaD3Rkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 13:40:33 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:37309 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbaD3Rkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 13:40:31 -0400
MIME-Version: 1.0
In-Reply-To: <s5h8uqmixkz.wl%tiwai@suse.de>
References: <CAAWf5=s-hQ2xMtLxNFXjXH6UGmQtgkrzS9zWj3z_CTq41XGpdw@mail.gmail.com>
 <s5h4n1ov8h9.wl%tiwai@suse.de> <CAAWf5=usG_Q-11kMd=58mVEELb8b0nyBXanaDqKqCGSFVJP0Rw@mail.gmail.com>
 <s5hbnvk9pxn.wl%tiwai@suse.de> <CAAWf5=tENLeh8VeM2i_FwYiqGYtZEMZ625XQTjx6nutE=A46Mg@mail.gmail.com>
 <s5hioprs4hb.wl%tiwai@suse.de> <CAAWf5=tzBW5pBNBnO1URoo1Z1O-rTnVOpeAyMs73tqYNyjF-_Q@mail.gmail.com>
 <s5h8uqmixkz.wl%tiwai@suse.de>
From: Bryan Quigley <gquigs@gmail.com>
Date: Wed, 30 Apr 2014 13:40:11 -0400
Message-ID: <CAAWf5=s=jrUa2wi6z5djW4rWA-PUS0q5pN3jU+ph0s8vxu65GQ@mail.gmail.com>
Subject: Re: PROBLEM: Pulseaudio hung at schedule in 3.15-rc1
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hm, what about the one below instead?
>
>
> Takashi

It works now!  Still gives me some errors, but both the webcam and
microphone function fine..

On pluging it in, all seems normal:
Apr 30 13:33:29 dell-laptop kernel: [  467.144143] usb 2-2: new
high-speed USB device number 4 using ehci-pci
Apr 30 13:33:30 dell-laptop kernel: [  467.492931] usb 2-2: New USB
device found, idVendor=046d, idProduct=0825
Apr 30 13:33:30 dell-laptop kernel: [  467.492939] usb 2-2: New USB
device strings: Mfr=0, Product=0, SerialNumber=2
Apr 30 13:33:30 dell-laptop kernel: [  467.492943] usb 2-2:
SerialNumber: 0911F220
Apr 30 13:33:30 dell-laptop kernel: [  467.493799] uvcvideo: Found UVC
1.00 device <unnamed> (046d:0825)
Apr 30 13:33:30 dell-laptop kernel: [  467.590713] input: UVC Camera
(046d:0825) as /devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2:1.0/input/input20
Apr 30 13:33:31 dell-laptop kernel: [  468.753801] usb 2-2: set
resolution quirk: cval->res = 384

But on any access (sudo lsusb -v, open webcam, etc), it will give:
Apr 30 13:35:21 dell-laptop kernel: [  578.788135] usb 2-2: reset
high-speed USB device number 4 using ehci-pci
Apr 30 13:35:21 dell-laptop kernel: [  579.142380] snd-usb-audio
2-2:1.2: reset_resume error -5

Doesn't seem to affect performance at all though..

Thanks again,
Bryan
