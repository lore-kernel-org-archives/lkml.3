Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab3CHUGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 15:06:20 -0500
Received: from nm12.access.bullet.mail.mud.yahoo.com ([66.94.237.213]:47120
	"EHLO nm12.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751264Ab3CHUGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 15:06:19 -0500
X-Yahoo-Newman-Id: 208053.44871.bm@smtp101.rog.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: NdPLGKMVM1k_6tLG1E3f0dV0DdxYNd694CeqjUwlfIjXEem
 5f.bhtPMPEskTpOdVKXLSbQKEZ3PFS6_QaxQoIwKWyuZ12iiNu2u5KKpuvBQ
 9hdGxmXCM1dWdx43Ubsh6XXFNZWjr_91Q8t9IRZklXjOCtcVXHMAFKECQ6Hi
 BGq0KTr4Mct6nS9jgo5ptw5bfE4RS4.q2q_66T6aY3XNouc.HUUcWPXUlKq8
 nLUhp8VfKYuAPMA_pzaD9F8r.s2e.d7_2KOf88yrKmIAyv.nOvbwijjKun3I
 A.kHdcuChyekHwPIt47X46S7qrs.TeiD_DORc2Y9VfZwlCsOzjpF.yW6k_aJ
 jQbmmwDs6F2JPrWLq1Yn.rZQQml6MofR8skclggAA1iEwidg2jwxdt8G9dZt
 JxJHAFx09n8heYhBZxTYznLnsfov6gghiJYP7fvsReD8ahMrkSuUjPm.hv11
 Rx.tW9Zz0IKU0Cb2jzccRS9.cnE7Z1AU-
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
From: Shawn Starr <shawn.starr@rogers.com>
To: linux-kernel@vger.kernel.org
Subject: [Linux 3.8/3.9-rc1][alsa][hda] Problem with automute on HDA CX20561 (Hermosa) - Persistent even after power off
Date: Fri, 08 Mar 2013 15:06:12 -0500
Message-ID: <2760279.2HbRmcDmlJ@segfault.sh0n.net>
Organization: sh0n.net
User-Agent: KMail/4.9.5 (Linux/3.8.0-2.fc19.x86_64; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello folks,

All of a sudden, it worked fine in Linux kernel 3.8, I believe after booting Linux kernel 3.9 (which has ALSA HDA changes). I can no longer hear audio from speakers on laptop. If I plug in headphones audio works.

[ 18.434846] hda_codec: CX20561 (Hermosa): BIOS auto-probing.
[ 18.434932] ALSA sound/pci/hda/hda_auto_parser.c:306 autoconfig: line_outs=1 (0x1a/0x0/0x0/0x0/0x0) type:speaker
[ 18.434934] ALSA sound/pci/hda/hda_auto_parser.c:310 speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[ 18.434936] ALSA sound/pci/hda/hda_auto_parser.c:314 hp_outs=2 (0x19/0x16/0x0/0x0/0x0)
[ 18.434937] ALSA sound/pci/hda/hda_auto_parser.c:315 mono: mono_out=0x0
[ 18.434939] ALSA sound/pci/hda/hda_auto_parser.c:318 dig-out=0x1c/0x0
[ 18.434940] ALSA sound/pci/hda/hda_auto_parser.c:319 inputs:
[ 18.434942] ALSA sound/pci/hda/hda_auto_parser.c:323 Mic=0x18
[ 18.434944] ALSA sound/pci/hda/hda_auto_parser.c:323 Internal Mic=0x1d
[ 18.434945] ALSA sound/pci/hda/hda_auto_parser.c:323 Dock Mic=0x17
[ 18.435835] ALSA sound/pci/hda/patch_conexant.c:4587 hda_codec: Enable sync_write for stable communication
[ 18.443473] input: HDA Intel Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[ 18.443563] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[ 18.443614] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[ 18.443674] input: HDA Intel Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12

I did a hard power off, even booted into a Windows OS to see the windows kernel driver might reset the autio ports and it didn't fix this even, did the kernel driver reprogram the hardware badly somewhere? How can I fix this?

Thanks,
Shawn

