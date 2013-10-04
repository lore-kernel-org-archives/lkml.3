Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab3JDKOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:14:36 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:61814 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab3JDKOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:14:34 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-89-524e94eb046e
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 4/6] thermal: exynos: Replace SOC_ARCH_EXYNOS with
 SOC_ARCH_EXYNOS5250
Date: Fri, 04 Oct 2013 12:13:57 +0200
Message-id: <4865794.YPLcc7kNlS@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <524DEAED.4030905@ti.com>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
 <1380010102-25817-5-git-send-email-l.majewski@samsung.com>
 <524DEAED.4030905@ti.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsVy+t9jQd3XU/yCDPpPcVg0XA2xmH/kHKvF
	mv0/mSw6zz5htnjziNvizcPNjBaXd81hs/jce4TRYsb5fUwWtxtXsFn0L+xlsnjysI/NYv2M
	1ywOvB6L97xk8lg37S2zR9+WVYwejxa3MHocv7GdyePzJrkAtigum5TUnMyy1CJ9uwSujMa9
	R5kKjohW3G+azdrAuFqwi5GTQ0LAROL6m0+MELaYxIV769m6GLk4hASmM0o87rzEBJIQEmhh
	kri1SxHEZhOwkpjYvgqsQURAT+LGiydMIA3MAveYJY4svMrexcjBISwQIzHhTCxIDYuAqsSP
	RwvYQWxeAU2JRxf+sILYogKeEp8mLWUGsTkF1CT2b1vEBLF4PqPE75v/WCAaBCV+TL4HZjML
	yEvs2z+VFcLWkdjfOo1tAqPALCRls5CUzUJStoCReRWjaGpBckFxUnqukV5xYm5xaV66XnJ+
	7iZGcKQ8k97BuKrB4hCjAAejEg/vhmLfICHWxLLiytxDjBIczEoivMcn+QUJ8aYkVlalFuXH
	F5XmpBYfYpTmYFES5z3Yah0oJJCeWJKanZpakFoEk2Xi4JRqYMzcMem48KJmBvXeBZfiq55v
	4pvLadMaJLxmubQ6n+D/3IUC4ZmBf0wiSw8nhEYlcRjK92nKcEged+RmUMgpVTyg+ihJe8bL
	e+WSjNL7fJe/eHhI74PHzg333/xYfID/8bZqTba0mm0i1+dYpNTcqX0sufvMJZHvVoYtB/OV
	aua83NrN6fr7gxJLcUaioRZzUXEiAAt7cyOQAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday, October 03, 2013 06:08:45 PM Eduardo Valentin wrote:
> On 24-09-2013 04:08, Lukasz Majewski wrote:
> > The TMU data definition is now separated to Exynos4412 and Exynos5250.
> > 
> > Now SOC_ARCH_EXYNOS only refers to Exynos5250. Hence the name
> > SOC_ARCH_EXYNOS has been changed to SOC_ARCH_EXYNOS5250.
> > 
> 
> How about merging this one with patch 02?

I would prefer that this is not done since patch #2 is a separate logical
change and it should be kept as a minimal preparatory patch for patch #3
(which is an important bugfix) to make potential backporting of fixes into
-stable etc. easier.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > ---
> >  drivers/thermal/samsung/exynos_tmu.c      |    4 ++--
> >  drivers/thermal/samsung/exynos_tmu.h      |    2 +-
> >  drivers/thermal/samsung/exynos_tmu_data.c |    2 +-
> >  3 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> > index 21b89e4..037cd46 100644
> > --- a/drivers/thermal/samsung/exynos_tmu.c
> > +++ b/drivers/thermal/samsung/exynos_tmu.c
> > @@ -632,9 +632,9 @@ static int exynos_tmu_probe(struct platform_device *pdev)
> >  	if (ret)
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
> > diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
> > index db37df0..b42ece4 100644
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
> > diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
> > index bd08093..188223f 100644
> > --- a/drivers/thermal/samsung/exynos_tmu_data.c
> > +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> > @@ -183,7 +183,7 @@ struct exynos_tmu_init_data const exynos4412_default_tmu_data = {
> >  struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
> >  	.tmu_data = {
> >  		{ EXYNOS4412_TMU_DATA,
> > -		.type = SOC_ARCH_EXYNOS,
> > +		.type = SOC_ARCH_EXYNOS5250,
> >  		},
> >  	},
> >  	.tmu_count = 1,

