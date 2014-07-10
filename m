Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbaGJNeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:34:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:41311 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbaGJNd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:33:57 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-70-53be96432d01
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Pankaj Dubey'" <pankaj.dubey@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        naushad@samsung.com, t.figa@samsung.com, joshi@samsung.com,
        vikas.sajjan@samsung.com, chow.kim@samsung.com
References: <1404705056-11965-1-git-send-email-pankaj.dubey@samsung.com>
 <1404705056-11965-3-git-send-email-pankaj.dubey@samsung.com>
 <53BB25B7.6000500@samsung.com> <000801cf9a7f$3896e150$a9c4a3f0$@samsung.com>
In-reply-to: <000801cf9a7f$3896e150$a9c4a3f0$@samsung.com>
Subject: RE: [PATCH v6 2/6] ARM: EXYNOS: Move cpufreq and cpuidle device
 registration to init_machine
Date: Thu, 10 Jul 2014 22:33:55 +0900
Message-id: <026701cf9c43$98b20860$ca161920$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: AQEaU7Q6At8rMhsBv/R1lp0UktfiQgLFxINjAml4XUMBgODIYpzOXUEw
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t8zQ13nafuCDa42Slosm3SXzeL7ri/s
	FpseX2O1uLxrDpvFjPP7mCxuX+a1+HT0P6vFoq1AyfUzXrNY3Hy2ncmBy6OluYfNY/OSeo++
	LasYPT5vkgtgieKySUnNySxLLdK3S+DKWN5wgKXguUjFhyttTA2M+wS6GDk4JARMJE73h3Yx
	cgKZYhIX7q1n62Lk4hASWMYosW5fFytEwkTiyLOVrBCJRYwS9390sUA4fxkl5sxuZgepYhPQ
	kDj8/hmYLSKgKzHr0RtmkCJmgc+MEosm7meE6LjGKHGmcy4LSBWngJXExPsnmUBsYYF0iRPL
	zjKC2CwCqhI9fVvA4rwClhJr591lhrAFJX5MvgfWyyygJbF+53EmCFteYvOat8wQtypI7Dj7
	mhEiLiKx78U7RoiL3CQWTmwGO0JC4Cu7xLRXC5kglglIfJt8iAUSGLISmw5AzZGUOLjiBssE
	RolZSFbPQrJ6FpLVs5CsW8DIsopRNLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjJKYn7mC8f8D6
	EGMy0PqJzFKiyfnAlJBXEm9obGZkYWpiamxkbmlGmrCSOG/6o6QgIYH0xJLU7NTUgtSi+KLS
	nNTiQ4xMHJxSDYySWlbuzMt8Op5cm/aKc+eWhdsvLF0wo1Yh6pThygUnHljKuU+c+CLR99Ui
	ZrbKduvIl8WRSZOWn+GsEXPmfeHCs/ba1W8Rv1n4d1xefmdCn35b+OO0sCXvosKmsz9Vb+Fg
	mGUhKyvV1cAeLN+yXeB1VtyRskd1DscOh15Sl3Rnfh9+Qe/mkwglluKMREMt5qLiRACpdNcB
	/wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jAV3nafuCDU73iVgsm3SXzeL7ri/s
	FpseX2O1uLxrDpvFjPP7mCxuX+a1+HT0P6vFoq1AyfUzXrNY3Hy2ncmBy6OluYfNY/OSeo++
	LasYPT5vkgtgiWpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLx
	CdB1y8wBukdJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLG84QBLwXOR
	ig9X2pgaGPcJdDFyckgImEgcebaSFcIWk7hwbz1bFyMXh5DAIkaJ+z+6WCCcv4wSc2Y3s4NU
	sQloSBx+/wzMFhHQlZj16A0zSBGzwGdGiUUT9zNCdFxjlDjTOZcFpIpTwEpi4v2TTCC2sEC6
	xIllZxlBbBYBVYmevi1gcV4BS4m18+4yQ9iCEj8m3wPrZRbQkli/8zgThC0vsXnNW2aIWxUk
	dpx9zQgRF5HY9+IdI8RFbhILJzYzTmAUmoVk1Cwko2YhGTULSfsCRpZVjKKpBckFxUnpuYZ6
	xYm5xaV56XrJ+bmbGMEp45nUDsaVDRaHGAU4GJV4eBt69gYLsSaWFVfmHmKU4GBWEuHNqtsX
	LMSbklhZlVqUH19UmpNafIjRFOjTicxSosn5wHSWVxJvaGxiZmRpZGZhZGJuriTOe6DVOlBI
	ID2xJDU7NbUgtQimj4mDU6qBkbukWmxzeie/XGdD0EmWDwY7/8Wd5X78792RWddWBFxQY30p
	dDe7fMNtu/U6Qks25+ZZbOjVSFhyZdPHxBks3yWyjxgcOO81b8bcz/K7+9MXVCzMiXTW/PTk
	xuEvjnrRBvG3WpoT65d9tWjN4dpflhy+UV9QOy5Isqtqxo/TpeniDmmlt09fV2Ipzkg01GIu
	Kk4EANWzhiIvAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pankaj Dubey wrote:
