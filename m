Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962Ab3GBTlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 15:41:15 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:35851 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab3GBTlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 15:41:11 -0400
MIME-Version: 1.0
In-Reply-To: <004501ce7754$25c5a0b0$7150e210$@lucidpixels.com>
References: <004101ce7752$989eca50$c9dc5ef0$@lucidpixels.com>
	<CADnq5_ODTumYOq19BMuF6vJNq+RtUA631XqyUet4qzjVU1tg-Q@mail.gmail.com>
	<004501ce7754$25c5a0b0$7150e210$@lucidpixels.com>
Date: Tue, 2 Jul 2013 15:41:10 -0400
Message-ID: <CADnq5_Mj=RBTpX9i2Rg4qQK83WLWz7qbFGepw74O2vZx789GCg@mail.gmail.com>
Subject: Re: 3.10 kernel: [drm:evergreen_startup] *ERROR* radeon: error
 initializing UVD (-1).
From: Alex Deucher <alexdeucher@gmail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 2, 2013 at 2:44 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>
> -----Original Message-----
> From: Alex Deucher [mailto:alexdeucher@gmail.com]
> Sent: Tuesday, July 02, 2013 2:36 PM
> To: Justin Piszcz
> Cc: linux-kernel@vger.kernel.org; dri-devel@lists.freedesktop.org
> Subject: Re: 3.10 kernel: [drm:evergreen_startup] *ERROR* radeon: error
> initializing UVD (-1).
>
>> The screen goes black for ~5 seconds and then come back on.
>> Not sure if this has been reported or not (w/CEDAR chipset) but FYI.
>
> Make sure you have the the latest CEDAR_rlc.bin in addition to
> CYPRESS_uvd.bin and make sure the latest images are available in your
> initrd or kernel image, etc.
>
> Alex
>
> --
>
> Hi,
>
> Even with the latest (confirmed below) and built-in to the kernel:
>
> $ git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git
> Cloning into 'linux-firmware'...
> remote: Counting objects: 2210, done.
> remote: Compressing objects: 100% (1102/1102), done.
> remote: Total 2210 (delta 1123), reused 2113 (delta 1073)
> Receiving objects: 100% (2210/2210), 39.84 MiB | 6.49 MiB/s, done.
> Resolving deltas: 100% (1123/1123), done.
> $ date
> Tue Jul  2 14:39:19 EDT 2013
>
> 2b244d41832f46382bfbb8994522dcdd  d/linux-firmware/radeon/CEDAR_me.bin
> 23915e382ea0d2f2491a19146ca3001c  d/linux-firmware/radeon/CEDAR_pfp.bin
> e8770d3d588f24dc6f1a8609c9db3467  d/linux-firmware/radeon/CEDAR_rlc.bin
> fb23b281dcc94a035d374e709c9842bd  d/linux-firmware/radeon/CYPRESS_uvd.bin
>
> Current system firmware (/lib/firmware/radeon):
> $ for i in $CONFIG_EXTRA_FIRMWARE; do md5sum $i; done
> 2b244d41832f46382bfbb8994522dcdd  radeon/CEDAR_me.bin
> 23915e382ea0d2f2491a19146ca3001c  radeon/CEDAR_pfp.bin
> e8770d3d588f24dc6f1a8609c9db3467  radeon/CEDAR_rlc.bin
> fb23b281dcc94a035d374e709c9842bd  radeon/CYPRESS_uvd.bin
>
> CONFIG_EXTRA_FIRMWARE="radeon/CEDAR_me.bin radeon/CEDAR_pfp.bin
> radeon/CEDAR_rlc.bin radeon/CYPRESS_uvd.bin"
>
> Same issue.

Please open a bug (product: DRI, component: DRM/Radeon):
https://bugs.freedesktop.org
and attach your dmesg output and xorg log.

Alex
