Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab3HRV7x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 17:59:53 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45829 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab3HRV7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 17:59:51 -0400
X-AuditID: cbfee691-b7fef6d000002d62-5d-521143d518ae
From: Kukjin Kim <kgene@kernel.org>
To: "'amit daniel kachhap'" <amit.daniel@samsung.com>,
        "'Viresh Kumar'" <viresh.kumar@linaro.org>
Cc: "'Rafael J. Wysocki'" <rjw@sisk.pl>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1376116344.git.viresh.kumar@linaro.org>
 <c2157d44d4933c5fa9cea06e0d621786a3d03671.1376116345.git.viresh.kumar@linaro.org>
 <CADGdYn79B4d3joAF53E5MoeNB10RWm5fnQCs30-MbM38Jq2uhg@mail.gmail.com>
In-reply-to: <CADGdYn79B4d3joAF53E5MoeNB10RWm5fnQCs30-MbM38Jq2uhg@mail.gmail.com>
Subject: RE: [PATCH 03/44] cpufreq: exynos: call
 cpufreq_frequency_table_put_attr()
Date: Mon, 19 Aug 2013 06:59:49 +0900
Message-id: <15fd01ce9c5e$42670630$c7351290$@org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6b+dQ5oLqbbuYYRayGa+4YdV9ToQAZEg1w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsVy+t8zI92rzoJBBndWaVs0XA2xeNr0g93i
	/aFnzBaXd81hs/jce4TRYsrhLywW/Qt7mSw2fvVw4PC4c20Pm8ftf4+ZPfq2rGL0eLS4hdHj
	8ya5ANYoLpuU1JzMstQifbsErow9u36yFMyUrji6h6eBcZdIFyMnh4SAiUTz03YWCFtM4sK9
	9WxdjFwcQgLLGCUmH2pmhCm6vOkvC0RiOqPEsp8/GCGcv4wSa/a+Yu1i5OBgE1CWaGzSB2kQ
	FtCSWLilCWyqiEC8xP09r5lA6pkFNjBKLLg8kwmi+SqjxOXZn5hAqjgFgiWO9r1ihugOldhz
	oR8sziKgKtE96z/YJF4BQ4ldi86xQtiCEj8m3wOLMwNtW7/zOBOELS+xec1bZpCDJATUJR79
	1YU4wkji+MtZjBAlIhL7XrwDe0BC4C+7xPs3pxkhdglIfJt8iAWiV1Zi0wFmiO8lJQ6uuMEy
	gVFyFpLNs5BsnoVk8ywkKxYwsqxiFE0tSC4oTkovMtUrTswtLs1L10vOz93ECInuiTsY7x+w
	PsSYDLR+IrOUaHI+MDnklcQbGpsZWZiamBobmVuakSasJM6r3mIdKCSQnliSmp2aWpBaFF9U
	mpNafIiRiYNTqoExllf7WfObPA6lRWY9yxcufiv3JM9mb+uuAot2nt+ikn59k18L8aldYzpw
	PFDnQvQFjZxpU1ZekO1/KayUeNZwakvw9l1z/Kq8CieteK7z2WBd+2SRLbcWm9zY8d1I6MTs
	VzcWnf16J/Igw/+L/dOO7QjXbT0zzyTh32Y1m4i1qnfvylipzFU5rsRSnJFoqMVcVJwIAJ3F
	TwsEAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHKsWRmVeSWpSXmKPExsVy+t9jQd2rzoJBBic/qlk0XA2xeNr0g93i
	/aFnzBaXd81hs/jce4TRYsrhLywW/Qt7mSw2fvVw4PC4c20Pm8ftf4+ZPfq2rGL0eLS4hdHj
	8ya5ANaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfM
	HKBTlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZe3b9ZCmYKV1xdA9P
	A+MukS5GTg4JAROJy5v+skDYYhIX7q1n62Lk4hASmM4oseznD0YI5y+jxJq9r1i7GDk42ASU
	JRqb9EEahAW0JBZuaQJrFhGIl7i/5zUTSD2zwAZGiQWXZzJBNF9llLg8+xMTSBWnQLDE0b5X
	zBDdoRJ7LvSDxVkEVCW6Z/0Hm8QrYCixa9E5VghbUOLH5HtgcWagbet3HmeCsOUlNq95ywxy
	kISAusSjv7oQRxhJHH85ixGiRERi34t3jBMYhWchmTQLyaRZSCbNQtKygJFlFaNoakFyQXFS
	eq6RXnFibnFpXrpecn7uJkZw6ngmvYNxVYPFIUYBDkYlHt4Nb/mDhFgTy4orcw8xSnAwK4nw
	sqgJBgnxpiRWVqUW5ccXleakFh9iTAZ6dCKzlGhyPjCt5ZXEGxqbmBlZGplZGJmYm5MmrCTO
	e7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDI0PL5o8fjSw4fraX3ryZcvzNywz+s3FZck2mUnNZ
	NrlfOXP8i2/TtNlCUaVBHWahhZ+qQ/tbjwR7nnv3Kju8NGy1ne5y/0pnA/sdbEGt9tlsB3pn
	z9317svmnN4DbcU3TrEE3hHQ2NzgeWdjKBufibHhhYWcJfcvZHS9Zn27e2mX4rrAo+wuSizF
	GYmGWsxFxYkA0DLdxWEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

