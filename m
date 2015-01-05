Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbbAEAfa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 19:35:30 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:18200 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbbAEAf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 19:35:28 -0500
X-AuditID: cbfee68e-f79b46d000002b74-43-54a9dc4d024a
Message-id: <54A9DC4D.1050600@samsung.com>
Date: Mon, 05 Jan 2015 09:35:25 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: kgene.kim@samsung.com
Cc: Chanwoo Choi <cw00.choi@samsung.com>, ben-linux@fluff.org,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: EXYNOS: Add exynos3250 suspend-to-ram support
References: <1419388629-27066-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1419388629-27066-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsWyRsSkSNf3zsoQg+Z1FhYbZ6xntZi07gCT
	xfUvz4Gs+xNYLF6/MLToXXCVzeJs0xt2i02Pr7FaXN41h81ixvl9TA5cHn9XvWD22Lyk3qNv
	yypGj8+b5AJYorhsUlJzMstSi/TtErgyOg8EFazUq3i9S7qB8YpqFyMnh4SAicSGPSuZIGwx
	iQv31rN1MXJxCAksZZR4/XY+G0zR1YNLmSES0xklZmxfDOW8ZpSYvPcmC0gVr4CWxPqrzcwg
	NouAqsTlH13sIDYbUHz/ixtgk0QFwiRWTr8CVS8o8WPyPTBbREBSoqnhD9hQZoE+JokTq5YC
	NXNwCAu4Szy4rwNiCgm4SrRfFgEp5xRwk9jz9hEriM0soCOxv3UaG4QtL7F5zVuwMRICl9gl
	phxvYoW4R0Di2+RDLCBzJARkJTYdYIZ4TFLi4IobLBMYxWYhuWgWkrGzkIxdwMi8ilE0tSC5
	oDgpvchIrzgxt7g0L10vOT93EyMwBk//e9a3g/HmAetDjAIcjEo8vB4nVoYIsSaWFVfmHmI0
	BbpiIrOUaHI+MNLzSuINjc2MLExNTI2NzC3NlMR5E6R+BgsJpCeWpGanphakFsUXleakFh9i
	ZOLglGpgLOr79bN7X9e+ha7/fIUN4w+lvOSNvyO1Jj9wyeJV9R3525Ref3C2uBZcWfxBZaHR
	SeaIK5eSs9xFwjb6rJgx8VwSu/NJg2a/10uv7Ng6b+V+azvfX487ffgsPXjzdGJPmqn/+m/7
	YN/i7lV31q4sV7XQy7d39Em35l128lRIzczzdwtdH8fzKLEUZyQaajEXFScCAM3SpBq8AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jQV3fOytDDHZ/07PYOGM9q8WkdQeY
	LK5/eQ5k3Z/AYvH6haFF74KrbBZnm96wW2x6fI3V4vKuOWwWM87vY3Lg8vi76gWzx+Yl9R59
	W1YxenzeJBfAEtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+Ti
	E6DrlpkDdI+SQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMaPzQFDBSr2K
	17ukGxivqHYxcnJICJhIXD24lBnCFpO4cG89WxcjF4eQwHRGiRnbFzNDOK8ZJSbvvckCUsUr
	oCWx/mozWAeLgKrE5R9d7CA2G1B8/4sbbCC2qECYxMrpV6DqBSV+TL4HZosISEo0NfwBG8os
	0MckcWLVUqBmDg5hAXeJB/d1QEwhAVeJ9ssiIOWcAm4Se94+YgWxmQV0JPa3TmODsOUlNq95
	yzyBUWAWkg2zkJTNQlK2gJF5FaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwhD+T2sG4ssHi
	EKMAB6MSD6/HiZUhQqyJZcWVuYcYJTiYlUR4190CCvGmJFZWpRblxxeV5qQWH2I0BQbARGYp
	0eR8YPLJK4k3NDYxM7I0Mje0MDI2VxLnVbJvCxESSE8sSc1OTS1ILYLpY+LglGpg1E3dLXx3
	rvXumVeUO7MMWtXyZVX+lhYtczVV736oZPNWqDTSdZtclcJnxYtH/RqlepZqNlxR2Pni3pyL
	s26yKrTL6J+49pGl6pXvjAvuq1Q1Ch997JdbHPq08X6vxy/ZWdxWve+fdTjej1klwrp/UkXw
	G8/9nXz+uc+eHvtdLVG9xvzr8mf/lFiKMxINtZiLihMBJpIwfAYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kukjin,

