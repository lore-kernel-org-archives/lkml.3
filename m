Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbaGHOCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:02:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:47823 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbaGHOCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:02:39 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-c4-53bbf9f9c005
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Tomasz Figa'" <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org,
        "'Jonghwan Choi'" <jhbird.choi@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
 <1403618235-19353-6-git-send-email-t.figa@samsung.com>
In-reply-to: <1403618235-19353-6-git-send-email-t.figa@samsung.com>
Subject: RE: [PATCH 5/6] ARM: EXYNOS: Fix suspend/resume sequencies
Date: Tue, 08 Jul 2014 23:02:33 +0900
Message-id: <036c01cf9ab5$43c5d370$cb517a50$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQImwlMNtKSRmS2HaaYx0l+evMEXagIo/MspmtacfmA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t8zY92fP3cHG0z7oWKxpJnbYtPja6wW
	l3fNYbOYcX4fk8XaI3fZLdbPeM1isWrXH0YHdo+ds+6ye2xeUu/Rt2UVo8fnTXIBLFFcNimp
	OZllqUX6dglcGZceNjEX3BSsuPZhI3MD4xfeLkZODgkBE4kHt1czQthiEhfurWfrYuTiEBJY
	xigxe+svdpiiTe8msUIkFjFKzD31jxHC+csoMeVzPxtIFZuAhsTh98/AOkQEyiRaTj0FG8Us
	sIBR4uytGWAJIYFqiWubb7KA2JwCzhJ3Hj1kBbGFgexHf1rA4iwCqhI/Tn4Bi/MKWEq8ersG
	yhaU+DH5HlgNs4CWxPqdx5kgbHmJzWveMkOcqiCx4+xrRogjrCSWrv/ACFEjIrHvxTuwqyUE
	7rFLdFxazgyxTEDi2+RDQEM5gBKyEpsOQM2RlDi44gbLBEaJWUhWz0KyehaS1bOQrFjAyLKK
	UTS1ILmgOCm9yFSvODG3uDQvXS85P3cTIyRqJ+5gvH/A+hBjMtD6icxSosn5wKjPK4k3NDYz
	sjA1MTU2Mrc0I01YSZw3/VFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGkekyp+3PSAp3
	Xdi6121PSmBxVFaBHMfLBbzOd+W2yn/a8eTQ/s2PtocnfBadtjNvIVd64XH572f4GIKb1Y/N
	7n7+8FqOt9hOrluK9jxVAunf2Kzef9sjnr5nZvBGlYtXtR8KBbV/KBWYWSGsOSeFKzzjO4sE
	S3WKmkmvdMzO8NZCWbu8v4JKLMUZiYZazEXFiQAMhZk48AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgO7Pn7uDDaaeU7BY0sxtsenxNVaL
	y7vmsFnMOL+PyWLtkbvsFutnvGaxWLXrD6MDu8fOWXfZPTYvqffo27KK0ePzJrkAlqgGRpuM
	1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoAOUFMoSc0qB
	QgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBmXHjYxF9wUrLj2YSNzA+MX3i5GTg4J
	AROJTe8msULYYhIX7q1n62Lk4hASWMQoMffUP0YI5y+jxJTP/WwgVWwCGhKH3z9jB7FFBMok
	Wk49BetgFljAKHH21gywhJBAtcS1zTdZQGxOAWeJO48egq0QBrIf/WkBi7MIqEr8OPkFLM4r
	YCnx6u0aKFtQ4sfke2A1zAJaEut3HmeCsOUlNq95ywxxqoLEjrOvGSGOsJJYuv4DI0SNiMS+
	F+8YJzAKzUIyahaSUbOQjJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOCU8Exq
	B+PKBotDjAIcjEo8vCsO7goWYk0sK67MPcQowcGsJML75dTuYCHelMTKqtSi/Pii0pzU4kOM
	pkCfTmSWEk3OB6arvJJ4Q2MTMyNLIzMLIxNzcyVx3gOt1oFCAumJJanZqakFqUUwfUwcnFIN
	jGtEyu/vamZ7uKng0Dy9X0WzOrk7y66vTT/zieH12h0380U2HSth7rrD8fSShrnk/kqrmSw8
	IeVLXJRqYp22LzNau/D0hH/G83bxmt86z3hH/t7i5k+GiZWhNQvPFG+48XNxJKfu4zelr+Q3
	J9zZEDlx/b+pX/07tR6E3l9V4ht6490xm4qoxZ1KLMUZiYZazEXFiQBYbq+MHwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Figa wrote:
> 
> Due to recent consolidation of Exynos suspend and cpuidle code, some
> parts of suspend and resume sequences are executed two times, once from
> exynos_pm_syscore_ops and then from exynos_cpu_pm_notifier() and thus it
> breaks suspend, at least on Exynos4-based boards.
> 
+ Jonghwan Choi

Yes, right. We moved the functionality into cpu_pm notifier in the commit ID
0ebc13e2 ("ARM: EXYNOS: Move the power sequence call in the cpu_pm notifier"),
so this should be fixed as you pointed out. But I talked to my colleague
Jonghwan about this and we need more time to have a look in detail for every
exynos SoCs. Will be back soon.

Thanks,
Kukjin

> This patch fixes the issue by removing exynos_pm_syscore_ops completely
> and making the code rely only on CPU PM notifier.
> 
> Tested on Exynos4210-based Trats board.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  arch/arm/mach-exynos/pm.c | 20 ++++----------------
>  1 file changed, 4 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
> index 87c0d34..98d4926 100644
> --- a/arch/arm/mach-exynos/pm.c
> +++ b/arch/arm/mach-exynos/pm.c
> @@ -364,11 +364,6 @@ early_wakeup:
>  	return;
>  }
> 
> -static struct syscore_ops exynos_pm_syscore_ops = {
> -	.suspend	= exynos_pm_suspend,
> -	.resume		= exynos_pm_resume,
> -};
> -
>  /*
>   * Suspend Ops
>   */
> @@ -438,19 +433,13 @@ static int exynos_cpu_pm_notifier(struct notifier_block *self,
> 
>  	switch (cmd) {
>  	case CPU_PM_ENTER:
> -		if (cpu == 0) {
> -			exynos_pm_central_suspend();
> -			exynos_cpu_save_register();
> -		}
> +		if (cpu == 0)
> +			exynos_pm_suspend();
>  		break;
> 
>  	case CPU_PM_EXIT:
> -		if (cpu == 0) {
> -			if (!soc_is_exynos5250())
> -				scu_enable(S5P_VA_SCU);
> -			exynos_cpu_restore_register();
> -			exynos_pm_central_resume();
> -		}
> +		if (cpu == 0)
> +			exynos_pm_resume();
>  		break;
>  	}
> 
> @@ -475,6 +464,5 @@ void __init exynos_pm_init(void)
>  	tmp |= ((0xFF << 8) | (0x1F << 1));
>  	__raw_writel(tmp, S5P_WAKEUP_MASK);
> 
> -	register_syscore_ops(&exynos_pm_syscore_ops);
>  	suspend_set_ops(&exynos_suspend_ops);
>  }
> --
> 1.9.3

