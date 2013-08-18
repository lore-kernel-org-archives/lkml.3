Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab3HRV6f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 17:58:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53860 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812Ab3HRV6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 17:58:32 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-90-521143876ff2
From: Kukjin Kim <kgene@kernel.org>
To: "'amit daniel kachhap'" <amit.daniel@samsung.com>,
        "'Viresh Kumar'" <viresh.kumar@linaro.org>
Cc: "'Rafael J. Wysocki'" <rjw@sisk.pl>,
        "'linaro-kernel'" <linaro-kernel@lists.linaro.org>, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1376486713.git.viresh.kumar@linaro.org>
 <b3ef5357898c06aaccb2fcbaee4ef91a3d0fd7bb.1376486713.git.viresh.kumar@linaro.org>
 <CADGdYn5nPCOb=mqoJPXzbZzgnbfrhFX6+nsUO5h+PTc-M=2NFA@mail.gmail.com>
In-reply-to: <CADGdYn5nPCOb=mqoJPXzbZzgnbfrhFX6+nsUO5h+PTc-M=2NFA@mail.gmail.com>
Subject: RE: [PATCH 13/37] cpufreq: exynos: don't initialize part of policy
 that is set by core too
Date: Mon, 19 Aug 2013 06:58:31 +0900
Message-id: <15fc01ce9c5e$13e53390$3baf9ab0$@org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6cAL1KahLfOWKpRpW/bc1Ir4J2uwAXTwDg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t8zfd12Z8Egg31LtCwaroZYPG36wW7x
	/tAzZovLu+awWXzuPcJoMeXwFxaL/oW9TBYbv3o4cHjcubaHzeP2v8fMHn1bVjF6PFrcwujx
	eZNcAGsUl01Kak5mWWqRvl0CV8bT2U9ZC07xV8x6e4qxgXElTxcjJ4eEgIlEz6RlbBC2mMSF
	e+uBbC4OIYFljBJvt6xngylacX0NC4gtJLCIUWL6XGeIor+MEm8WdLB3MXJwsAkoSzQ26YPU
	CAtoSSzc0gRWLyIQL3F/z2smkHpmgUOMEv9arkMNusooMfmeK0gvp0CwxJ8F7hC9qRK9uy6D
	7WURUJVY19jFDmLzChhKTOxexgphC0r8mHwPbAwz0K71O48zQdjyEpvXvGUGGSkhoC7x6K8u
	xAlGEjdb+6FKRCT2vXjHCHKOhMBfdokZW/+xQuwSkPg2+RALRK+sxKYDzBCvS0ocXHGDZQKj
	5Cwkm2ch2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSiV5yYW1yal66XnJ+7iRES2RN2MN47YH2I
	MRlo/URmKdHkfGBiyCuJNzQ2M7IwNTE1NjK3NCNNWEmcV73FOlBIID2xJDU7NbUgtSi+qDQn
	tfgQIxMHp1QDY8H6vc8YtG/WrmXIXB+VrMJbebUyLPjC6fj8UIub17Pf1664cWjzpaz7fCKf
	Xyl5b3Cs269t+uqY+C3PwOZtW3SlzBWLLc5OCkoUXr49ZB1vld/TibPrbxlGMZs+XVgevf6O
	06Zsk1k73p3Z+sr18ScF0aQnol8mPN8156v5I4EtjZtri9/fdlJiKc5INNRiLipOBABU5ebr
	AgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDKsWRmVeSWpSXmKPExsVy+t9jAd12Z8EggwcbVC0aroZYPG36wW7x
	/tAzZovLu+awWXzuPcJoMeXwFxaL/oW9TBYbv3o4cHjcubaHzeP2v8fMHn1bVjF6PFrcwujx
	eZNcAGtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtApSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaMp7Ofshac4q+Y9fYU
	YwPjSp4uRk4OCQETiRXX17BA2GISF+6tZwOxhQQWMUpMn+vcxcgFZP9llHizoIO9i5GDg01A
	WaKxSR+kRlhAS2LhliawXhGBeIn7e14zgdQzCxxilPjXcp0FYtBVRonJ91xBejkFgiX+LHCH
	6E2V6N11GWwXi4CqxLrGLnYQm1fAUGJi9zJWCFtQ4sfke2BjmIF2rd95nAnClpfYvOYtM8hI
	CQF1iUd/dSFOMJK42doPVSIise/FO8YJjMKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3X
	SK84Mbe4NC9dLzk/dxMjOG08k97BuKrB4hCjAAejEg/vhrf8QUKsiWXFlblAf3MwK4nwsqgJ
	BgnxpiRWVqUW5ccXleakFh9iTAZ6dCKzlGhyPjCl5ZXEGxqbmBlZGplZGJmYm5MmrCTOe7DV
	OlBIID2xJDU7NbUgtQhmCxMHp1QDo4HlrV97JCzTV5xjyJ7z6DdL7b2aHoH4r9H7v1ZuU/i9
	Luu455Uz3ya0uL6Yv9P0sciyhmNzLzA9Mro36eCxt29qvL+dX5p52Pp823eeB0+MXyY9inWv
	ib70/UPgxXuGrp/fz3rJeKePZ5esBuOuDUfm+3A+2t106n1j1OOPv9z4lVr/NUTsvOOjxFKc
	kWioxVxUnAgA/ISFqF8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

amit daniel kachhap wrote:
> 
> On Wed, Aug 14, 2013 at 7:02 PM, Viresh Kumar <viresh.kumar@linaro.org>
> wrote:
> > Many common initializations of struct policy are moved to core now and
> hence
> > this driver doesn't need to do it. This patch removes such code.
> >
> > Most recent of those changes is to call ->get() in the core after
> calling
> > ->init().
> >
> > Cc: Kukjin Kim <kgene.kim@samsung.com>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks,
Kukjin

> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> This consolidation work looks fine,
> Acked-By: Amit Daniel Kachhap <amit.daniel@samsung.com>
> 
> Thanks,
> Amit
> > ---
> >  drivers/cpufreq/exynos-cpufreq.c     | 2 --
> >  drivers/cpufreq/exynos5440-cpufreq.c | 1 -
> >  2 files changed, 3 deletions(-)
> >
> > diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-
> cpufreq.c
> > index 79b869b..b1db082 100644
> > --- a/drivers/cpufreq/exynos-cpufreq.c
> > +++ b/drivers/cpufreq/exynos-cpufreq.c
> > @@ -226,8 +226,6 @@ static struct notifier_block exynos_cpufreq_nb = {
> >
> >  static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
> >  {
> > -       policy->cur = policy->min = policy->max =
exynos_getspeed(policy-
> >cpu);
> > -
> >         /* set the transition latency value */
> >         policy->cpuinfo.transition_latency = 100000;
> >
> > diff --git a/drivers/cpufreq/exynos5440-cpufreq.c
> b/drivers/cpufreq/exynos5440-cpufreq.c
> > index 9a5ed485..91a64d6 100644
> > --- a/drivers/cpufreq/exynos5440-cpufreq.c
> > +++ b/drivers/cpufreq/exynos5440-cpufreq.c
> > @@ -316,7 +316,6 @@ static int exynos_cpufreq_cpu_init(struct
> cpufreq_policy *policy)
> >                 return ret;
> >         }
> >
> > -       policy->cur = dvfs_info->cur_frequency;
> >         policy->cpuinfo.transition_latency = dvfs_info->latency;
> >         cpumask_setall(policy->cpus);
> >
> > --
> > 1.7.12.rc2.18.g61b472e

