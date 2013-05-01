Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab3EAE5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 00:57:10 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:27601 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab3EAE5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 00:57:03 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-65-5180a09c8637
Date: Wed, 01 May 2013 04:57:00 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: mips; boot fail after merge 3.9+
To: "ralf@linux-mips.org" <ralf@linux-mips.org>, tglx@linutronix.de,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130501041444208@eunb.song
Msgkey: 20130501041444208@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130501041444208@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <20522420.158691367384219315.JavaMail.weblogic@epml17>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+Ztu6cBQ2BBmdf2Fhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MFRf2MBc8MauYPPMyawPjGtMuRk4OIQEViZb/3xlBbAkBE4nN
	u66wQdhiEhfurQeyuYBqljFKnNj+gQWm6OqTlWwQzfMZJa6tkgaxWYAGrezpBRvEJqAt8fbL
	A1YQW1hAU+LOo0PMIINEBFoZJVafuQFWxCzgKPHo8h1miEHyEpNPX2YHsXkFBCVOznwCtUxJ
	4sXuhawQcWWJH59OM0HEJSRmTb/ACmHzSsxofwpVLycx7esaZghbWuL8rA2MMN8s/v4YKs4v
	cez2DqA5HGC9T+4Hw4zZvfkL1PMCElPPHIRqVZdo2TAdyuaTWLPwLQvMmF2nljPD9N7fMpcJ
	4i1FiSndD9khbC2JLz/2saF6iwPIdpL4sVxnAqPyLCSZWUi6ZyHpRlazgJFlFaNoakFyQXFS
	epGRXnFibnFpXrpecn7uJkZIWujbwXjzgPUhxmRglExklhJNzgemlbySeENjMyMLUxNTYyNz
	SzPShJXEedVarAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MAaWeJ3yWXI06Zjer0txnFka
	U+6dbt9py/x4h83ER8qL55jdbIm5+z1J6PZGBYnYBUyLFE17t3zpqvHVX9YXoGsQxJZ2Y70q
	39ZP8Xtu3FppMVPs5Pno65el/q6NPDJTIV93jUp2K8+2GgPz0zqBLA19f6ZfOrXO1Y1p+oX/
	2+7nf/o9L8ly42MlluKMREMt5qLiRAC7QFEyIQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2TN05CxoCDU4fsbS4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnomBrFWhgYGRqZAVQkZ
	GSsu7GEueGJWMXnmZdYGxjWmXYycHEICKhIt/78zgtgSAiYSV5+sZIOwxSQu3FvPBlEzn1Hi
	2ippEJsFqH5lTy9YPZuAtsTbLw9YQWxhAU2JO48OMXcxcnGICLQySqw+cwOsiFnAUeLR5TvM
	EIPkJSafvswOYvMKCEqcnPmEBWKZksSL3QtZIeLKEj8+nWaCiEtIzJp+gRXC5pWY0f4Uql5O
	YtrXNcwQtrTE+VkbGGGOXvz9MVScX+LY7R1AczjAep/cD4YZs3vzF6gfBSSmnjkI1aou0bJh
	OpTNJ7Fm4VsWmDG7Ti1nhum9v2UuE8RbihJTuh+yQ9haEl9+7GND9RYHkO0k8WO5zgRGuVlI
	MrOQdM9C0o2sZgEjyypG0dSC5ILipPQKY73ixNzi0rx0veT83E2M4AT1bPEOxv/nrQ8xCnAw
	KvHw7rhQHyjEmlhWXJl7iFGCg1lJhJdjSkOgEG9KYmVValF+fFFpTmrxIcZkYAROZJYSTc4H
	Js+8knhDYwNjQ0NLcwNTQyML0oSVxHmftVoHCgmkJ5akZqemFqQWwWxh4uCUamBUEX0gtbVk
	odgGGWbLxE72tA9tD0PfStY83nHMeU/HTJvz3m0Os2cvXbJjT/CDNTm8W1oeP9zybPMp5mcn
	Ti50zmra9/tQ6uPED4dk/3mx/V9nEf6zgS31iLHLxH0X5352Uz1yp1fDy841bt3e4OwLWqsi
	L3IHzFepntwvnyqiP+XNL9c3mok3lViKMxINtZiLihMBFO5ma5QDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r414vQjE028585