amit daniel kachhap wrote:
> 
> On Sat, Aug 10, 2013 at 12:13 PM, Viresh Kumar <viresh.kumar@linaro.org>
> wrote:
> > Drivers which have an exit path must call
> cpufreq_frequency_table_put_attr() if
> > they have called cpufreq_frequency_table_get_attr() in their init path.
> >
> > This driver was missing this part and is fixed with this patch.
> >
> > Cc: Kukjin Kim <kgene.kim@samsung.com>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks,
Kukjin

> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> The changes looks fine, please free to add
> Acked-By: Amit Daniel Kachhap <amit.daniel@samsung.com>
> 
> Thanks.
> Amit Daniel
> 
> 
> > ---
> >  drivers/cpufreq/exynos5440-cpufreq.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/drivers/cpufreq/exynos5440-cpufreq.c
> b/drivers/cpufreq/exynos5440-cpufreq.c
> > index 1ac93e0..b9dfc91 100644
> > --- a/drivers/cpufreq/exynos5440-cpufreq.c
> > +++ b/drivers/cpufreq/exynos5440-cpufreq.c
> > @@ -336,12 +336,18 @@ static int exynos_cpufreq_cpu_init(struct
> cpufreq_policy *policy)
> >         return 0;
> >  }
> >
> > +static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
> > +{
> > +       cpufreq_frequency_table_put_attr(policy->cpu);
> > +}
> > +
> >  static struct cpufreq_driver exynos_driver = {
> >         .flags          = CPUFREQ_STICKY,
> >         .verify         = exynos_verify_speed,
> >         .target         = exynos_target,
> >         .get            = exynos_getspeed,
> >         .init           = exynos_cpufreq_cpu_init,
> > +       .exit           = exynos_cpufreq_cpu_exit,
> >         .name           = CPUFREQ_NAME,
> >  };
> >
> > --
> > 1.7.12.rc2.18.g61b472e
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> On Sat, Aug 10, 2013 at 12:13 PM, Viresh Kumar <viresh.kumar@linaro.org>
> wrote:
> > Drivers which have an exit path must call
> cpufreq_frequency_table_put_attr() if
> > they have called cpufreq_frequency_table_get_attr() in their init path.
> >
> > This driver was missing this part and is fixed with this patch.
> >
> > Cc: Kukjin Kim <kgene.kim@samsung.com>
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > ---
> >  drivers/cpufreq/exynos5440-cpufreq.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/drivers/cpufreq/exynos5440-cpufreq.c
> b/drivers/cpufreq/exynos5440-cpufreq.c
> > index 1ac93e0..b9dfc91 100644
> > --- a/drivers/cpufreq/exynos5440-cpufreq.c
> > +++ b/drivers/cpufreq/exynos5440-cpufreq.c
> > @@ -336,12 +336,18 @@ static int exynos_cpufreq_cpu_init(struct
> cpufreq_policy *policy)
> >         return 0;
> >  }
> >
> > +static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
> > +{
> > +       cpufreq_frequency_table_put_attr(policy->cpu);
> > +}
> > +
> >  static struct cpufreq_driver exynos_driver = {
> >         .flags          = CPUFREQ_STICKY,
> >         .verify         = exynos_verify_speed,
> >         .target         = exynos_target,
> >         .get            = exynos_getspeed,
> >         .init           = exynos_cpufreq_cpu_init,
> > +       .exit           = exynos_cpufreq_cpu_exit,
> >         .name           = CPUFREQ_NAME,
> >  };
> >
> > --
> > 1.7.12.rc2.18.g61b472e

