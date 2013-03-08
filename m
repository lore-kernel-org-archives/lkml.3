Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab3CHUTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 15:19:13 -0500
Received: from nm11.access.bullet.mail.sp2.yahoo.com ([98.139.44.138]:31863
	"EHLO nm11.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752670Ab3CHUTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 15:19:12 -0500
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Mar 2013 15:19:12 EST
X-Yahoo-Newman-Id: 359075.87349.bm@smtp101.rog.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: kkU1aR8VM1kQsLLB27AkBj1rbr62dmioW8vUbf7awXEv6BC
 uGu3scQDSXBDbxktMgxF6YUKr4vMSvhjws1tDx.0NtsakghqEtrETcsM07oK
 EOsJbFKiAhAN5b8dzdnpQp7YHWKcjzJAmpTKlvFy.7HY8lPKClUuMe6nmLsV
 dRxDR0.P0PJsH_3V3MnJd2wXaLIaf0w1o72kUXScWW7owS.WbkyUAxtsB8wD
 IWlsJfCZIqna7zGrV3Gdj7567OKicDc7PfoJhLHZlLrZ1_9ThxTsJDxDglHL
 eh1bk2.kZUb237sxvAJ4yfGwL0j8Zq4yhQa3pC13bGmLkgrp7s98B1J43I9J
 .Pa4p1nBS0pTrobbbVbNmkNK_770buUAuQWkHZJ9x6BDYMZ_EhvhOxI4Jkiv
 sfbPRcCDdQLw0mZeJJ5qjAGeymH8owkhsi5mupZNxtssYDfd2aHOLSjJUOZZ
 _mXwMfekv0APiQGHVUNy8Vr48V04tu5w-
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
From: Shawn Starr <shawn.starr@rogers.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [Linux 3.8/3.9-rc1][alsa][hda] Problem with automute on HDA CX20561 (Hermosa) - Persistent even after power off
Date: Fri, 08 Mar 2013 15:13 -0500
Message-ID: <227130559.2YHlkDm1H6@segfault.sh0n.net>
Organization: sh0n.net
User-Agent: KMail/4.9.5 (Linux/3.8.0-2.fc19.x86_64; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2760279.2HbRmcDmlJ@segfault.sh0n.net>
References: <2760279.2HbRmcDmlJ@segfault.sh0n.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 08, 2013 03:06:12 PM Shawn Starr wrote:
> Hello folks,
> 
> All of a sudden, it worked fine in Linux kernel 3.8, I believe after booting
> Linux kernel 3.9 (which has ALSA HDA changes). I can no longer hear audio
> from speakers on laptop. If I plug in headphones audio works.
> 
> [ 18.434846] hda_codec: CX20561 (Hermosa): BIOS auto-probing.
> [ 18.434932] ALSA sound/pci/hda/hda_auto_parser.c:306 autoconfig:
> line_outs=1 (0x1a/0x0/0x0/0x0/0x0) type:speaker [ 18.434934] ALSA
> sound/pci/hda/hda_auto_parser.c:310 speaker_outs=0 (0x0/0x0/0x0/0x0/0x0) [
> 18.434936] ALSA sound/pci/hda/hda_auto_parser.c:314 hp_outs=2
> (0x19/0x16/0x0/0x0/0x0) [ 18.434937] ALSA
> sound/pci/hda/hda_auto_parser.c:315 mono: mono_out=0x0 [ 18.434939] ALSA
> sound/pci/hda/hda_auto_parser.c:318 dig-out=0x1c/0x0 [ 18.434940] ALSA
> sound/pci/hda/hda_auto_parser.c:319 inputs:
> [ 18.434942] ALSA sound/pci/hda/hda_auto_parser.c:323 Mic=0x18
> [ 18.434944] ALSA sound/pci/hda/hda_auto_parser.c:323 Internal Mic=0x1d
> [ 18.434945] ALSA sound/pci/hda/hda_auto_parser.c:323 Dock Mic=0x17
> [ 18.435835] ALSA sound/pci/hda/patch_conexant.c:4587 hda_codec: Enable
> sync_write for stable communication [ 18.443473] input: HDA Intel Dock Mic
> as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9 [ 18.443563] input:
> HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10 [
> 18.443614] input: HDA Intel Headphone as
> /devices/pci0000:00/0000:00:1b.0/sound/card0/input11 [ 18.443674] input:
> HDA Intel Dock Headphone as
> /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
> 
> I did a hard power off, even booted into a Windows OS to see the windows
> kernel driver might reset the autio ports and it didn't fix this even, did
> the kernel driver reprogram the hardware badly somewhere? How can I fix
> this?
> 
> Thanks,
> Shawn

Sorry for the noise, this is fixed, I found the cause.

Thanks,
Shawn
