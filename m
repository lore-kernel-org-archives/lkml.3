Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab3KLOei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:34:38 -0500
Received: from multi.imgtec.com ([194.200.65.239]:52675 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387Ab3KLOef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:34:35 -0500
Message-ID: <52823C54.9050208@imgtec.com>
Date: Tue, 12 Nov 2013 08:33:56 -0600
From: "Steven J. Hill" <Steven.Hill@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linux/MIPS Mailing List <linux-mips@linux-mips.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Release of Linux MTI-3.10-LTS kernel.
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.159.176]
X-SEF-Processed: 7_3_0_01192__2013_11_12_14_34_05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Imagination Technologies is pleased to announce the release of its 3.10 
LTS (Long-Term Support) MIPS kernel. The changelog below is based off 
the stable Linux 3.10.14 release done by Greg Kroah-Hartman in commit
8c15abc94c737f9120d3d4a550abbcbb9be121f6 back on October 1st. The code 
repository is hosted at the Linux/MIPS project GIT:

http://git.linux-mips.org/?p=linux-mti.git;a=summary

We look forward to any comments or feedback.

         The Imagination MIPS Kernel Team


---
Upstream:
* Move to Linux 3.10.14

Userland visible changes:
* Fix ability to perform a soft reset on SEAD-3.
* Add 64-bit FP register support on 32-bit platforms.
* Add FPU2 IEEE754-2008 SNaN support.
* Support proAptiv/interAptiv core Perf-events.

Boot setup related changes:
* Update GCMP detection on Malta.
* Disable L2 cache on SEAD-3.
* Always register R4K clock when selected.
* Set cpu_has_mmips only if SYS_SUPPORTS_MICROMIPS is defined.
* Do not write EVA bit in the config5 CP0 register.

New drivers and features:
* Add interAptiv CPU support.
* Add proAPTIV CPU support.
* Add EVA to support 3GB virtual addressing for MIPS32 cores.
* Add ERLite-3 platform support.
* Add 64-bit address support on MIPS64R2 cores.
* Add uImage build target.
* Add MIPS32R2 SYNC optimization.
* Send IPIs using the GIC.

Developer visible changes:
* Move declaration of Octeon function fixup_irqs() to header.
* Drop obsolete NR_CPUS_DEFAULT_{1,2} config options.
* Remove -fstack-protector from CFLAGS when building images.
* CMP support needs to select SMP as well.
* Add printing of ES bit when cache error occurs.
* Enable DEVTMPFS on Malta.
* Remove ttyS2 serial support on Malta.

Fixes:
* Fix IDE PIO size calculation in IDE driver.
* Fix TLBR-use hazards for R2 cores in the TLB reload handlers.
* Fix execution hazard during watchpoint register probe.
* Fix POOL16C minor opcode enumerations for microMIPS.
* Fix gic_set_affinity infinite loop for GIC controller.
* Fix improper definition of ISA exception bit for microMIPS.
* Skip walking indirection page for crashkernels for kdump.
* Fix random crashes while loading crashkernel for kexec.
* Fix SMP core calculations when using MT support.
* Fix accessing to per-cpu data when flushing the cache.
* Fix VGA_MAP_MEM macro.
* 74K/1074K erratum workarounds.
* Bugfix of stack trace dump.
* MIPS HIGHMEM fixes for cache aliasing and non-DMA I/O.
* Revert fixrange_init() limiting to the FIXMAP region.
* Bugfix of Malta PCI bridges loop.
* Fix forgotten preempt_enable() when CPU has inclusive pcaches.
* Fix GIC interrupt offsets for Malta.
* Fix bug in using flush_cache_vunmap.
* Fix encoding for UUSK AM bits on the SegCtl registers for EVA.

Cleanups and refactors:
* Refactor boot and boot/compressed rules.
* Refactor load/entry address calculations.
* Drop FRAME_POINTER codepath in mcount.S file.
* Rearrange PTE bits into fixed positions for MIPS32R2.
* Remove X bit in page tables for HEAP/BSS.
* Rework cache flush functions.
* Re-implement VPE functionality as writes to a pseudo-device.
* Fix more section mismatch warnings.
* Remove platform_set_drvdata() in SEAD-3 USB driver.

