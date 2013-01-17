Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759104Ab3AQFN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 00:13:26 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:20996 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758341Ab3AQFNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 00:13:24 -0500
X-AuditID: cbfee61b-b7f616d00000319b-6a-50f788716499
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Stephen Warren'" <swarren@nvidia.com>,
        "'Olof Johansson'" <olof@lixom.net>, "'Arnd Bergmann'" <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, cpgs@samsung.com
References: <20130111153206.e075edb9b1e4a38d90f23ab6@canb.auug.org.au>
 <20130117145324.3f1f27fb5902b5a03135bf06@canb.auug.org.au>
In-reply-to: 
Subject: RE: linux-next: manual merge of the samsung tree with the arm-soc tree
Date: Wed, 16 Jan 2013 21:13:00 -0800
Message-id: <0c9401cdf471$53f7c140$fbe743c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJ5C+EMbh6xTcK1+iIQ4sOv+ooGYQHRD6J6lugw1UCAAAvckIAABRHA
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zY93Cju8BBoe+SFlc3jWHzeLgwjZG
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDLOLt/DWvBKrGLC0xNMDYwnhboYOTkkBEwkFnYuYoKw
	xSQu3FvPBmILCSxjlFh/zgGm5syR6cxdjFxA8emMErtndbNCOH8ZJVon72YHqWIT0JA4/P4Z
	mC0ioCvR928+E0gRs8BTRom5k/dBdTQzStxacYwFpIpTgEdi3Z9OZhBbWMBfov/RZ7A7WARU
	JX4sWM0IYvMKWEp0rHgNZQtK/Jh8D6yXWUBLYv3O40wQtrzE5jVvmSFuVZDYcRaiXkTATWL+
	4UuMEDXiEpMePGSHmC8g8W3yIaA5HED1shKbDoC9JiGwil2i5/QPRog5khIHV9xgmcAoMQvJ
	6llIVs9CsnoWkhULGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYoREmvQOxlUNFocYBTgY
	lXh4jS5/CxBiTSwrrsw9xCjBwawkwrsm73uAEG9KYmVValF+fFFpTmrxIUYfoMsnMkuJJucD
	k0BeSbyhsbGJmYmpibmlqbkpDmElcV7GU08ChATSE0tSs1NTC1KLYMYxcXBKNTA6LlrGlak6
	/Y8tH0OY32R9j2zHML37pjlfzTK2vjhesCtxAk/Bips1S9umZPuc7gm7ZG5/vbZjSqLvzk3P
	2SPesnWy6l7WaP8VVcXYp+nqGVvPl7Fp8uar9Qab7hj/vK39ui09acovwbgZiqY7s2d/3sLr
	Wba4c5LD1brnjdrFb88vLD05I0CJpTgj0VCLuag4EQB/VxZj4QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsVy+t9jQd3Cju8BBltviFlc3jWHzeLgwjZG
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzzi7fw1rwSqxi
	wtMTTA2MJ4W6GDk5JARMJM4cmc4MYYtJXLi3nq2LkYtDSGA6o8TuWd2sEM5fRonWybvZQarY
	BDQkDr9/BmaLCOhK9P2bzwRSxCzwlFFi7uR9UB3NjBK3VhxjAaniFOCRWPenE2yHsIC/RP+j
	z0wgNouAqsSPBasZQWxeAUuJjhWvoWxBiR+T74H1MgtoSazfeZwJwpaX2LzmLdStChI7zkLU
	iwi4Scw/fIkRokZcYtKDh+wTGIVmIRk1C8moWUhGzULSsoCRZRWjaGpBckFxUnqukV5xYm5x
	aV66XnJ+7iZGcCQ/k97BuKrB4hCjAAejEg+v0eVvAUKsiWXFlbmHGCU4mJVEeNfkfQ8Q4k1J
	rKxKLcqPLyrNSS0+xOgD9OlEZinR5HxgkskriTc0NjEzsjQyszAyMTfHIawkzst46kmAkEB6
	YklqdmpqQWoRzDgmDk6pBsZkq9XTYic/Cvzm1TJz6uJYy7VLkk/Yfo+eu68w9GKzwCIRrpj6
	yF06n6dckf0050ZUQHZ5T3csD/uG558Wu2z9ElPMv3PSO0GWFJ35+num75Flbom+r9u57Xe3
	wayvrdcruBbvXMko4aCgxN+gw3Tm17Y+nWY5hruv58Rnck/+P0+84PLT3oVKLMUZiYZazEXF
	iQB/xto3EQMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kukjin Kim wrote:

