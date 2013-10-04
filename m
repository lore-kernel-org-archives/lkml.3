Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab3JDKYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:24:17 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19766 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3JDKYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:24:14 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-50-524e9739c1d7
Date: Fri, 04 Oct 2013 12:23:30 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 4/6] thermal: exynos: Replace SOC_ARCH_EXYNOS with
 SOC_ARCH_EXYNOS5250
Message-id: <20131004122330.47e21d24@amdc308.digital.local>
In-reply-to: <524DEAED.4030905@ti.com>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
 <1380010102-25817-5-git-send-email-l.majewski@samsung.com>
 <524DEAED.4030905@ti.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+xgK7ldL8gg5YHJhYNV0MsNs5Yz2ox
	/8g5Vos1+38yWXSefcJs8eYRt8XlXXPYLD73HmG0mHF+H5PF7cYVbBb9C3uZLJ487GOzWD/j
	NYsDr8fiPS+ZPNZNe8vs0bdlFaPHo8UtjB7Hb2xn8vi8SS6ALYrLJiU1J7MstUjfLoEr48fW
	24wFD0QqDs0+wtjAeFKgi5GTQ0LAROLcug+sELaYxIV769m6GLk4hAQWMUqcejONCcJpZ5K4
	+eYRC0gVi4CqxL1nlxlBbDYBPYnPd58ygdgiQPaNF0/AbGaBN8wSq1d4dTFycAgLxEhMOBML
	EuYVsJa4fuI4O4jNKaAmsX/bIqj58xklft/8BzafX0BSov3fD2aIi+wkzn3awA7RLCjxY/I9
	Foj5WhKbtzWxQtjyEpvXvGWewCg4C0nZLCRls5CULWBkXsUomlqQXFCclJ5rpFecmFtcmpeu
	l5yfu4kRHEHPpHcwrmqwOMQowMGoxMO7odg3SIg1say4MvcQowQHs5II7/FJfkFCvCmJlVWp
	RfnxRaU5qcWHGKU5WJTEeQ+2WgcKCaQnlqRmp6YWpBbBZJk4OKUaGDu8ZM88dNrIWvAmwWr/
	Nqf+u7c7pq5d7ctnZsQ6sWpbR2gK390DPgyn4r82rHB+F/El7/czhor6j85lRls1FpUtjT1t
	/+1bxfsLFRNyo17OY9qecSs85sSFlK0CK3RdDLcFzpK5r8A7Xaxp7f5Uw/LT9X6fxdyc910r
	W9NRetoh3l7i+tVl15RYijMSDbWYi4oTAWsWMZecAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

> On 24-09-2013 04:08, Lukasz Majewski wrote:
> > The TMU data definition is now separated to Exynos4412 and
> > Exynos5250.
> > 
> > Now SOC_ARCH_EXYNOS only refers to Exynos5250. Hence the name
> > SOC_ARCH_EXYNOS has been changed to SOC_ARCH_EXYNOS5250.
> > 
> 
> How about merging this one with patch 02?

I wanted to show how the work was logically split - patch 02
extracts Exynos4412 from Exynos5250. Then this patch changes the name.

I will merge those two patches. No problem.

> 
> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > ---
> >  drivers/thermal/samsung/exynos_tmu.c      |    4 ++--
> >  drivers/thermal/samsung/exynos_tmu.h      |    2 +-
> >  drivers/thermal/samsung/exynos_tmu_data.c |    2 +-
> >  3 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/thermal/samsung/exynos_tmu.c
> > b/drivers/thermal/samsung/exynos_tmu.c index 21b89e4..037cd46 100644
> > --- a/drivers/thermal/samsung/exynos_tmu.c
> > +++ b/drivers/thermal/samsung/exynos_tmu.c
> > @@ -632,9 +632,9 @@ static int exynos_tmu_probe(struct
> > platform_device *pdev) if (ret)
> >  		return ret;
> >  
> > -	if (pdata->type == SOC_ARCH_EXYNOS ||
> > -	    pdata->type == SOC_ARCH_EXYNOS4210 ||
> > +	if (pdata->type == SOC_ARCH_EXYNOS4210 ||
> >  	    pdata->type == SOC_ARCH_EXYNOS4412 ||
> > +	    pdata->type == SOC_ARCH_EXYNOS5250 ||
> >  	    pdata->type == SOC_ARCH_EXYNOS5440)
> >  		data->soc = pdata->type;
> >  	else {
> > diff --git a/drivers/thermal/samsung/exynos_tmu.h
> > b/drivers/thermal/samsung/exynos_tmu.h index db37df0..b42ece4 100644
> > --- a/drivers/thermal/samsung/exynos_tmu.h
> > +++ b/drivers/thermal/samsung/exynos_tmu.h
> > @@ -42,7 +42,7 @@ enum calibration_mode {
> >  enum soc_type {
> >  	SOC_ARCH_EXYNOS4210 = 1,
> >  	SOC_ARCH_EXYNOS4412,
> > -	SOC_ARCH_EXYNOS,
> > +	SOC_ARCH_EXYNOS5250,
> >  	SOC_ARCH_EXYNOS5440,
> >  };
> >  
> > diff --git a/drivers/thermal/samsung/exynos_tmu_data.c
> > b/drivers/thermal/samsung/exynos_tmu_data.c index bd08093..188223f
> > 100644 --- a/drivers/thermal/samsung/exynos_tmu_data.c
> > +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> > @@ -183,7 +183,7 @@ struct exynos_tmu_init_data const
> > exynos4412_default_tmu_data = { struct exynos_tmu_init_data const
> > exynos5250_default_tmu_data = { .tmu_data = {
> >  		{ EXYNOS4412_TMU_DATA,
> > -		.type = SOC_ARCH_EXYNOS,
> > +		.type = SOC_ARCH_EXYNOS5250,
> >  		},
> >  	},
> >  	.tmu_count = 1,
> > 
> 
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
