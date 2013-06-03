Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab3FCJiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:38:12 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:30259 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab3FCJiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:38:08 -0400
X-AuditID: cbfee691-b7fef6d000002d62-e0-51ac63fe0b4d
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Stephen Boyd'" <sboyd@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
References: <1368473175-4841-1-git-send-email-sboyd@codeaurora.org>
 <1368473175-4841-7-git-send-email-sboyd@codeaurora.org>
In-reply-to: <1368473175-4841-7-git-send-email-sboyd@codeaurora.org>
Subject: RE: [PATCHv6 06/11] ARM: EXYNOS4: Divorce mct from local timer API
Date: Mon, 03 Jun 2013 18:38:06 +0900
Message-id: <049701ce603e$0d446cb0$27cd4610$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5QD75uYzsAxf+8R7+03iPhvPFabAQLgp3g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t8zI91/yWsCDfY8MrfY9Pgaq8XE/WfZ
	LS7vmsNm8eNMN4vFsRlLGB1YPS739TJ53Lm2h81j85J6j8+b5AJYorhsUlJzMstSi/TtErgy
	3vz4zlLQplex//kDlgbGI6pdjJwcEgImEv8fb2eFsMUkLtxbz9bFyMUhJLCMUWLp40XMMEUX
	zy9hhEhMZ5T4MHMFlPOXUeLYgclg7WwCGhKH3z9jB7FFBPwl2rceB7OZBfIlfh1ZzQJiCwnU
	Snz4Mg3M5hRwkTj59A0TiC0s4C3xcdo1oKEcHCwCqhIHzseAhHkFbCV+TDzKBGELSvyYfI8F
	YqSWxPqdx5kgbHmJzWveMoO0SgioSzz6qwtxgZHEwVvbGCFKRCT2vXgHdrKEwDV2iYaFz8Ae
	YxEQkPg2+RALRK+sxKYDUP9KShxccYNlAqPELCSbZyHZPAvJ5llIVixgZFnFKJpakFxQnJRe
	ZKpXnJhbXJqXrpecn7uJERKdE3cw3j9gfYgxGWj9RGYp0eR8YHTnlcQbGpsZWZiamBobmVua
	kSasJM6r3mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGRqzTxxeEn0x6fYA3+fe7Am7KP
	EsWv3J93v3sj8HhOyYU7HdP1mQUOhIZnGN406LjRcIvhz97ZBQm8WVEJPE46k15cZ3W7Es55
	x7i+On/LNTm7v8VGm+0Css8+/mt4UuR0y8WiM5e0j4twREcLJIfe6uIoennfQePx+ifrW1bn
	yd4VrX3MrCKgxFKckWioxVxUnAgA6mFbs+QCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t9jQd1/yWsCDX7/NrLY9Pgaq8XE/WfZ
	LS7vmsNm8eNMN4vFsRlLGB1YPS739TJ53Lm2h81j85J6j8+b5AJYohoYbTJSE1NSixRS85Lz
	UzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA9ioplCXmlAKFAhKLi5X07TBN
	CA1x07WAaYzQ9Q0JgusxMkADCesYM978+M5S0KZXsf/5A5YGxiOqXYycHBICJhIXzy9hhLDF
	JC7cW8/WxcjFISQwnVHiw8wVjBDOX0aJYwcms4JUsQloSBx+/4wdxBYR8Jdo33oczGYWyJf4
	dWQ1C4gtJFAr8eHLNDCbU8BF4uTTN0wgtrCAt8THadeAhnJwsAioShw4HwMS5hWwlfgx8SgT
	hC0o8WPyPRaIkVoS63ceZ4Kw5SU2r3nLDNIqIaAu8eivLsQFRhIHb21jhCgRkdj34h3jBEah
	WUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERz7z6R2MK5ssDjE
	KMDBqMTDG+CxJlCINbGsuDL3EKMEB7OSCO+VQKAQb0piZVVqUX58UWlOavEhxmSgPycyS4km
	5wPTUl5JvKGxiZmRpZGZhZGJuTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MG6J3tf9
	dNZvo8kn13ZWi/WmOifLSv09udtP73PS09TIX+5TEn6vvKPVlj6NV5jhPNf/qk+3zE9bTi1f
	dfO9m3f55+NL7b8EH3WaHXx7ye7jTtzvD/rKJk5PPmPo6Jb8Vj/tzhWj2TvX5rPePvr0xCsr
	M39/q8c/ohncqqLtNlr+eH9GerFNXY0SS3FGoqEWc1FxIgCm0pl3QQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Boyd wrote:
