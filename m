Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab3JDKsD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:48:03 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64748 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab3JDKsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:48:00 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-fd-524e9cbf2c3e
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>,
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
Date: Fri, 04 Oct 2013 12:47:19 +0200
Message-id: <2265935.YcHunKd7UC@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <20131004122330.47e21d24@amdc308.digital.local>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
 <524DEAED.4030905@ti.com> <20131004122330.47e21d24@amdc308.digital.local>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=US-ASCII
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsVy+t9jQd39c/yCDObdkLFouBpiMf/IOVaL
	Nft/Mll0nn3CbPHmEbfFm4ebGS0u75rDZvG59wijxYzz+5gsbjeuYLPoX9jLZPHkYR+bxfoZ
	r1kceD0W73nJ5LFu2ltmj74tqxg9Hi1uYfQ4fmM7k8fnTXIBbFFcNimpOZllqUX6dglcGbt2
	zmAt+CZW8ae1k62BcaJQFyMnh4SAicTdx1OZIGwxiQv31rN1MXJxCAlMZ5ToPNDECpIQEmhh
	kujbXQJiswlYSUxsX8UIYosI6Ehc+NjADNLALPCIWWJ5z0agbg4OYYEYiQlnYkFqWARUJabd
	u84CYvMKaEr0LDnHDmKLCnhKfJq0lBnE5hSwkdjasZYVYvEkRomJs3+yQTQISvyYfA+smVlA
	XmLf/qmsELaWxOZtTawTGAVmISmbhaRsFpKyBYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNz
	NzGCI+WZ1A7GlQ0WhxgFOBiVeHgFan2DhFgTy4orcw8xSnAwK4nwHp/kFyTEm5JYWZValB9f
	VJqTWnyIUZqDRUmc90CrdaCQQHpiSWp2ampBahFMlomDU6qBUXP1ItZZgpF8HL+UxGod7M7d
	2pp7UmYGu+KD63eXl/5aKT3v7Y6ElI+pN/Na3aWU7W65eFb1xgd5Xv7O++ZEw3XzeVK1/24K
	rv1a9zNyXSLf1ePPkrJStIQWP26OUQmpY3Br4eOROaG4TnzZ8ftqrbq7Kzi/eVbE189PuHjf
	NCnlWkDoB/upSizFGYmGWsxFxYkAHWzZMpACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 04, 2013 12:23:30 PM Lukasz Majewski wrote:
> Hi Eduardo,
> 
> > On 24-09-2013 04:08, Lukasz Majewski wrote:
> > > The TMU data definition is now separated to Exynos4412 and
> > > Exynos5250.
> > > 
> > > Now SOC_ARCH_EXYNOS only refers to Exynos5250. Hence the name
> > > SOC_ARCH_EXYNOS has been changed to SOC_ARCH_EXYNOS5250.
> > > 
> > 
> > How about merging this one with patch 02?
> 
> I wanted to show how the work was logically split - patch 02
> extracts Exynos4412 from Exynos5250. Then this patch changes the name.
> 
> I will merge those two patches. No problem.

Oh, well. Looking at the patch #2 again the merge can be done without
sacrificing backportability.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> > 
> > > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > > ---
> > >  drivers/thermal/samsung/exynos_tmu.c      |    4 ++--
> > >  drivers/thermal/samsung/exynos_tmu.h      |    2 +-
> > >  drivers/thermal/samsung/exynos_tmu_data.c |    2 +-
> > >  3 files changed, 4 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/thermal/samsung/exynos_tmu.c
> > > b/drivers/thermal/samsung/exynos_tmu.c index 21b89e4..037cd46 100644
> > > --- a/drivers/thermal/samsung/exynos_tmu.c
> > > +++ b/drivers/thermal/samsung/exynos_tmu.c
> > > @@ -632,9 +632,9 @@ static int exynos_tmu_probe(struct
> > > platform_device *pdev) if (ret)
> > >  		return ret;
> > >  
> > > -	if (pdata->type == SOC_ARCH_EXYNOS ||
> > > -	    pdata->type == SOC_ARCH_EXYNOS4210 ||
> > > +	if (pdata->type == SOC_ARCH_EXYNOS4210 ||
> > >  	    pdata->type == SOC_ARCH_EXYNOS4412 ||
> > > +	    pdata->type == SOC_ARCH_EXYNOS5250 ||
> > >  	    pdata->type == SOC_ARCH_EXYNOS5440)
> > >  		data->soc = pdata->type;
> > >  	else {
> > > diff --git a/drivers/thermal/samsung/exynos_tmu.h
> > > b/drivers/thermal/samsung/exynos_tmu.h index db37df0..b42ece4 100644
> > > --- a/drivers/thermal/samsung/exynos_tmu.h
> > > +++ b/drivers/thermal/samsung/exynos_tmu.h
> > > @@ -42,7 +42,7 @@ enum calibration_mode {
> > >  enum soc_type {
> > >  	SOC_ARCH_EXYNOS4210 = 1,
> > >  	SOC_ARCH_EXYNOS4412,
> > > -	SOC_ARCH_EXYNOS,
> > > +	SOC_ARCH_EXYNOS5250,
> > >  	SOC_ARCH_EXYNOS5440,
> > >  };
> > >  
> > > diff --git a/drivers/thermal/samsung/exynos_tmu_data.c
> > > b/drivers/thermal/samsung/exynos_tmu_data.c index bd08093..188223f
> > > 100644 --- a/drivers/thermal/samsung/exynos_tmu_data.c
> > > +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> > > @@ -183,7 +183,7 @@ struct exynos_tmu_init_data const
> > > exynos4412_default_tmu_data = { struct exynos_tmu_init_data const
> > > exynos5250_default_tmu_data = { .tmu_data = {
> > >  		{ EXYNOS4412_TMU_DATA,
> > > -		.type = SOC_ARCH_EXYNOS,
> > > +		.type = SOC_ARCH_EXYNOS5250,
> > >  		},
> > >  	},
> > >  	.tmu_count = 1,

