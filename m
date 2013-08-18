Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab3HRWAt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 18:00:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45914 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab3HRWAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 18:00:47 -0400
X-AuditID: cbfee691-b7fef6d000002d62-bc-5211440e0e23
From: Kukjin Kim <kgene@kernel.org>
To: "'amit daniel kachhap'" <amit.daniel@samsung.com>,
        "'Viresh Kumar'" <viresh.kumar@linaro.org>
Cc: "'Rafael J. Wysocki'" <rjw@sisk.pl>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1376116344.git.viresh.kumar@linaro.org>
 <d71c900c5af2378da4e4024150d9f22f4a97e9db.1376116345.git.viresh.kumar@linaro.org>
 <CADGdYn5xkUN8bO19Hbf2S-WcCNUe_TFOONkqyxNUF8QRAnnVzA@mail.gmail.com>
In-reply-to: <CADGdYn5xkUN8bO19Hbf2S-WcCNUe_TFOONkqyxNUF8QRAnnVzA@mail.gmail.com>
Subject: RE: [PATCH 19/44] cpufreq: exynos: Use generic cpufreq routines
Date: Mon, 19 Aug 2013 07:00:45 +0900
Message-id: <15fe01ce9c5e$6411a560$2c34f020$@org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6b+iSwVxCUH0gAS16zORoVkwhD3gAZCKUw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t8zY10+F8Egg4df+CwaroZYPG36wW7x
	/tAzZovLu+awWXzuPcJoMeXwFxaL/oW9TBYbv3o4cHjcubaHzeP2v8fMHn1bVjF6PFrcwujx
	eZNcAGsUl01Kak5mWWqRvl0CV8aXN5cYC2YqV8w5fYq1gXGxZBcjB4eEgInEx96iLkZOIFNM
	4sK99WxdjFwcQgLLGCWu3D7DBpEwkTh1/BcrRGIRo8SdS13sEM5fRokZrZcYQSaxCShLNDbp
	gzQIC2hJLNzSxAJiiwjES9zf85oJpJ5ZYAOjxILLM5kgmq8ySvx9+Z4VpIpTIFji+NKnrCCD
	hAU8JPauCgQJswioSkzrvMEIYvMKGEpMXn4AyhaU+DH5HtgCZqBl63ceZ4Kw5SU2r3nLDPGZ
	usSjv7oQNxhJ9OztgioRkdj34h0jyAkSAo0cElt7V7FC7BKQ+Db5EAtEr6zEpgPMEM9LShxc
	cYNlAqPkLCSbZyHZPAvJ5llIVixgZFnFKJpakFxQnJReZKpXnJhbXJqXrpecn7uJERLbE3cw
	3j9gfYgxGWj9RGYp0eR8YGrIK4k3NDYzsjA1MTU2Mrc0I01YSZxXvcU6UEggPbEkNTs1tSC1
	KL6oNCe1+BAjEwenVAPjnrcxseaiq/aKfM6Odz3/5KHom7BX9x7qlJ9YmnvtvveXqrx+QZ2V
	jH7n/Pi1nhnvFnAs0Oy7VyefterO3Hj+uITPDQ/ur6i6yDPJVvhgwqf0gjvLfFe9aXjW/TM+
	0VT++Mprfd6nquz/a1z4+kdOi/OnAmN98YNp1ukHIu5wH0lYOt3T5uROJZbijERDLeai4kQA
	hCYQsAMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHKsWRmVeSWpSXmKPExsVy+t9jAV0+F8Egg0MfOS0aroZYPG36wW7x
	/tAzZovLu+awWXzuPcJoMeXwFxaL/oW9TBYbv3o4cHjcubaHzeP2v8fMHn1bVjF6PFrcwujx
	eZNcAGtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtApSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaML28uMRbMVK6Yc/oU
	awPjYskuRk4OCQETiVPHf7FC2GISF+6tZ+ti5OIQEljEKHHnUhc7hPOXUWJG6yXGLkYODjYB
	ZYnGJn2QBmEBLYmFW5pYQGwRgXiJ+3teM4HUMwtsYJRYcHkmE0TzVUaJvy/fg63gFAiWOL70
	KSvIIGEBD4m9qwJBwiwCqhLTOm8wgti8AoYSk5cfgLIFJX5Mvge2gBlo2fqdx5kgbHmJzWve
	MoOMkRBQl3j0VxfiBiOJnr1dUCUiEvtevGOcwCg8C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguK
	k9JzDfWKE3OLS/PS9ZLzczcxglPHM6kdjCsbLA4xCnAwKvHwbnjLHyTEmlhWXJl7iFGCg1lJ
	hJdFTTBIiDclsbIqtSg/vqg0J7X4EGMy0KMTmaVEk/OBaS2vJN7Q2MTMyNLIzMLIxNycNGEl
	cd4DrdaBQgLpiSWp2ampBalFMFuYODilGhi5Pf88cFC8W3IuMqrPacOXkHUznLQWl8k8rluq
	1nqrSmJK5MSpsxZlN01108tWLnRJa33xz8Dw7dMFLJvldJ++5TPaIflh3s2mqN3vH2zyEVI8
	FGzk2xHUzqP0e7a5wuYnb+QetGx9N6mwb9vVnb8MS/4WCSrk79mScchoJ2PcnEk2ztPXzM5V
	YinOSDTUYi4qTgQAT85wA2EDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

