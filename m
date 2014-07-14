Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139AbaGNEJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 00:09:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61464 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaGNEJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 00:09:49 -0400
X-AuditID: cbfee690-b7fb56d000003439-ff-53c3580b6fd6
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        naushad@samsung.com, t.figa@samsung.com, joshi@samsung.com,
        vikas.sajjan@samsung.com, chow.kim@samsung.com
References: <1404705056-11965-1-git-send-email-pankaj.dubey@samsung.com>
 <1404705056-11965-3-git-send-email-pankaj.dubey@samsung.com>
 <53BB25B7.6000500@samsung.com> <000801cf9a7f$3896e150$a9c4a3f0$@samsung.com>
 <026701cf9c43$98b20860$ca161920$@samsung.com>
In-reply-to: <026701cf9c43$98b20860$ca161920$@samsung.com>
Subject: RE: [PATCH v6 2/6] ARM: EXYNOS: Move cpufreq and cpuidle device
 registration to init_machine
Date: Mon, 14 Jul 2014 09:40:59 +0530
Message-id: <000301cf9f19$9fff2110$dffd6330$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQEaU7Q6At8rMhsBv/R1lp0UktfiQgLFxINjAml4XUMBgODIYgL0EKJknLxoYnA=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsWyRsSkTpc74nCwwatzhhbLJt1ls/i+6wu7
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLG5f5rX4dPQ/q8X6Ga9ZLG4+287kwOXR0tzD5rF5Sb1H
	35ZVjB6fN8kFsERx2aSk5mSWpRbp2yVwZdz7e4+5YJ54xe5Nb1gbGJuEuhg5OSQETCT+LnrN
	BmGLSVy4tx7I5uIQEljKKNE4uYMNpmjfqgPMEIlFjBJ9J7vZIZy/jBJ3ryxnAqliE9CVePJ+
	LjOILSKgIfF09xFGkCJmgc+MEosm7meE6Ghjknh4fAsLSBWngJVEz5dlYB3CAukSJ5adZQSx
	WQRUJaYtOQFkc3DwClhKLL4hCxLmFRCU+DH5Hlgrs4CWxPqdx5kgbHmJzWveMkOcqiCx4+xr
	Rogj/CSuT5vMDFEjLjHpwUOwqyUEfrJL7DgynRlil4DEt8mHWEB2SQjISmw6ADVHUuLgihss
	ExglZiFZPQvJ6llIVs9CsmIBI8sqRtHUguSC4qT0IhO94sTc4tK8dL3k/NxNjMCYPv3v2YQd
	jPcOWB9iTAZaP5FZSjQ5H5gS8kriDY3NjCxMTUyNjcwtzUgTVhLnVXuUFCQkkJ5YkpqdmlqQ
	WhRfVJqTWnyIkYmDU6qBUVfra37S7UMzJU3ljt168mDrtZcsgScOteg2MxgYaPfv0ZA1+a3L
	5F8bPn1Vj9lrSZWygpSlB3uOV3eZGi6d3K2junrvvBlf3ixnsDC+MFuEq7WqxWqWoBjTPvaM
	/rVSype0ttmlfejNTxJ66KTjeeHwPHH524uFuLgtTvfsfb5IMtinSl9AiaU4I9FQi7moOBEA
	X9mt4P8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jAV3uiMPBBtO2a1osm3SXzeL7ri/s
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9mdfi09H/rBbrZ7xmsbj5bDuTA5dHS3MPm8fmJfUe
	fVtWMXp83iQXwBLVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk
	4hOg65aZA3SPkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHj3t97zAXz
	xCt2b3rD2sDYJNTFyMkhIWAisW/VAWYIW0ziwr31bF2MXBxCAosYJfpOdrNDOH8ZJe5eWc4E
	UsUmoCvx5P1csA4RAQ2Jp7uPMIIUMQt8ZpRYNHE/I0RHG5PEw+NbWECqOAWsJHq+LAPrEBZI
	lzix7CwjiM0ioCoxbckJIJuDg1fAUmLxDVmQMK+AoMSPyffAWpkFtCTW7zzOBGHLS2xe8xbq
	VAWJHWdfM0Ic4SdxfdpkZogacYlJDx6yT2AUmoVk1Cwko2YhGTULScsCRpZVjKKpBckFxUnp
	uYZ6xYm5xaV56XrJ+bmbGMEJ45nUDsaVDRaHGAU4GJV4eDM4DgcLsSaWFVfmHmKU4GBWEuEN
	dwMK8aYkVlalFuXHF5XmpBYfYjQFenQis5Rocj4wmeWVxBsam5ibGptamliYmFkqifMeaLUO
	FBJITyxJzU5NLUgtgulj4uCUamA8nPvz6YdtB0IW3JhxIDn+4x0LsTVr50j/WZFq2sN1UVb8
	qXDp1u8daj+udOtVc/KpLpjZcD7o/F2xVyFTs364RXu0nvJ8u+edtGRo/1Fd/stay8LNFp6e
	u1JrwmQjkd3S75rm29ixt8ecLttWeLpR5jELRwzj+iPvc74e+3hp71FPgRZOlkw7JZbijERD
	Leai4kQAcXtuBi4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

