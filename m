Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbaGHNWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:22:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23627 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbaGHNV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:21:56 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-44-53bbf071e696
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Tomasz Figa'" <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
 <1403618235-19353-3-git-send-email-t.figa@samsung.com>
In-reply-to: <1403618235-19353-3-git-send-email-t.figa@samsung.com>
Subject: RE: [PATCH 2/6] ARM: EXYNOS: Fix core ID used by platsmp and hotplug
 code
Date: Tue, 08 Jul 2014 22:21:50 +0900
Message-id: <031001cf9aaf$959cf6c0$c0d6e440$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQImwlMNtKSRmS2HaaYx0l+evMEXagJEk3MgmtW1RiA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zfd3CD7uDDU49trTY9Pgaq8XlXXPY
	LGac38dksfbIXXaL9TNes1is2vWH0YHNY+esu+wem5fUe/RtWcXo8XmTXABLFJdNSmpOZllq
	kb5dAlfGhQOJBd81KrYv7GFpYGxV6GLk5JAQMJH4v2MRM4QtJnHh3nq2LkYuDiGBZYwSjdvu
	MsIUHV95ASoxnVHizb7PUM5fRonDcyYygVSxCWhIHH7/jB3EFhHwlHhw6gA7SBGzwAJGibO3
	ZoAlhASqJTYdXMIKYnMKOEt8+vaVBcQWFgiRWHRyGtgdLAKqEq/Ot4LFeQUsJWZcOc4EYQtK
	/Jh8DyzOLKAlsX4nRJxZQF5i85q3UD8oSOw4+5oR4ggrict9j5khakQk9r14xwhykITANXaJ
	Tc0Qv7EICEh8m3wIaCgHUEJWYtMBqDmSEgdX3GCZwCgxC8nqWUhWz0KyehaSFQsYWVYxiqYW
	JBcUJ6UXGekVJ+YWl+al6yXn525ihMRq3w7GmwesDzEmA62fyCwlmpwPjPW8knhDYzMjC1MT
	U2Mjc0sz0oSVxHkXPUwKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cC4uJEv6fx7hojKlgev
	73u/7D6/7vz07w6cNks07J9nerjWhWQ7ywddab+qG5vgrhOddGWFs9m5rtATHR3nZpzbtHib
	bu3XMsmInmm3e2Ys03FKLA3O5zhaE7xT9vo6n4D5TstUAmdKfLgUwFm+8dv2ZVdKX+h+nrrj
	LE/Xiijh6T8VLefHHONUYinOSDTUYi4qTgQALSz6x+sCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+xoG7hh93BBjc6TC02Pb7GanF51xw2
	ixnn9zFZrD1yl91i/YzXLBardv1hdGDz2DnrLrvH5iX1Hn1bVjF6fN4kF8AS1cBok5GamJJa
	pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0XEmhLDGnFCgUkFhc
	rKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYceFAYsF3jYrtC3tYGhhbFboYOTkkBEwkjq+8
	wAZhi0lcuLceyObiEBKYzijxZt9nKOcvo8ThOROZQKrYBDQkDr9/xg5iiwh4Sjw4dYAdpIhZ
	YAGjxNlbM8ASQgLVEpsOLmEFsTkFnCU+ffvKAmILC4RILDo5jRnEZhFQlXh1vhUszitgKTHj
	ynEmCFtQ4sfke2BxZgEtifU7IeLMAvISm9e8ZYY4VUFix9nXjBBHWElc7nvMDFEjIrHvxTvG
	CYxCs5CMmoVk1Cwko2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzgRPJPewbiq
	weIQowAHoxIP74qDu4KFWBPLiitzDzFKcDArifB+ObU7WIg3JbGyKrUoP76oNCe1+BCjKdCn
	E5mlRJPzgUkqryTe0NjEzMjSyMzCyMTcXEmc92CrdaCQQHpiSWp2ampBahFMHxMHp1QD42zT
	qvv9N/vLfuZL32ps/DD50doJMTUrrG7df8Cxt3dFpJzLlud2JrZv9iyU6Jl/4fOj/nVm35fO
	zG+scpuyakOC5ikrI5byru/fZfvbbjbMt15iJLXzrUDzM/20p9LKMrEqapxNacwqf/+9u7fN
	4oam/Ubdgt8npVw4dvdwelWrFCyanMP4XomlOCPRUIu5qDgRAM47BZAaAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Figa wrote:
> 
> When CPU topology is specified in device tree, cpu_logical_map() does
> not return core ID anymore, but rather full MPIDR value. This breaks
> existing calculation of PMU register offsets on Exynos SoCs.
> 
> This patch fixes the problem by adjusting the code to use only core ID
> bits of the value returned by cpu_logical_map() to allow CPU topology to
> be specified in device tree on Exynos SoCs.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>

Looks good to me, but I think we don't need this fix in 3.16 because the CPU
topology is not specified in DT yet...if I'm wrong, please correct me.

Will apply for 3.17.

Thanks,
Kukjin

