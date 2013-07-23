Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab3GWDIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 23:08:54 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:40168 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab3GWDIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 23:08:53 -0400
Message-ID: <51EDF3C2.1060809@gmail.com>
Date: Tue, 23 Jul 2013 05:08:50 +0200
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [Re:] 3.11-rc2: WARNING: at kernel/time/tick-broadcast.c:667
References: <51EDD806.70507@gmail.com>
In-Reply-To: <51EDD806.70507@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


And one for 3.11-rc2,
…
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
PCI-DMA: Resuming GART IOMMU
PCI-DMA: Restoring GART aperture settings
Enabling non-boot CPUs ...
smpboot: Booting Node 0 Processor 1 APIC 0x1
[Firmware Bug]: cpu 1, try to use APIC500 (LVT offset 0) for vector
0x400, but the register is already in use for vector 0xf9 on another cpu
perf: IBS APIC setup failed on cpu #1
process: Switch to broadcast mode on CPU1
CPU1 is up
smpboot: Booting Node 0 Processor 2 APIC 0x2
------------[ cut here ]------------
3.11-rc2: WARNING: CPU: 1 PID: 0 at kernel/time/tick-broadcast.c:667
tick_broadcast_oneshot_control+0x170/0x180()
Modules linked in: raid1 nouveau video mxm_wmi i2c_algo_bit
drm_kms_helper ttm drm i2c_core wmi
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.11.0-0.rc2.git0.1.fc20.x86_64 #1
Hardware name: Gigabyte Technology Co., Ltd. M720-US3/M720-US3, BIOS F7n
09/07/2010
 0000000000000009 ffff880129b27df0 ffffffff8164df84 0000000000000000
 ffff880129b27e28 ffffffff810670bd 0000000000000001 0000000000000004
 ffff88012fc4dc80 0000000000000002 ffffffff81c238c0 ffff880129b27e38
Call Trace:
 [<ffffffff8164df84>] dump_stack+0x45/0x56
 [<ffffffff810670bd>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff8106719a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff810c00a0>] tick_broadcast_oneshot_control+0x170/0x180
 [<ffffffff810be908>] clockevents_notify+0x178/0x1a0
 [<ffffffff8101aec5>] amd_e400_idle+0x75/0x100
 [<ffffffff8101b676>] arch_cpu_idle+0x26/0x30
 [<ffffffff810b64ee>] cpu_startup_entry+0xce/0x280
 [<ffffffff810be9ec>] ? clockevents_register_device+0xbc/0x120
 [<ffffffff8103ed77>] start_secondary+0x217/0x2c0
---[ end trace c4f6f2078bf43f3e ]---
[Firmware Bug]: cpu 2, try to use APIC500 (LVT offset 0) for vector
0x400, but the register is already in use for vector 0xf9 on another cpu
perf: IBS APIC setup failed on cpu #2
process: Switch to broadcast mode on CPU2
CPU2 is up
smpboot: Booting Node 0 Processor 3 APIC 0x3
[Firmware Bug]: cpu 3, try to use APIC500 (LVT offset 0) for vector
0x400, but the register is already in use for vector 0xf9 on another cpu
perf: IBS APIC setup failed on cpu #3
process: Switch to broadcast mode on CPU3
CPU3 is up
ACPI: Waking up from system sleep state S3
…

CONF.
http://kojipkgs.fedoraproject.org//packages/kernel/3.11.0/0.rc2.git0.1.fc20/data/logs/x86_64/build.log


poma