Hello. 
After merge cavium board boots fail, boot log messages are as follows.
I enabled initcall_debug for debugging. 

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.9.0+ (ebsong@ubi) (gcc version 4.4.1 (MontaVista Linux G++ 4.4-1302012138) ) #23 SMP PREEMPT Wed May 1 13:47:25 KST 2013
[    0.000000] octeon_bootinfo->dram_size: 4000
[    0.000000] Enabling tad1 error interrupt
[    0.000000] Enabling tad2 error interrupt
[    0.000000] Enabling tad3 error interrupt
[    0.000000] CVMSEG size: 2 cache lines (256 bytes)
[    0.000000] Cavium Networks SDK-2.1.0-p7 build 442
[    0.000000] bootconsole [early0] enabled
[    0.000000] CPU revision is: 000d9101 (Cavium Octeon II)
[    0.000000] Checking for the multiply/shift bug... no.
[    0.000000] Checking for the daddiu bug... no.
[    0.000000] Determined physical RAM map:
[    0.000000]  memory: 0000000006c00000 @ 0000000001100000 (usable)
[    0.000000]  memory: 0000000007c00000 @ 0000000008200000 (usable)
[    0.000000]  memory: 0000000011800000 @ 0000000030000000 (usable)
[    0.000000]  memory: 0000000000f85740 @ 0000000000100000 (usable)
[    0.000000] Wasting 14336 bytes for tracking 256 unused pages
[    0.000000] Initrd not found or empty - disabling initrd
[    0.000000] software IO TLB [mem 0x01b8a000-0x01bca000] (0MB) mapped at [a800000001b8a000-a800000001bc9fff]
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00100000-0xefffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00100000-0x01084fff]
[    0.000000]   node   0: [mem 0x01100000-0x07cfffff]
[    0.000000]   node   0: [mem 0x08200000-0x0fdfffff]
[    0.000000]   node   0: [mem 0x30000000-0x417fffff]
[    0.000000] Cavium Hotplug: Available coremask 0xffffff00
[    0.000000] Primary instruction cache 37kB, virtually tagged, 37 way, 8 sets, linesize 128 bytes.
[    0.000000] Primary data cache 32kB, 32-way, 8 sets, linesize 128 bytes.
[    0.000000] PERCPU: Embedded 11 pages/cpu @a800000001beb000 s12800 r8192 d24064 u45056
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 133198
[    0.000000] Kernel command line:  root=/dev/nfs rw nfsroot=165.213.176.145:/home/ebsong/project/presmb/apc/Pkg/nfsroot/wec8500 ip=165.213.176.108:165.213.176.145:165.213.176.1:255.255.255.0::mgmt0 console=ttyS0,115200
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000000] Memory: 510160k/540180k available (5811k kernel code, 30020k reserved, 8933k data, 292k init, 0k highmem)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:453
[    0.000000] Console: colour dummy device 80x25
[   26.701167] Calibrating delay loop (skipped) preset value.. 2400.00 BogoMIPS (lpj=12000000)
[   26.709507] pid_max: default: 32768 minimum: 301
[   26.714162] Security Framework initialized
[   26.718218] Mount-cache hash table entries: 256
[   26.723398] Initializing cgroup subsys devices
[   26.727669] Initializing cgroup subsys freezer
[   26.732131] Checking for the daddi bug... no.
[   26.736607] calling  cnmips_cu2_setup+0x0/0xc @ 1
[   26.741139] initcall cnmips_cu2_setup+0x0/0xc returned 0 after 0 usecs
[   26.747659] calling  spawn_ksoftirqd+0x0/0x34 @ 1

I found this issue after cdbedc61c8d0122ad682815936f0d11df1fe5f57. 
And i found something strange. I ran the git show for this commit.
As below "select GENERIC_IDLE_LOOP" is added for CONFIG_MIPS. 
but the latest arch/mips/Kconfig file has not this one. I have tried to find when this is gone. but i can't find.
Is there any problem with this? 


commit cdbedc61c8d0122ad682815936f0d11df1fe5f57
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Thu Mar 21 22:49:52 2013 +0100

    mips: Use generic idle loop

    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
    Cc: Magnus Damm <magnus.damm@gmail.com>
    Cc: Ralf Baechle <ralf@linux-mips.org>
    Link: http://lkml.kernel.org/r/20130321215234.754954871@linutronix.de
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 51244bf..e1a3d02 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -34,6 +34,7 @@ config MIPS
        select HAVE_MEMBLOCK_NODE_MAP
        select ARCH_DISCARD_MEMBLOCK
        select GENERIC_SMP_IDLE_THREAD
+       select GENERIC_IDLE_LOOP
        select BUILDTIME_EXTABLE_SORT
        select GENERIC_CLOCKEVENTS
        select GENERIC_CMOS_UPDATE
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
