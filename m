Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbaAOPfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:35:00 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:60608 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbaAOPe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:34:57 -0500
Date: Wed, 15 Jan 2014 16:34:46 +0100
From: Robert Richter <rric@kernel.org>
To: poma <pomidorabelisima@gmail.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [Firmware Bug]: cpu 1, try to use APIC500 (LVT offset 0) for
 vector 0x400
Message-ID: <20140115153446.GA5701@rric.localhost>
References: <52CF6727.8050804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CF6727.8050804@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.01.14 04:21:11, poma wrote:
> 
> Robert, is there a patch for this case?
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1152484/comments/12

I just sent a patch to lkml that fixes this:

 https://lkml.kernel.org/r/1389797849-5565-1-git-send-email-rric.net@gmail.com

-Robert

> 
> 3.10.2 - 3.13.0-0.rc7:
> ACPI: Low-level resume complete
> PM: Restoring platform NVS memory
> microcode: CPU0: new patch_level=0x010000c8
> Enabling non-boot CPUs ...
> x86: Booting SMP configuration:
> smpboot: Booting Node 0 Processor 1 APIC 0x1
> [Firmware Bug]: cpu 1, try to use APIC500 (LVT offset 0) for vector
> 0x400, but the register is already in use for vector 0xf9 on another cpu
> perf: IBS APIC setup failed on cpu #1
> kvm: enabling virtualization on CPU1
> process: Switch to broadcast mode on CPU1
> microcode: CPU1: new patch_level=0x010000c8
> CPU1 is up
> smpboot: Booting Node 0 Processor 2 APIC 0x2
> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.13.0-0.rc7.git2.2.fc21.x86_64 #1
> [Firmware Bug]: cpu 2, try to use APIC500 (LVT offset 0) for vector
> 0x400, but the register is already in use for vector 0xf9 on another cpu
> perf: IBS APIC setup failed on cpu #2
> kvm: enabling virtualization on CPU2
> process: Switch to broadcast mode on CPU2
> microcode: CPU2: new patch_level=0x010000c8
> CPU2 is up
> smpboot: Booting Node 0 Processor 3 APIC 0x3
> [Firmware Bug]: cpu 3, try to use APIC500 (LVT offset 0) for vector
> 0x400, but the register is already in use for vector 0xf9 on another cpu
> perf: IBS APIC setup failed on cpu #3
> kvm: enabling virtualization on CPU3
> process: Switch to broadcast mode on CPU3
> microcode: CPU3: new patch_level=0x010000c8
> CPU3 is up
> ACPI: Waking up from system sleep state S3
> 
> 
> poma
> 