> ---
>  arch/arm/mach-exynos/hotplug.c | 10 ++++++----
>  arch/arm/mach-exynos/platsmp.c | 34 +++++++++++++++++++---------------
>  2 files changed, 25 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
> index 69fa483..5644dac 100644
> --- a/arch/arm/mach-exynos/hotplug.c
> +++ b/arch/arm/mach-exynos/hotplug.c
> @@ -40,11 +40,13 @@ static inline void cpu_leave_lowpower(void)
> 
>  static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
>  {
> +	u32 mpidr = cpu_logical_map(cpu);
> +	u32 core_id = MPIDR_AFFINITY_LEVEL(mpidr, 0);
> +
>  	for (;;) {
> 
> -		/* make cpu1 to be turned off at next WFI command */
> -		if (cpu == 1)
> -			exynos_cpu_power_down(cpu);
> +		/* Turn the CPU off on next WFI instruction. */
> +		exynos_cpu_power_down(core_id);
> 
>  		/*
>  		 * here's the WFI
> @@ -54,7 +56,7 @@ static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
>  		    :
>  		    : "memory", "cc");
> 
> -		if (pen_release == cpu_logical_map(cpu)) {
> +		if (pen_release == core_id) {
>  			/*
>  			 * OK, proper wakeup, we're done
>  			 */
> diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
> index 1c8d31e..50b9aad 100644
> --- a/arch/arm/mach-exynos/platsmp.c
> +++ b/arch/arm/mach-exynos/platsmp.c
> @@ -90,7 +90,8 @@ static void exynos_secondary_init(unsigned int cpu)
>  static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
>  {
>  	unsigned long timeout;
> -	unsigned long phys_cpu = cpu_logical_map(cpu);
> +	u32 mpidr = cpu_logical_map(cpu);
> +	u32 core_id = MPIDR_AFFINITY_LEVEL(mpidr, 0);
>  	int ret = -ENOSYS;
> 
>  	/*
> @@ -104,17 +105,18 @@ static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
>  	 * the holding pen - release it, then wait for it to flag
>  	 * that it has been released by resetting pen_release.
>  	 *
> -	 * Note that "pen_release" is the hardware CPU ID, whereas
> +	 * Note that "pen_release" is the hardware CPU core ID, whereas
>  	 * "cpu" is Linux's internal ID.
>  	 */
> -	write_pen_release(phys_cpu);
> +	write_pen_release(core_id);
> 
> -	if (!exynos_cpu_power_state(cpu)) {
> -		exynos_cpu_power_up(cpu);
> +	if (!exynos_cpu_power_state(core_id)) {
> +		exynos_cpu_power_up(core_id);
>  		timeout = 10;
> 
>  		/* wait max 10 ms until cpu1 is on */
> -		while (exynos_cpu_power_state(cpu) != S5P_CORE_LOCAL_PWR_EN) {
> +		while (exynos_cpu_power_state(core_id)
> +		       != S5P_CORE_LOCAL_PWR_EN) {
>  			if (timeout-- == 0)
>  				break;
> 
> @@ -145,20 +147,20 @@ static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
>  		 * Try to set boot address using firmware first
>  		 * and fall back to boot register if it fails.
>  		 */
> -		ret = call_firmware_op(set_cpu_boot_addr, phys_cpu, boot_addr);
> +		ret = call_firmware_op(set_cpu_boot_addr, core_id, boot_addr);
>  		if (ret && ret != -ENOSYS)
>  			goto fail;
>  		if (ret == -ENOSYS) {
> -			void __iomem *boot_reg = cpu_boot_reg(phys_cpu);
> +			void __iomem *boot_reg = cpu_boot_reg(core_id);
> 
>  			if (IS_ERR(boot_reg)) {
>  				ret = PTR_ERR(boot_reg);
>  				goto fail;
>  			}
> -			__raw_writel(boot_addr, cpu_boot_reg(phys_cpu));
> +			__raw_writel(boot_addr, cpu_boot_reg(core_id));
>  		}
> 
> -		call_firmware_op(cpu_boot, phys_cpu);
> +		call_firmware_op(cpu_boot, core_id);
> 
>  		arch_send_wakeup_ipi_mask(cpumask_of(cpu));
> 
> @@ -227,22 +229,24 @@ static void __init exynos_smp_prepare_cpus(unsigned int max_cpus)
>  	 * boot register if it fails.
>  	 */
>  	for (i = 1; i < max_cpus; ++i) {
> -		unsigned long phys_cpu;
>  		unsigned long boot_addr;
> +		u32 mpidr;
> +		u32 core_id;
>  		int ret;
> 
> -		phys_cpu = cpu_logical_map(i);
> +		mpidr = cpu_logical_map(i);
> +		core_id = MPIDR_AFFINITY_LEVEL(mpidr, 0);
>  		boot_addr = virt_to_phys(exynos4_secondary_startup);
> 
> -		ret = call_firmware_op(set_cpu_boot_addr, phys_cpu, boot_addr);
> +		ret = call_firmware_op(set_cpu_boot_addr, core_id, boot_addr);
>  		if (ret && ret != -ENOSYS)
>  			break;
>  		if (ret == -ENOSYS) {
> -			void __iomem *boot_reg = cpu_boot_reg(phys_cpu);
> +			void __iomem *boot_reg = cpu_boot_reg(core_id);
> 
>  			if (IS_ERR(boot_reg))
>  				break;
> -			__raw_writel(boot_addr, cpu_boot_reg(phys_cpu));
> +			__raw_writel(boot_addr, cpu_boot_reg(core_id));
>  		}
>  	}
>  }
> --
> 1.9.3

