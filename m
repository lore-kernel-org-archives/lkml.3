Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab3IZINs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:13:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51066 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab3IZINo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:13:44 -0400
X-AuditID: cbfee68e-b7f756d000004512-bf-5243ecb66967
From: Jingoo Han <jg1.han@samsung.com>
To: "'Axel Lin'" <axel.lin@ingics.com>
Cc: "'Mark Brown'" <broonie@kernel.org>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
References: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
 <003c01ceba8d$79872c60$6c958520$%han@samsung.com>
 <CAFRkauBTZQzSKgaNg781zsTU4u9V4rYATcWzC=BkJQy07sOBqA@mail.gmail.com>
In-reply-to: <CAFRkauBTZQzSKgaNg781zsTU4u9V4rYATcWzC=BkJQy07sOBqA@mail.gmail.com>
Subject: Re: [PATCH V3 12/14] regulator: tps6524x: use devm_regulator_register()
Date: Thu, 26 Sep 2013 17:13:42 +0900
Message-id: <004101ceba90$50592700$f10b7500$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66j0RXU/Aj0chjTUeD+OaErYQDygAAIfMA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zfd1tb5yDDF5st7E4Mucrs8XUh0/Y
	LC4vvMRq8e1KB5PF5V1z2CxO/ulldGDz2DnrLrtH288yj02rOtk87lzbw+bRt2UVo8fnTXIB
	bFFcNimpOZllqUX6dglcGW+fnWAsWCVcsabhAVMDYxtvFyMnh4SAiUT37AWsELaYxIV769m6
	GLk4hASWMUr0zzjHDFPU/PYKI0RiOqPE2S23wDqEBH4xSnTdBpvEJqAm8eXLYXYQW0RAReJN
	/ysmkAZmgT2MEntmLmSG6N7BKPF87lqWLkYODk6BYIkfsxlBGoQFAiQuLZ4A1swioCrxZn8b
	WAmvgK3EvD3pIGFeAUGJH5PvsYDYzAJaEut3HmeCsOUlNq95ywxSLiGgLvHory7ECUYS3w/t
	Z4coEZHY9+Id2P0SAh/ZJTpnvWaFWCUg8W3yIRaIXlmJTQeg/pWUOLjiBssERolZSDbPQrJ5
	FpLNs5CsWMDIsopRNLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMjJHb7djDePGB9iDEZaP1EZinR
	5Hxg7OeVxBsamxlZmJqYGhuZW5qRJqwkzqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1Oq
	gbE1+sNbo52FjzPP559Jz9bd68r2VKtM5FTMCYfjs0Qi/eZL316RybiF/WN52bpJX/6wqGZM
	m30hyjah+ViK9232N4qLVpulbUhY4f+kSI1rq2Kvl7z/B8mN2k7ek3Le131Or78+IfjdzqWu
	7FfmyE44f2rTXpcotz+bVPM048TMQuon5PBse6/EUpyRaKjFXFScCAA8r/gl8wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jQd1tb5yDDI52WFgcmfOV2WLqwyds
	FpcXXmK1+Halg8ni8q45bBYn//QyOrB57Jx1l92j7WeZx6ZVnWwed67tYfPo27KK0ePzJrkA
	tqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoDOU
	FMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBlvn51gLFglXLGm4QFTA2Mb
	bxcjJ4eEgIlE89srjBC2mMSFe+vZuhi5OIQEpjNKnN1yixUkISTwi1Gi6zZYA5uAmsSXL4fZ
	QWwRARWJN/2vmEAamAX2MErsmbmQGaJ7B6PE87lrWboYOTg4BYIlfswG2yAsECBxafEEsGYW
	AVWJN/vbwEp4BWwl5u1JBwnzCghK/Jh8jwXEZhbQkli/8zgThC0vsXnNW2aQcgkBdYlHf3Uh
	TjCS+H5oPztEiYjEvhfvGCcwCs1CMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FwjveLE3OLS
	vHS95PzcTYzgxPBMegfjqgaLQ4wCHIxKPLwXmJ2DhFgTy4orcw8xSnAwK4nw/ngFFOJNSays
	Si3Kjy8qzUktPsSYDPTnRGYp0eR8YNLKK4k3NDYxM7I0MrMwMjE3J01YSZz3YKt1oJBAemJJ
	anZqakFqEcwWJg5OqQbGfp247z5cXHbrPnt6ana+MOBn/v7HdL8S1wde7xQpf8FdDrk9b869
	mX3TWPWzJ1+086euew/urn3qLngv34nVWm255KmZEyQsn1/O5Xk94fWbHkXv9U/NbqxfX7zv
	wwRhgxe+yirZfE9FNihOerGuKuWO+FNO752GppLF0dFPHO7+Eq/6eH+/EktxRqKhFnNRcSIA
	wHYIalADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 26, 2013 5:06 PM, Axel Lin wrote:
> 2013/9/26 Jingoo Han <jg1.han@samsung.com>:
> > Use devm_regulator_register() to make cleanup paths simpler.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> >  drivers/regulator/tps6524x-regulator.c |    7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/regulator/tps6524x-regulator.c b/drivers/regulator/tps6524x-regulator.c
> > index 8b9ee39..8fe67fb 100644
> > --- a/drivers/regulator/tps6524x-regulator.c
> > +++ b/drivers/regulator/tps6524x-regulator.c
> > @@ -584,10 +584,8 @@ static int pmic_remove(struct spi_device *spi)
> >
> >         if (!hw)
> >                 return 0;
> > -       for (i = 0; i < N_REGULATORS; i++) {
> > -               regulator_unregister(hw->rdev[i]);
> > +       for (i = 0; i < N_REGULATORS; i++)
> >                 hw->rdev[i] = NULL;
> > -       }
> >         return 0;
> >  }
> >
> > @@ -631,7 +629,8 @@ static int pmic_probe(struct spi_device *spi)
> >                 config.init_data = init_data;
> >                 config.driver_data = hw;
> >
> > -               hw->rdev[i] = regulator_register(&hw->desc[i], &config);
> > +               hw->rdev[i] = devm_regulator_register(dev, &hw->desc[i],
> > +                                                     &config);
> >                 if (IS_ERR(hw->rdev[i])) {
> >                         ret = PTR_ERR(hw->rdev[i]);
> >                         hw->rdev[i] = NULL;
> 
> I think you can simply return PTR_ERR(hw->rdev[i]) if devm_regulator_register()
> fails.
> You are using devm_regulator_register now, so don't need to call
> pmic_remove() in probe() error path.
> Then pmic_remove() and .remove = pmic_remove() can be removed as well.
> 

CC'ed Sachin Kamat,

Hi Axel,

I really appreciate your comment.

Then, you mean the following.
If I am wrong, please let me know. :-)
Thank you.

static int pmic_probe(struct spi_device *spi)
{
	......

		hw->rdev[i] = devm_regulator_register(dev, &hw->desc[i],
                                                      &config);
		if (IS_ERR(hw->rdev[i]))
			return PTR_ERR(hw->rdev[i]);
	}

        return 0;
}

static struct spi_driver pmic_driver = {
        .probe          = pmic_probe,
        .driver         = {
                .name   = "tps6524x",
                .owner  = THIS_MODULE,
        },
};

Best regards,
Jingoo Han