> 
> Hi Kukjin,
> 
Hi,

> >
> > On 07/07/14 12:50, Pankaj Dubey wrote:
> > > As exynos_cpuidle_init and exynos_cpufreq_init function have just one
> > > lines of code for registering platform devices. We can move these
> > > lines to exynos_dt_machine_init and delete exynos_cpuidle_init and
> > > exynos_cpufreq_init function. This will help in reducing lines of code
> > > in exynos.c, making it more cleaner.
> > >
> > > Suggested-by: Tomasz Figa<t.figa@samsung.com>
> > > Signed-off-by: Pankaj Dubey<pankaj.dubey@samsung.com>
> > > Reviewed-by: Tomasz Figa<t.figa@samsung.com>
> > > ---
> > >   arch/arm/mach-exynos/exynos.c |   20 ++++----------------
> > >   1 file changed, 4 insertions(+), 16 deletions(-)
> > >
> > > diff --git a/arch/arm/mach-exynos/exynos.c
> > > b/arch/arm/mach-exynos/exynos.c index ff60b4c..47170eb 100644
> > > --- a/arch/arm/mach-exynos/exynos.c
> > > +++ b/arch/arm/mach-exynos/exynos.c
> > > @@ -171,19 +171,6 @@ static struct platform_device exynos_cpuidle = {
> > >   	.id                = -1,
> > >   };
> > >
> > > -void __init exynos_cpuidle_init(void) -{
> > > -	if (soc_is_exynos5440())
> > > -		return;
> > > -
> > > -	platform_device_register(&exynos_cpuidle);
> > > -}
> > > -
> > > -void __init exynos_cpufreq_init(void) -{
> > > -	platform_device_register_simple("exynos-cpufreq", -1, NULL, 0);
> > > -}
> > > -
> > >   void __iomem *sysram_base_addr;
> > >   void __iomem *sysram_ns_base_addr;
> > >
> > > @@ -300,10 +287,11 @@ static void __init exynos_dt_machine_init(void)
> > >   	if (!IS_ENABLED(CONFIG_SMP))
> > >   		exynos_sysram_init();
> > >
> > > -	if (!of_machine_is_compatible("samsung,exynos5420"))
> > > -		exynos_cpuidle_init();
> > > +	if (!of_machine_is_compatible("samsung,exynos5420") ||
> > > +			!of_machine_is_compatible("samsung,exynos5440"))
> > > +		platform_device_register(&exynos_cpuidle);
> > >
> > > -	exynos_cpufreq_init();
> > > +	platform_device_register_simple("exynos-cpufreq", -1, NULL, 0);
> > >
> > >   	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> > >   }
> >
> > This cannot be applied in my tree now....
> >
> 
> May I know what the issue is? As I am able to rebase this patch on today's
> kgene/for-next
> and could not see any merge conflict.
> If you think I need to respin this patch please let me know.
> 

Pankaj, I found this is based on cpuidle related branch in my tree, BTW this
has a dependency with following so please respin your patch once I take the
patch in my tree maybe tonight.

https://lkml.org/lkml/2014/6/24/286

Thanks,
Kukjin

