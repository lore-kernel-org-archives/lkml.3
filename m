Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbaAJDWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 22:22:15 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:61872 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbaAJDVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 22:21:14 -0500
Message-ID: <52CF6727.8050804@gmail.com>
Date: Fri, 10 Jan 2014 04:21:11 +0100
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Robert Richter <rric@kernel.org>
CC: Robert Richter <robert.richter@amd.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [Firmware Bug]: cpu 1, try to use APIC500 (LVT offset 0) for vector
 0x400
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Robert, is there a patch for this case?
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1152484/comments/12

3.10.2 - 3.13.0-0.rc7:
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
microcode: CPU0: new patch_level=0x010000c8
Enabling non-boot CPUs ...
x86: Booting SMP configuration:
smpboot: Booting Node 0 Processor 1 APIC 0x1
[Firmware Bug]: cpu 1, try to use APIC500 (LVT offset 0) for vector
0x400, but the register is already in use for vector 0xf9 on another cpu
perf: IBS APIC setup failed on cpu #1
kvm: enabling virtualization on CPU1
process: Switch to broadcast mode on CPU1
microcode: CPU1: new patch_level=0x010000c8
CPU1 is up
smpboot: Booting Node 0 Processor 2 APIC 0x2
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.13.0-0.rc7.git2.2.fc21.x86_64 #1
[Firmware Bug]: cpu 2, try to use APIC500 (LVT offset 0) for vector
0x400, but the register is already in use for vector 0xf9 on another cpu
perf: IBS APIC setup failed on cpu #2
kvm: enabling virtualization on CPU2
process: Switch to broadcast mode on CPU2
microcode: CPU2: new patch_level=0x010000c8
CPU2 is up
smpboot: Booting Node 0 Processor 3 APIC 0x3
[Firmware Bug]: cpu 3, try to use APIC500 (LVT offset 0) for vector
0x400, but the register is already in use for vector 0xf9 on another cpu
perf: IBS APIC setup failed on cpu #3
kvm: enabling virtualization on CPU3
process: Switch to broadcast mode on CPU3
microcode: CPU3: new patch_level=0x010000c8
CPU3 is up
ACPI: Waking up from system sleep state S3


poma