Could you please review this patch-set?

I tested this patch-set on Exynos3250-baesd Rinato board.

Best Regards,
Chanwoo Choi

On 12/24/2014 11:37 AM, Chanwoo Choi wrote:
> This patch adds the support for suspend-to-ram feature of Exynos3250 SoC.
> Exynos3250 don't contain the L2 cache.
> 
> The measured power-consumption in suspend state:
> - before entering suspend : 31mA
> - in suspend state : 16mA
> 
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> This patch is based on v3.19-rc1 and is tested on Exynos3250-based Rinato board.
> 
>  arch/arm/mach-exynos/regs-pmu.h |  3 ++
>  arch/arm/mach-exynos/suspend.c  | 77 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 80 insertions(+)
> 
> diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
> index b5f4406..eb461e1 100644
> --- a/arch/arm/mach-exynos/regs-pmu.h
> +++ b/arch/arm/mach-exynos/regs-pmu.h
> @@ -160,12 +160,14 @@
>  #define EXYNOS5_L2RSTDISABLE_VALUE		BIT(3)
>  
>  #define S5P_PAD_RET_MAUDIO_OPTION		0x3028
> +#define S5P_PAD_RET_MMC2_OPTION			0x30c8
>  #define S5P_PAD_RET_GPIO_OPTION			0x3108
>  #define S5P_PAD_RET_UART_OPTION			0x3128
>  #define S5P_PAD_RET_MMCA_OPTION			0x3148
>  #define S5P_PAD_RET_MMCB_OPTION			0x3168
>  #define S5P_PAD_RET_EBIA_OPTION			0x3188
>  #define S5P_PAD_RET_EBIB_OPTION			0x31A8
> +#define S5P_PAD_RET_SPI_OPTION			0x31c8
>  
>  #define S5P_PS_HOLD_CONTROL			0x330C
>  #define S5P_PS_HOLD_EN				(1 << 31)
> @@ -326,6 +328,7 @@
>  			(EXYNOS3_ARM_CORE0_OPTION + ((_nr) * 0x80))
>  
>  #define EXYNOS3_ARM_COMMON_OPTION			0x2408
> +#define EXYNOS3_ARM_L2_OPTION				0x2608
>  #define EXYNOS3_TOP_PWR_OPTION				0x2C48
>  #define EXYNOS3_CORE_TOP_PWR_OPTION			0x2CA8
>  #define EXYNOS3_XUSBXTI_DURATION			0x341C
> diff --git a/arch/arm/mach-exynos/suspend.c b/arch/arm/mach-exynos/suspend.c
> index f8e7dcd..d6feef3 100644
> --- a/arch/arm/mach-exynos/suspend.c
> +++ b/arch/arm/mach-exynos/suspend.c
> @@ -91,6 +91,12 @@ static unsigned int exynos_pmu_spare3;
>  
>  static u32 exynos_irqwake_intmask = 0xffffffff;
>  
> +static const struct exynos_wkup_irq exynos3250_wkup_irq[] = {
> +	{ 73, BIT(1) }, /* RTC alarm */
> +	{ 74, BIT(2) }, /* RTC tick */
> +	{ /* sentinel */ },
> +};
> +
>  static const struct exynos_wkup_irq exynos4_wkup_irq[] = {
>  	{ 76, BIT(1) }, /* RTC alarm */
>  	{ 77, BIT(2) }, /* RTC tick */
> @@ -114,6 +120,19 @@ unsigned int exynos_release_ret_regs[] = {
>  	REG_TABLE_END,
>  };
>  
> +unsigned int exynos3250_release_ret_regs[] = {
> +	S5P_PAD_RET_MAUDIO_OPTION,
> +	S5P_PAD_RET_GPIO_OPTION,
> +	S5P_PAD_RET_UART_OPTION,
> +	S5P_PAD_RET_MMCA_OPTION,
> +	S5P_PAD_RET_MMCB_OPTION,
> +	S5P_PAD_RET_EBIA_OPTION,
> +	S5P_PAD_RET_EBIB_OPTION,
> +	S5P_PAD_RET_MMC2_OPTION,
> +	S5P_PAD_RET_SPI_OPTION,
> +	REG_TABLE_END,
> +};
> +
>  unsigned int exynos5420_release_ret_regs[] = {
>  	EXYNOS_PAD_RET_DRAM_OPTION,
>  	EXYNOS_PAD_RET_MAUDIO_OPTION,
> @@ -173,6 +192,12 @@ static int exynos_cpu_suspend(unsigned long arg)
>  	return exynos_cpu_do_idle();
>  }
>  
> +static int exynos3250_cpu_suspend(unsigned long arg)
> +{
> +	flush_cache_all();
> +	return exynos_cpu_do_idle();
> +}
> +
>  static int exynos5420_cpu_suspend(unsigned long arg)
>  {
>  	/* MCPM works with HW CPU identifiers */
> @@ -230,6 +255,23 @@ static void exynos_pm_prepare(void)
>  	pmu_raw_writel(virt_to_phys(exynos_cpu_resume), S5P_INFORM0);
>  }
>  
> +static void exynos3250_pm_prepare(void)
> +{
> +	unsigned int tmp;
> +
> +	/* Set wake-up mask registers */
> +	exynos_pm_set_wakeup_mask();
> +
> +	tmp = pmu_raw_readl(EXYNOS3_ARM_L2_OPTION);
> +	tmp &= ~EXYNOS5_OPTION_USE_RETENTION;
> +	pmu_raw_writel(tmp, EXYNOS3_ARM_L2_OPTION);
> +
> +	exynos_pm_enter_sleep_mode();
> +
> +	/* ensure at least INFORM0 has the resume address */
> +	pmu_raw_writel(virt_to_phys(exynos_cpu_resume), S5P_INFORM0);
> +}
> +
>  static void exynos5420_pm_prepare(void)
>  {
>  	unsigned int tmp;
> @@ -344,6 +386,28 @@ early_wakeup:
>  	pmu_raw_writel(0x0, S5P_INFORM1);
>  }
>  
> +static void exynos3250_pm_resume(void)
> +{
> +	u32 cpuid = read_cpuid_part();
> +
> +	if (exynos_pm_central_resume())
> +		goto early_wakeup;
> +
> +	/* For release retention */
> +	exynos_pm_release_retention();
> +
> +	pmu_raw_writel(S5P_USE_STANDBY_WFI_ALL, S5P_CENTRAL_SEQ_OPTION);
> +
> +	if (call_firmware_op(resume) == -ENOSYS
> +	    && cpuid == ARM_CPU_PART_CORTEX_A9)
> +		exynos_cpu_restore_register();
> +
> +early_wakeup:
> +
> +	/* Clear SLEEP mode set in INFORM1 */
> +	pmu_raw_writel(0x0, S5P_INFORM1);
> +}
> +
>  static void exynos5420_prepare_pm_resume(void)
>  {
>  	if (IS_ENABLED(CONFIG_EXYNOS5420_MCPM))
> @@ -483,6 +547,16 @@ static const struct platform_suspend_ops exynos_suspend_ops = {
>  	.valid		= suspend_valid_only_mem,
>  };
>  
> +static const struct exynos_pm_data exynos3250_pm_data = {
> +	.wkup_irq	= exynos3250_wkup_irq,
> +	.wake_disable_mask = ((0xFF << 8) | (0x1F << 1)),
> +	.release_ret_regs = exynos3250_release_ret_regs,
> +	.pm_suspend	= exynos_pm_suspend,
> +	.pm_resume	= exynos3250_pm_resume,
> +	.pm_prepare	= exynos3250_pm_prepare,
> +	.cpu_suspend	= exynos3250_cpu_suspend,
> +};
> +
>  static const struct exynos_pm_data exynos4_pm_data = {
>  	.wkup_irq	= exynos4_wkup_irq,
>  	.wake_disable_mask = ((0xFF << 8) | (0x1F << 1)),
> @@ -518,6 +592,9 @@ static struct exynos_pm_data exynos5420_pm_data = {
>  
>  static struct of_device_id exynos_pmu_of_device_ids[] = {
>  	{
> +		.compatible = "samsung,exynos3250-pmu",
> +		.data = &exynos3250_pm_data,
> +	}, {
>  		.compatible = "samsung,exynos4210-pmu",
>  		.data = &exynos4_pm_data,
>  	}, {
> 

