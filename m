Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaGHHeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 03:34:13 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25721 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaGHHeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 03:34:11 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-71-53bb9eef853b
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        naushad@samsung.com, t.figa@samsung.com, joshi@samsung.com,
        vikas.sajjan@samsung.com, chow.kim@samsung.com
References: <1404705056-11965-1-git-send-email-pankaj.dubey@samsung.com>
 <1404705056-11965-3-git-send-email-pankaj.dubey@samsung.com>
 <53BB25B7.6000500@samsung.com>
In-reply-to: <53BB25B7.6000500@samsung.com>
Subject: RE: [PATCH v6 2/6] ARM: EXYNOS: Move cpufreq and cpuidle device
 registration to init_machine
Date: Tue, 08 Jul 2014 13:05:39 +0530
Message-id: <000801cf9a7f$3896e150$a9c4a3f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQEaU7Q6At8rMhsBv/R1lp0UktfiQgLFxINjAml4XUOc1tv3EA==
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsWyRsSkVvf9vN3BBsvWsVssm3SXzeL7ri/s
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9mdfi09H/rBbrZ7xmsbj5bDuTA5dHS3MPm8fmJfUe
	fVtWMXp83iQXwBLFZZOSmpNZllqkb5fAlXHq6QzGgl+CFb37FzE1MO7j62Lk5JAQMJFYNPE/
	E4QtJnHh3nq2LkYuDiGBpYwS6w6uY4EpOnhvIRuILSSwiFFi9XddiKK/jBI7Jp5hBEmwCehK
	PHk/lxnEFhHQkHi6+wgjSBGzwGdGoBX7GSE6VjBKXP40FWwfp4C2xM+/n9hBbGGBdIkTy86C
	TWIRUJX4cfEdWJxXwFJix/5TLBC2oMSPyffAbGYBLYn1O48zQdjyEpvXvGWGOFVBYsfZ14wQ
	VzhJbGi7wwpRIy4x6cFDdpAjJAS+skucedLJArFMQOLb5ENANgdQQlZi0wGoOZISB1fcYJnA
	KDELyepZSFbPQrJ6FpIVCxhZVjGKphYkFxQnpRcZ6RUn5haX5qXrJefnbmIExvTpf8/6djDe
	PGB9iDEZaP1EZinR5HxgSsgriTc0NjOyMDUxNTYytzQjTVhJnHfRw6QgIYH0xJLU7NTUgtSi
	+KLSnNTiQ4xMHJxSDYzBfrs3bzr3+PnjlB0NdwOUNl4rsyouzmKO2fNxb3399djVEklRoqcv
	xD672tTI5/Z4j6RAnvA9ww3W3mc/hn8xrMv+Yf/ylc/h++yz7k3UFC8+ezQv/n1o547/W5Lc
	JP+ws0SyHGK2OefD4Pf5R5LYH+HnLdNOWzHZMn995Syq8uvFB9n/xeeVWIozEg21mIuKEwEx
	3OJC/wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jAd1383YHG8yZY22xbNJdNovvu76w
	W/QuuMpmsenxNVaLy7vmsFnMOL+PyeL2ZV6LT0f/s1qsn/GaxeLms+1MDlweLc09bB6bl9R7
	9G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2S
	i0+ArltmDtA9SgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMU09nMBb8
	Eqzo3b+IqYFxH18XIyeHhICJxMF7C9kgbDGJC/fWg9lCAosYJVZ/1+1i5AKy/zJK7Jh4hhEk
	wSagK/Hk/VxmEFtEQEPi6e4jjCBFzAKfGSUWTdzPCNGxglHi8qepTCBVnALaEj//fmIHsYUF
	0iVOLDsLNolFQFXix8V3YHFeAUuJHftPsUDYghI/Jt8Ds5kFtCTW7zzOBGHLS2xe85YZ4lQF
	iR1nXzNCXOEksaHtDitEjbjEpAcP2ScwCs1CMmoWklGzkIyahaRlASPLKkbR1ILkguKk9FxD
	veLE3OLSvHS95PzcTYzghPFMagfjygaLQ4wCHIxKPLwrDu4KFmJNLCuuzD3EKMHBrCTCu2I5
	UIg3JbGyKrUoP76oNCe1+BCjKdCnE5mlRJPzgcksryTe0NjE3NTY1NLEwsTMUkmc90CrdaCQ
	QHpiSWp2ampBahFMHxMHp1QDo3p45KyybcUeh5X43N9tK5uTsu5tovmRniZr8X9VgT6TzKPa
	dF+fWFrHvZn3TXXDpVsvPy3Zt3TONM97spHb2AueGkhsWXPo0C8fba9y3di5nw/ylkT76N1s
	2WlY+lsg3i9Bb/HirIiL7x19GcXUyu+zMCSv27iplUGqWXWZ8hKFOdo9q+yUlViKMxINtZiL
	ihMBwIcoRy4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

> 
> On 07/07/14 12:50, Pankaj Dubey wrote:
> > As exynos_cpuidle_init and exynos_cpufreq_init function have just one
> > lines of code for registering platform devices. We can move these
> > lines to exynos_dt_machine_init and delete exynos_cpuidle_init and
> > exynos_cpufreq_init function. This will help in reducing lines of code
> > in exynos.c, making it more cleaner.
> >
> > Suggested-by: Tomasz Figa<t.figa@samsung.com>
> > Signed-off-by: Pankaj Dubey<pankaj.dubey@samsung.com>
> > Reviewed-by: Tomasz Figa<t.figa@samsung.com>
> > ---
> >   arch/arm/mach-exynos/exynos.c |   20 ++++----------------
> >   1 file changed, 4 insertions(+), 16 deletions(-)
> >
> > diff --git a/arch/arm/mach-exynos/exynos.c
> > b/arch/arm/mach-exynos/exynos.c index ff60b4c..47170eb 100644
> > --- a/arch/arm/mach-exynos/exynos.c
> > +++ b/arch/arm/mach-exynos/exynos.c
> > @@ -171,19 +171,6 @@ static struct platform_device exynos_cpuidle = {
> >   	.id                = -1,
> >   };
> >
> > -void __init exynos_cpuidle_init(void) -{
> > -	if (soc_is_exynos5440())
> > -		return;
> > -
> > -	platform_device_register(&exynos_cpuidle);
> > -}
> > -
> > -void __init exynos_cpufreq_init(void) -{
> > -	platform_device_register_simple("exynos-cpufreq", -1, NULL, 0);
> > -}
> > -
> >   void __iomem *sysram_base_addr;
> >   void __iomem *sysram_ns_base_addr;
> >
> > @@ -300,10 +287,11 @@ static void __init exynos_dt_machine_init(void)
> >   	if (!IS_ENABLED(CONFIG_SMP))
> >   		exynos_sysram_init();
> >
> > -	if (!of_machine_is_compatible("samsung,exynos5420"))
> > -		exynos_cpuidle_init();
> > +	if (!of_machine_is_compatible("samsung,exynos5420") ||
> > +			!of_machine_is_compatible("samsung,exynos5440"))
> > +		platform_device_register(&exynos_cpuidle);
> >
> > -	exynos_cpufreq_init();
> > +	platform_device_register_simple("exynos-cpufreq", -1, NULL, 0);
> >
> >   	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> >   }
> 
> This cannot be applied in my tree now....
> 

May I know what the issue is? As I am able to rebase this patch on today's
kgene/for-next
and could not see any merge conflict. 
If you think I need to respin this patch please let me know.

Thanks,
Pankaj Dubey

> - Kukjin

