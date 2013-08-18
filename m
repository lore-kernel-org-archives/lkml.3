Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab3HRV5b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 17:57:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53831 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab3HRV53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 17:57:29 -0400
X-AuditID: cbfee691-b7fef6d000002d62-18-52114347d1df
From: Kukjin Kim <kgene@kernel.org>
To: "'amit daniel kachhap'" <amit.daniel@samsung.com>,
        "'Viresh Kumar'" <viresh.kumar@linaro.org>
Cc: "'Rafael J. Wysocki'" <rjw@sisk.pl>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'LAK'" <linux-arm-kernel@lists.infradead.org>
References: <cover.1376619363.git.viresh.kumar@linaro.org>
 <14993d27bdc6a91eced0af5eb96bdb5ca6546cbf.1376619363.git.viresh.kumar@linaro.org>
 <CADGdYn6TKURuO8jxL=tjvSLbmpUoUwoa08MZhsBAiEF91FM-cA@mail.gmail.com>
In-reply-to: <CADGdYn6TKURuO8jxL=tjvSLbmpUoUwoa08MZhsBAiEF91FM-cA@mail.gmail.com>
Subject: RE: [PATCH 13/34] cpufreq: exynos5440: set CPUFREQ_NO_NOTIFICATION flag
Date: Mon, 19 Aug 2013 06:57:27 +0900
Message-id: <15ca01ce9c5d$ed957650$c8c062f0$@org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6cAUGcPxgOJy6QSA2z08fYBJRE1AAXJKtg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsVy+t8zfV13Z8Eggx0nJC0aroZYPG36wW7x
	/tAzZotNj6+xWlzeNYfN4nPvEUaLKYe/sFj0L+xlstj41cOB0+POtT1sHpuX1Hvc/veY2aNv
	yypGj0eLWxg9Pm+SC2CL4rJJSc3JLEst0rdL4MrYtWUaW8F7/orbkz+yNjBO5Oli5OSQEDCR
	ODHpNCOELSZx4d56NhBbSGAZo8SHaWEwNcu3zGLtYuQCii9ilPj46zgbhPOXUWL+iwtA3Rwc
	bALKEo1N+iANwgJaEgu3NLGA2CIC8RL397xmArGZBe4xSjRfTYHovcoo8aDlHitIglMgWOLU
	rhdMEM0BEh8uXQabySKgKtHzgQfE5BUwlJhyVRekgldAUOLH5HssECO1JNbvPA41Xl5i85q3
	zCDlEgLqEo/+6kJcYCTx49wbZogSEYl9L94xglwgIdDJIXFkwyx2kASLgIDEt8mHWCB6ZSU2
	HWCGeF1S4uCKGywTGCVnIdk8C8nmWUg2z0KyYgEjyypG0dSC5ILipPQiU73ixNzi0rx0veT8
	3E2MkEifuIPx/gHrQ4zJQOsnMkuJJucDE0VeSbyhsZmRhamJqbGRuaUZacJK4rzqLdaBQgLp
	iSWp2ampBalF8UWlOanFhxiZODilGhiLHv57t190WufbHRFL79U907DnbItmPLNMY6Pm+fmZ
	hSkTj0/J63m5KV7qo3df0No5nxy/z7osfKtxeo5S64bDd1isLj53KO9aF8/uvSvy4zLjJ7U8
	IV5f2xP0JSQWe1eJlnU8MFHum1VoHl245eYK5it3u+UF8rLXX/S7n7aD/arMjeTFQU+VWIoz
	Eg21mIuKEwF7xkX2CgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsVy+t9jAV13Z8EggykrRSwaroZYPG36wW7x
	/tAzZotNj6+xWlzeNYfN4nPvEUaLKYe/sFj0L+xlstj41cOB0+POtT1sHpuX1Hvc/veY2aNv
	yypGj0eLWxg9Pm+SC2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvM
	TbVVcvEJ0HXLzAG6SUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYsWvL
	NLaC9/wVtyd/ZG1gnMjTxcjJISFgIrF8yyxWCFtM4sK99WxdjFwcQgKLGCU+/joO5fxllJj/
	4gJjFyMHB5uAskRjkz5Ig7CAlsTCLU0sILaIQLzE/T2vmUBsZoF7jBLNV1Mgeq8ySjxouQe2
	gVMgWOLUrhdMEM0BEh8uXQabySKgKtHzgQfE5BUwlJhyVRekgldAUOLH5HssECO1JNbvPA41
	Xl5i85q3zCDlEgLqEo/+6kJcYCTx49wbZogSEYl9L94xTmAUnoVk0iwkk2YhmTQLScsCRpZV
	jKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMGJ5JnUDsaVDRaHGAU4GJV4eDe85Q8SYk0sK67M
	PcQowcGsJMLLoiYYJMSbklhZlVqUH19UmpNafIgxGejNicxSosn5wCSXVxJvaGxiZmRpZGZh
	ZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MCjZ6n+R2el+ZMD/+3yOzJ+UeH0vu
	nb2f8eUA/7xLDX9fJ2i1TXa5WPRpufhxyXaPw9sV9s1U3rApkNGtQnUq+xNrBXfVgpZDcm8/
	nF/XMbspNW9SI/fRNbzroznMVYxOiC4+MjtavdRu0ZNo6x+vTykLsYuaHfN+sqSibMfX/c4y
	avs0Zi7dq8RSnJFoqMVcVJwIANQvknhoAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

amit daniel kachhap wrote:
> 
> On Fri, Aug 16, 2013 at 7:55 AM, Viresh Kumar <viresh.kumar@linaro.org>
> wrote:
> > Most of the drivers do following in their ->target_index() routines:
> >
> >         struct cpufreq_freqs freqs;
> >         freqs.old = old freq...
> >         freqs.new = new freq...
> >
> >         cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
> >
> >         /* Change rate here */
> >
> >         cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
> >
> > This is replicated over all cpufreq drivers today and there doesn't
> exists a
> > good enough reason why this shouldn't be moved to cpufreq core instead.
> >
> > Earlier patches have added support in cpufreq core to do cpufreq
> notification on
> > frequency change, but this drivers needs to do this notification itself
> and so
> > it sets its CPUFREQ_NO_NOTIFICATION flag.
> >
> > Cc: Kukjin Kim <kgene.kim@samsung.com>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks,
Kukjin

> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> The code change looks fine,
> Acked-By: Amit Daniel Kachhap <amit.daniel@samsung.com>
> 
> Thanks
> Amit Daniel
> > ---
> >  drivers/cpufreq/exynos5440-cpufreq.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/cpufreq/exynos5440-cpufreq.c
> b/drivers/cpufreq/exynos5440-cpufreq.c
> > index 91a64d6..8fb6183 100644
> > --- a/drivers/cpufreq/exynos5440-cpufreq.c
> > +++ b/drivers/cpufreq/exynos5440-cpufreq.c
> > @@ -323,7 +323,7 @@ static int exynos_cpufreq_cpu_init(struct
> cpufreq_policy *policy)
> >  }
> >
> >  static struct cpufreq_driver exynos_driver = {
> > -       .flags          = CPUFREQ_STICKY,
> > +       .flags          = CPUFREQ_STICKY | CPUFREQ_NO_NOTIFICATION,
> >         .verify         = cpufreq_generic_frequency_table_verify,
> >         .target_index   = exynos_target,
> >         .get            = exynos_getspeed,
> > --
> > 1.7.12.rc2.18.g61b472e