[...]

> Hmm, updating timer patches in Samsung tree cause the merge conflicts with
> arm-soc, so for now I dropped them in my tree just now.
> And note that regarding topic branch which are including it will be
re-worked
> soon :-)
> 
> Now to merge Samsung tree for linux-next should be fine.
> 
> Thanks again.
> 
One more, following is my preferred resolution when merge conflict happens
between Samsung tree and arm-soc tree:

8<---------------------------------------------------

diff --cc arch/arm/common/Makefile
index 55d4182,dc8dd0d..7a5df8b
--- a/arch/arm/common/Makefile
+++ b/arch/arm/common/Makefile
@@@ -2,10 -2,6 +2,8 @@@
  # Makefile for the linux kernel.
  #
  
 +obj-y += firmware.o
 +
- obj-$(CONFIG_ARM_GIC)		+= gic.o
- obj-$(CONFIG_ARM_VIC)		+= vic.o
  obj-$(CONFIG_ICST)		+= icst.o
  obj-$(CONFIG_SA1111)		+= sa1111.o
  obj-$(CONFIG_PCI_HOST_VIA82C505) += via82c505.o
diff --cc arch/arm/mach-exynos/mach-exynos4-dt.c
index ab1dacc,112d10e..3ac73ed
--- a/arch/arm/mach-exynos/mach-exynos4-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos4-dt.c
@@@ -107,11 -106,9 +106,10 @@@ DT_MACHINE_START(EXYNOS4210_DT, "Samsun
  	.smp		= smp_ops(exynos_smp_ops),
  	.init_irq	= exynos4_init_irq,
  	.map_io		= exynos4_dt_map_io,
- 	.handle_irq	= gic_handle_irq,
 +	.init_early	= exynos_firmware_init,
  	.init_machine	= exynos4_dt_machine_init,
  	.init_late	= exynos_init_late,
- 	.timer		= &exynos4_timer,
+ 	.init_time	= exynos4_timer_init,
  	.dt_compat	= exynos4_dt_compat,
  	.restart        = exynos4_restart,
  MACHINE_END
diff --cc arch/arm/mach-exynos/platsmp.c
index 3226893,60f7c5b..a083e05
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@@ -20,12 -20,11 +20,12 @@@
  #include <linux/jiffies.h>
  #include <linux/smp.h>
  #include <linux/io.h>
+ #include <linux/irqchip/arm-gic.h>
  
  #include <asm/cacheflush.h>
- #include <asm/hardware/gic.h>
  #include <asm/smp_plat.h>
  #include <asm/smp_scu.h>
 +#include <asm/firmware.h>
  
  #include <mach/hardware.h>
  #include <mach/regs-clock.h>
@@@ -146,22 -145,11 +146,22 @@@ static int __cpuinit exynos_boot_second
  
  	timeout = jiffies + (1 * HZ);
  	while (time_before(jiffies, timeout)) {
 +		unsigned long boot_addr;
 +
  		smp_rmb();
  
 -		__raw_writel(virt_to_phys(exynos4_secondary_startup),
 -
cpu_boot_reg(phys_cpu));
 +		boot_addr = virt_to_phys(exynos4_secondary_startup);
 +
 +		/*
 +		 * Try to set boot address using firmware first
 +		 * and fall back to boot register if it fails.
 +		 */
 +		if (call_firmware_op(set_cpu_boot_addr, phys_cpu,
boot_addr))
 +			__raw_writel(boot_addr, cpu_boot_reg(phys_cpu));
 +
 +		call_firmware_op(cpu_boot, phys_cpu);
 +
- 		gic_raise_softirq(cpumask_of(cpu), 0);
+ 		arch_send_wakeup_ipi_mask(cpumask_of(cpu));
  
  		if (pen_release == -1)
  			break;

