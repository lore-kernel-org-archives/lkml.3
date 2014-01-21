Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbaAUNgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 08:36:17 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:49685 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbaAUNgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 08:36:14 -0500
Message-ID: <52DE77CB.6060003@gmail.com>
Date: Tue, 21 Jan 2014 14:36:11 +0100
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Robert Richter <rric@kernel.org>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [Firmware Bug]: cpu 1, try to use APIC500 (LVT offset 0) for
 vector 0x400
References: <52CF6727.8050804@gmail.com> <20140115153446.GA5701@rric.localhost>
In-Reply-To: <20140115153446.GA5701@rric.localhost>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.01.2014 16:34, Robert Richter wrote:
> On 10.01.14 04:21:11, poma wrote:
>>
>> Robert, is there a patch for this case?
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1152484/comments/12
> 
> I just sent a patch to lkml that fixes this:
> 
>  https://lkml.kernel.org/r/1389797849-5565-1-git-send-email-rric.net@gmail.com
> 
> -Robert
> 

All right!
…
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
LVT offset 1 assigned for vector 0x400
IBS: LVT offset 1 assigned
microcode: CPU0: new patch_level=0x010000c8
Enabling non-boot CPUs ...
x86: Booting SMP configuration:
smpboot: Booting Node 0 Processor 1 APIC 0x1
kvm: enabling virtualization on CPU1
process: Switch to broadcast mode on CPU1
microcode: CPU1: new patch_level=0x010000c8
CPU1 is up
smpboot: Booting Node 0 Processor 2 APIC 0x2
kvm: enabling virtualization on CPU2
process: Switch to broadcast mode on CPU2
microcode: CPU2: new patch_level=0x010000c8
CPU2 is up
smpboot: Booting Node 0 Processor 3 APIC 0x3
kvm: enabling virtualization on CPU3
process: Switch to broadcast mode on CPU3
microcode: CPU3: new patch_level=0x010000c8
CPU3 is up
ACPI: Waking up from system sleep state S3
…
Lookin good!
Thanks!


poma


