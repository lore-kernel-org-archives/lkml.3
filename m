Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab3GBSgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 14:36:18 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:35859 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab3GBSgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 14:36:16 -0400
MIME-Version: 1.0
In-Reply-To: <004101ce7752$989eca50$c9dc5ef0$@lucidpixels.com>
References: <004101ce7752$989eca50$c9dc5ef0$@lucidpixels.com>
Date: Tue, 2 Jul 2013 14:36:14 -0400
Message-ID: <CADnq5_ODTumYOq19BMuF6vJNq+RtUA631XqyUet4qzjVU1tg-Q@mail.gmail.com>
Subject: Re: 3.10 kernel: [drm:evergreen_startup] *ERROR* radeon: error
 initializing UVD (-1).
From: Alex Deucher <alexdeucher@gmail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 2, 2013 at 2:33 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> Hello,
>
> I use an ATI graphics card (PCI-e x1) for a server:
> Card: [AMD/ATI] Park [Mobility Radeon HD 5430]
>
> I upgraded my kernel from 3.9.x to 3.10, after rebooting I found the driver
> now wants a new firmware:
> radeon 0000:05:00.0: radeon_uvd: Can't load firmware
> "radeon/CYPRESS_uvd.bin"
>
> I pulled the latest firmware down (and also updated the others) and
> rebooted:
> CONFIG_EXTRA_FIRMWARE="radeon/CEDAR_me.bin radeon/CEDAR_pfp.bin
> radeon/CEDAR_rlc.bin radeon/CYPRESS_uvd.bin"
>
> Then have this issue:
> [drm] radeon: irq initialized.
> [drm:evergreen_startup] *ERROR* radeon: error initializing UVD (-1).
>
> The screen goes black for ~5 seconds and then come back on.
> Not sure if this has been reported or not (w/CEDAR chipset) but FYI.

Make sure you have the the latest CEDAR_rlc.bin in addition to
CYPRESS_uvd.bin and make sure the latest images are available in your
initrd or kernel image, etc.

Alex


>
> Kernel config:
> http://home.comcast.net/~jpiszcz/20130702/config-3.10-4.txt
>
> Full dmesg:
> http://home.comcast.net/~jpiszcz/20130702/full-dmesg.txt
>
> Possibly related:
> http://lists.opensuse.org/opensuse-bugs/2013-06/msg00053.html
> https://bugzilla.novell.com/show_bug.cgi?id=822777
> https://bugzilla.novell.com/show_bug.cgi?id=822777#c0
> http://www.mail-archive.com/dri-devel@lists.freedesktop.org/msg38066.html
> https://bugs.freedesktop.org/show_bug.cgi?id=63935
>
> Snippet:
> [    2.033535] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to
> reset the VCPU!!!
> [    3.053742] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to
> reset the VCPU!!!
> [    4.073985] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to
> reset the VCPU!!!
> [    5.094192] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to
> reset the VCPU!!!
> [    6.114405] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to
> reset the VCPU!!!
> [    7.134611] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to
> reset the VCPU!!!
> [    8.154824] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to
> reset the VCPU!!!
> [    9.175044] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to
> reset the VCPU!!!
> [   10.195251] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to
> reset the VCPU!!!
> [   11.215464] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to
> reset the VCPU!!!
> [   11.235537] [drm:r600_uvd_init] *ERROR* UVD not responding, giving up!!!
> [   11.235607] [drm:evergreen_startup] *ERROR* radeon: error initializing
> UVD (-1).
>
> Justin.
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