amit daniel kachhap wrote:
> 
> On Sat, Aug 10, 2013 at 12:14 PM, Viresh Kumar <viresh.kumar@linaro.org>
> wrote:
> > Most of the CPUFreq drivers do similar things in .exit() and .verify()
> routines
> > and .attr. So its better if we have generic routines for them which can
> be used
> > by cpufreq drivers then.
> >
> > This patch uses these generic routines for this driver.
> >
> > Cc: Kukjin Kim <kgene.kim@samsung.com>

Looks good.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks,
Kukjin

> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> The consolidation code looks fine,
> Acked-By: Amit Daniel Kachhap <amit.daniel@samsung.com>
> 
> Thanks,
> Amit Daniel
> > ---
> >  drivers/cpufreq/exynos-cpufreq.c     | 23 +++--------------------
> >  drivers/cpufreq/exynos5440-cpufreq.c | 15 ++-------------
> >  2 files changed, 5 insertions(+), 33 deletions(-)
> >
> > diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-
> cpufreq.c
> > index 71c4926..7663a96 100644
> > --- a/drivers/cpufreq/exynos-cpufreq.c
> > +++ b/drivers/cpufreq/exynos-cpufreq.c
> > @@ -31,12 +31,6 @@ static unsigned int locking_frequency;
> >  static bool frequency_locked;
> >  static DEFINE_MUTEX(cpufreq_lock);
> >
> > -static int exynos_verify_speed(struct cpufreq_policy *policy)
> > -{
> > -       return cpufreq_frequency_table_verify(policy,
> > -                                             exynos_info->freq_table);
> > -}
> > -
> >  static unsigned int exynos_getspeed(unsigned int cpu)
> >  {
> >         return clk_get_rate(exynos_info->cpu_clk) / 1000;
> > @@ -257,26 +251,15 @@ static int exynos_cpufreq_cpu_init(struct
> cpufreq_policy *policy)
> >         return cpufreq_table_validate_and_show(policy, exynos_info-
> >freq_table);
> >  }
> >
> > -static int exynos_cpufreq_cpu_exit(struct cpufreq_policy *policy)
> > -{
> > -       cpufreq_frequency_table_put_attr(policy->cpu);
> > -       return 0;
> > -}
> > -
> > -static struct freq_attr *exynos_cpufreq_attr[] = {
> > -       &cpufreq_freq_attr_scaling_available_freqs,
> > -       NULL,
> > -};
> > -
> >  static struct cpufreq_driver exynos_driver = {
> >         .flags          = CPUFREQ_STICKY,
> > -       .verify         = exynos_verify_speed,
> > +       .verify         = cpufreq_generic_frequency_table_verify,
> >         .target         = exynos_target,
> >         .get            = exynos_getspeed,
> >         .init           = exynos_cpufreq_cpu_init,
> > -       .exit           = exynos_cpufreq_cpu_exit,
> > +       .exit           = cpufreq_generic_exit,
> >         .name           = "exynos_cpufreq",
> > -       .attr           = exynos_cpufreq_attr,
> > +       .attr           = cpufreq_generic_attr,
> >  #ifdef CONFIG_PM
> >         .suspend        = exynos_cpufreq_suspend,
> >         .resume         = exynos_cpufreq_resume,
> > diff --git a/drivers/cpufreq/exynos5440-cpufreq.c
> b/drivers/cpufreq/exynos5440-cpufreq.c
> > index b9dfc91..f139b3b 100644
> > --- a/drivers/cpufreq/exynos5440-cpufreq.c
> > +++ b/drivers/cpufreq/exynos5440-cpufreq.c
> > @@ -209,12 +209,6 @@ static void exynos_enable_dvfs(void)
> >                                 dvfs_info->base + XMU_DVFS_CTRL);
> >  }
> >
> > -static int exynos_verify_speed(struct cpufreq_policy *policy)
> > -{
> > -       return cpufreq_frequency_table_verify(policy,
> > -                                             dvfs_info->freq_table);
> > -}
> > -
> >  static unsigned int exynos_getspeed(unsigned int cpu)
> >  {
> >         return dvfs_info->cur_frequency;
> > @@ -336,18 +330,13 @@ static int exynos_cpufreq_cpu_init(struct
> cpufreq_policy *policy)
> >         return 0;
> >  }
> >
> > -static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
> > -{
> > -       cpufreq_frequency_table_put_attr(policy->cpu);
> > -}
> > -
> >  static struct cpufreq_driver exynos_driver = {
> >         .flags          = CPUFREQ_STICKY,
> > -       .verify         = exynos_verify_speed,
> > +       .verify         = cpufreq_generic_frequency_table_verify,
> >         .target         = exynos_target,
> >         .get            = exynos_getspeed,
> >         .init           = exynos_cpufreq_cpu_init,
> > -       .exit           = exynos_cpufreq_cpu_exit,
> > +       .exit           = cpufreq_generic_exit,
> >         .name           = CPUFREQ_NAME,
> >  };
> >
> > --
> > 1.7.12.rc2.18.g61b472e