> 
> Separate the mct local timers from the local timer API. This will
> allow us to remove ARM local timer support in the near future and
> gets us closer to moving this driver to drivers/clocksource.
> 
> Cc: Kukjin Kim <kgene.kim@samsung.com>

Looks good to me after looking at this series,

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Sorry for late response :-)

Thanks for your gentle reminder.

- Kukjin

> Cc: Thomas Abraham <thomas.abraham@linaro.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/clocksource/exynos_mct.c | 60 ++++++++++++++++++++++++++++-------
> -----
>  1 file changed, 43 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/clocksource/exynos_mct.c
> b/drivers/clocksource/exynos_mct.c
> index 662fcc0..1c3f5a6 100644
> --- a/drivers/clocksource/exynos_mct.c
> +++ b/drivers/clocksource/exynos_mct.c
> @@ -16,6 +16,7 @@
>  #include <linux/err.h>
>  #include <linux/clk.h>
>  #include <linux/clockchips.h>
> +#include <linux/cpu.h>
>  #include <linux/platform_device.h>
>  #include <linux/delay.h>
>  #include <linux/percpu.h>
> @@ -24,7 +25,6 @@
>  #include <linux/of_address.h>
>  #include <linux/clocksource.h>
> 
> -#include <asm/localtimer.h>
>  #include <asm/mach/time.h>
> 
>  #define EXYNOS4_MCTREG(x)		(x)
> @@ -80,7 +80,7 @@ static unsigned int mct_int_type;
>  static int mct_irqs[MCT_NR_IRQS];
> 
>  struct mct_clock_event_device {
> -	struct clock_event_device *evt;
> +	struct clock_event_device evt;
>  	unsigned long base;
>  	char name[10];
>  };
> @@ -295,8 +295,6 @@ static void exynos4_clockevent_init(void)
>  	setup_irq(mct_irqs[MCT_G0_IRQ], &mct_comp_event_irq);
>  }
> 
> -#ifdef CONFIG_LOCAL_TIMERS
> -
>  static DEFINE_PER_CPU(struct mct_clock_event_device, percpu_mct_tick);
> 
>  /* Clock event handling */
> @@ -369,7 +367,7 @@ static inline void exynos4_tick_set_mode(enum
> clock_event_mode mode,
> 
>  static int exynos4_mct_tick_clear(struct mct_clock_event_device *mevt)
>  {
> -	struct clock_event_device *evt = mevt->evt;
> +	struct clock_event_device *evt = &mevt->evt;
> 
>  	/*
>  	 * This is for supporting oneshot mode.
> @@ -391,7 +389,7 @@ static int exynos4_mct_tick_clear(struct
> mct_clock_event_device *mevt)
>  static irqreturn_t exynos4_mct_tick_isr(int irq, void *dev_id)
>  {
>  	struct mct_clock_event_device *mevt = dev_id;
> -	struct clock_event_device *evt = mevt->evt;
> +	struct clock_event_device *evt = &mevt->evt;
> 
>  	exynos4_mct_tick_clear(mevt);
> 
> @@ -417,8 +415,7 @@ static int __cpuinit exynos4_local_timer_setup(struct
> clock_event_device *evt)
>  	struct mct_clock_event_device *mevt;
>  	unsigned int cpu = smp_processor_id();
> 
> -	mevt = this_cpu_ptr(&percpu_mct_tick);
> -	mevt->evt = evt;
> +	mevt = container_of(evt, struct mct_clock_event_device, evt);
> 
>  	mevt->base = EXYNOS4_MCT_L_BASE(cpu);
>  	sprintf(mevt->name, "mct_tick%d", cpu);
> @@ -452,7 +449,7 @@ static int __cpuinit exynos4_local_timer_setup(struct
> clock_event_device *evt)
>  	return 0;
>  }
> 
> -static void exynos4_local_timer_stop(struct clock_event_device *evt)
> +static void __cpuinit exynos4_local_timer_stop(struct clock_event_device
> *evt)
>  {
>  	unsigned int cpu = smp_processor_id();
>  	evt->set_mode(CLOCK_EVT_MODE_UNUSED, evt);
> @@ -465,14 +462,37 @@ static void exynos4_local_timer_stop(struct
> clock_event_device *evt)
>  		disable_percpu_irq(mct_irqs[MCT_L0_IRQ]);
>  }
> 
> -static struct local_timer_ops exynos4_mct_tick_ops __cpuinitdata = {
> -	.setup	= exynos4_local_timer_setup,
> -	.stop	= exynos4_local_timer_stop,
> +static int __cpuinit exynos4_mct_cpu_notify(struct notifier_block *self,
> +					   unsigned long action, void *hcpu)
> +{
> +	struct mct_clock_event_device *mevt;
> +
> +	/*
> +	 * Grab cpu pointer in each case to avoid spurious
> +	 * preemptible warnings
> +	 */
> +	switch (action & ~CPU_TASKS_FROZEN) {
> +	case CPU_STARTING:
> +		mevt = this_cpu_ptr(&percpu_mct_tick);
> +		exynos4_local_timer_setup(&mevt->evt);
> +		break;
> +	case CPU_DYING:
> +		mevt = this_cpu_ptr(&percpu_mct_tick);
> +		exynos4_local_timer_stop(&mevt->evt);
> +		break;
> +	}
> +
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block exynos4_mct_cpu_nb __cpuinitdata = {
> +	.notifier_call = exynos4_mct_cpu_notify,
>  };
> -#endif /* CONFIG_LOCAL_TIMERS */
> 
>  static void __init exynos4_timer_resources(struct device_node *np, void
> __iomem *base)
>  {
> +	int err;
> +	struct mct_clock_event_device *mevt =
> this_cpu_ptr(&percpu_mct_tick);
>  	struct clk *mct_clk, *tick_clk;
> 
>  	tick_clk = np ? of_clk_get_by_name(np, "fin_pll") :
> @@ -490,9 +510,7 @@ static void __init exynos4_timer_resources(struct
> device_node *np, void __iomem
>  	if (!reg_base)
>  		panic("%s: unable to ioremap mct address space\n",
__func__);
> 
> -#ifdef CONFIG_LOCAL_TIMERS
>  	if (mct_int_type == MCT_INT_PPI) {
> -		int err;
> 
>  		err = request_percpu_irq(mct_irqs[MCT_L0_IRQ],
>  					 exynos4_mct_tick_isr, "MCT",
> @@ -501,8 +519,16 @@ static void __init exynos4_timer_resources(struct
> device_node *np, void __iomem
>  		     mct_irqs[MCT_L0_IRQ], err);
>  	}
> 
> -	local_timer_register(&exynos4_mct_tick_ops);
> -#endif /* CONFIG_LOCAL_TIMERS */
> +	err = register_cpu_notifier(&exynos4_mct_cpu_nb);
> +	if (err)
> +		goto out_irq;
> +
> +	/* Immediately configure the timer on the boot CPU */
> +	exynos4_local_timer_setup(&mevt->evt);
> +	return;
> +
> +out_irq:
> +	free_percpu_irq(mct_irqs[MCT_L0_IRQ], &percpu_mct_tick);
>  }
> 
>  void __init mct_init(void __iomem *base, int irq_g0, int irq_l0, int
> irq_l1)
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation

