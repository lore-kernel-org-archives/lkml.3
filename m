Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245Ab3EFWWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 18:22:50 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:57467 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756605Ab3EFWWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:22:48 -0400
MIME-Version: 1.0
Date: Mon, 6 May 2013 18:22:47 -0400
Message-ID: <CAOULuObQq+WPf97LdsD5kN6cq=E9TvaHzqGzdKSWRme-Nk+WQQ@mail.gmail.com>
Subject: Immediate wakeup after suspend
From: Parag Warudkar <parag.lkml@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometime after 3.9 my iMac has started to resume almost immediately
after suspend.  Even with 3.9 it was all working as expected.

Relevant dmesg output below. Any way to find out the source of the wakeup?

Thanks,
Parag

Linux parag-iMac 3.9.0+ #5 SMP PREEMPT Mon May 6 17:01:19 EDT 2013
x86_64 x86_64 x86_64 GNU/Linux

[ 3631.441257] PM: Entering mem sleep
[ 3631.441274] Suspending console(s) (use no_console_suspend to debug)
[ 3631.441825] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 3631.442003] sd 0:0:0:0: [sda] Stopping disk
[ 3631.755076] PM: suspend of devices complete after 313.257 msecs
[ 3631.755219] PM: late suspend of devices complete after 0.134 msecs
[ 3631.795185] PM: noirq suspend of devices complete after 39.904 msecs
[ 3631.821922] pcieport 0000:00:1c.1: power state changed by ACPI to D0
[ 3631.915378] PM: noirq resume of devices complete after 119.999 msecs
[ 3631.915459] PM: early resume of devices complete after 0.062 msecs
[ 3631.915525] ahci 0000:00:1f.2: setting latency timer to 64
[ 3631.915609] ehci-pci 0000:00:1a.7: setting latency timer to 64
[ 3631.915654] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[ 3631.915690] usb usb1: root hub lost power or was reset
[ 3631.915709] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[ 3631.915770] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[ 3631.915792] usb usb2: root hub lost power or was reset
[ 3631.915804] ehci-pci 0000:00:1d.7: setting latency timer to 64
[ 3631.915821] snd_hda_intel 0000:01:00.1: irq 48 for MSI/MSI-X
[ 3631.918662] [drm] probing gen 2 caps for device 8086:101 = 2212d02/0
[ 3631.918665] [drm] PCIE gen 2 link speeds already enabled
[ 3631.921479] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[ 3631.921584] radeon 0000:01:00.0: WB enabled