On Thursday, July 10, 2014 7:04 PM, Kukjin wrote:
> Pankaj Dubey wrote:
> >
> > Hi Kukjin,
> >
> Hi,
> 
> > >
> > > On 07/07/14 12:50, Pankaj Dubey wrote:
> > > > As exynos_cpuidle_init and exynos_cpufreq_init function have just
> > > > one lines of code for registering platform devices. We can move
> > > > these lines to exynos_dt_machine_init and delete
> > > > exynos_cpuidle_init and exynos_cpufreq_init function. This will
> > > > help in reducing lines of code in exynos.c, making it more cleaner.
> > > >
> > > > Suggested-by: Tomasz Figa<t.figa@samsung.com>
> > > > Signed-off-by: Pankaj Dubey<pankaj.dubey@samsung.com>
> > > > Reviewed-by: Tomasz Figa<t.figa@samsung.com>
> > > > ---
> > > >   arch/arm/mach-exynos/exynos.c |   20 ++++----------------
> > > >   1 file changed, 4 insertions(+), 16 deletions(-)
> > > >
> > > > diff --git a/arch/arm/mach-exynos/exynos.c
> > > > b/arch/arm/mach-exynos/exynos.c index ff60b4c..47170eb 100644
> > > > --- a/arch/arm/mach-exynos/exynos.c
> > > > +++ b/arch/arm/mach-exynos/exynos.c
> > > > @@ -171,19 +171,6 @@ static struct platform_device exynos_cpuidle =
{
> > > >   	.id                = -1,
> > > >   };
> > > >
> > > > -void __init exynos_cpuidle_init(void) -{
> > > > -	if (soc_is_exynos5440())
> > > > -		return;
> > > > -
> > > > -	platform_device_register(&exynos_cpuidle);
> > > > -}
> > > > -
> > > > -void __init exynos_cpufreq_init(void) -{
> > > > -	platform_device_register_simple("exynos-cpufreq", -1, NULL,
0);
> > > > -}
> > > > -
> > > >   void __iomem *sysram_base_addr;
> > > >   void __iomem *sysram_ns_base_addr;
> > > >
> > > > @@ -300,10 +287,11 @@ static void __init
exynos_dt_machine_init(void)
> > > >   	if (!IS_ENABLED(CONFIG_SMP))
> > > >   		exynos_sysram_init();
> > > >
> > > > -	if (!of_machine_is_compatible("samsung,exynos5420"))
> > > > -		exynos_cpuidle_init();
> > > > +	if (!of_machine_is_compatible("samsung,exynos5420") ||
> > > > +
!of_machine_is_compatible("samsung,exynos5440"))
> > > > +		platform_device_register(&exynos_cpuidle);
> > > >
> > > > -	exynos_cpufreq_init();
> > > > +	platform_device_register_simple("exynos-cpufreq", -1, NULL,
0);
> > > >
> > > >   	of_platform_populate(NULL, of_default_bus_match_table, NULL,
> NULL);
> > > >   }
> > >
> > > This cannot be applied in my tree now....
> > >
> >
> > May I know what the issue is? As I am able to rebase this patch on
> > today's kgene/for-next and could not see any merge conflict.
> > If you think I need to respin this patch please let me know.
> >
> 
> Pankaj, I found this is based on cpuidle related branch in my tree, BTW
this
> has a dependency with following so please respin your patch once I take
the
> patch in my tree maybe tonight.
> 
> https://lkml.org/lkml/2014/6/24/286
> 

Thanks. I have respinned this after resolving merge conflict. 


Thanks,
Pankaj Dubey

> Thanks,
> Kukjin

