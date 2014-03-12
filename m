Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaCLLfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 07:35:33 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55017 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaCLLfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:35:30 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-55-5320467f1b4a
Message-id: <1394624125.11860.2.camel@AMDC1943>
Subject: Re: [PATCH 1/3] clk: s2mps11: Add support for S2MPS14 clocks
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Tushar Behera <tushar.behera@linaro.org>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Date: Wed, 12 Mar 2014 12:35:25 +0100
In-reply-to: <CAKew6eVEAmxg+fMeeduOwZvxjDdv3Zbu8cNCq7krk5mEq4BKmw@mail.gmail.com>
References: <1394454858-3139-1-git-send-email-k.kozlowski@samsung.com>
 <1394454858-3139-2-git-send-email-k.kozlowski@samsung.com>
 <CAKew6eVEAmxg+fMeeduOwZvxjDdv3Zbu8cNCq7krk5mEq4BKmw@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t/xq7r1bgrBBjO38llsnLGe1eJs0xt2
	i/tfjzJabHp8jdXi8q45bBYzzu9jslh75C67xdMJF9ksTv7pZbQ43c1qcXHFFyaL9TNes1i0
	/93LZjH3dyOrxZzp75gc+D12zrrL7nHn2h42j3knAz02L6n36NuyitHj8ya5ALYoLpuU1JzM
	stQifbsErozvvbUFTywqJuzdyNrAeESti5GTQ0LAROLu5TNMELaYxIV769lAbCGBpYwSB1Yn
	Q9ifGSV69tWD2LwC+hK9cz+wg9jCAq4SezadYgax2QSMJTYvXwLWKyJgIDFxyTzWLkYuDmaB
	flaJVdNnMoIkWARUJRZvewpWxCkQLLFk9kkWiAWnGCUePncGsZkF1CUmzVvEDHGQksTu9k52
	iLi8xOY1b5khjhCU+DH5HssERoFZSFpmISmbhaRsASPzKkbR1NLkguKk9FwjveLE3OLSvHS9
	5PzcTYyQuPm6g3HpMatDjAIcjEo8vDOV5IOFWBPLiitzDzFKcDArifDuslUIFuJNSaysSi3K
	jy8qzUktPsTIxMEp1cA47/r1n0Unjk9adcv8g0XhPfazpk/3lPIGy68sDk8Kff/pXqCOz4aP
	Xr3lnqfn3j38aP7CqRP6D9106dpiH1N+xmFpZOba4HSrve/+z1/PZK0cEZR5+etVsUva+2N7
	lhyXW9GQcca8Sfpg9Gzfqrdfih12JB59kLGG56SF16PpHDP+1U/dfP/3diWW4oxEQy3mouJE
	AHy3Lth5AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-12 at 17:00 +0530, Yadwinder Singh Brar wrote:
> On Mon, Mar 10, 2014 at 6:04 PM, Krzysztof Kozlowski
> <k.kozlowski@samsung.com> wrote:
> > This patch adds support for S2MPS14 PMIC clocks (BT and AP) to the
> > s2mps11 clock driver.
> >
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> 
> Reviewed-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
> 
> Just a trivial thing, Kconfig description can also be updated.

Thanks for review.

I'll update the Kconfig in next version as I want also to change
sec-core driver after Lee's comment.

Best regards,
Krzysztof

> 
> Regards,
> Yadwinder
> 
> >  drivers/clk/clk-s2mps11.c |   61 ++++++++++++++++++++++++++++++++++-----------
> >  1 file changed, 46 insertions(+), 15 deletions(-)
> >
> > diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
> > index 508875535e1e..8dafb552274f 100644
> > --- a/drivers/clk/clk-s2mps11.c
> > +++ b/drivers/clk/clk-s2mps11.c
> > @@ -1,7 +1,7 @@
> >  /*
> >   * clk-s2mps11.c - Clock driver for S2MPS11.
> >   *
> > - * Copyright (C) 2013 Samsung Electornics
> > + * Copyright (C) 2013,2014 Samsung Electornics
> >   *
> >   * This program is free software; you can redistribute  it and/or modify it
> >   * under  the terms of  the GNU General  Public License as published by the
> > @@ -13,10 +13,6 @@
> >   * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >   * GNU General Public License for more details.
> >   *
> > - * You should have received a copy of the GNU General Public License
> > - * along with this program; if not, write to the Free Software
> > - * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> > - *
> >   */
> >
> >  #include <linux/module.h>
> > @@ -27,6 +23,7 @@
> >  #include <linux/clk-provider.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/mfd/samsung/s2mps11.h>
> > +#include <linux/mfd/samsung/s2mps14.h>
> >  #include <linux/mfd/samsung/s5m8767.h>
> >  #include <linux/mfd/samsung/core.h>
> >
> > @@ -125,7 +122,21 @@ static struct clk_init_data s2mps11_clks_init[S2MPS11_CLKS_NUM] = {
> >         },
> >  };
> >
> > -static struct device_node *s2mps11_clk_parse_dt(struct platform_device *pdev)
> > +static struct clk_init_data s2mps14_clks_init[S2MPS11_CLKS_NUM] = {
> > +       [S2MPS11_CLK_AP] = {
> > +               .name = "s2mps14_ap",
> > +               .ops = &s2mps11_clk_ops,
> > +               .flags = CLK_IS_ROOT,
> > +       },
> > +       [S2MPS11_CLK_BT] = {
> > +               .name = "s2mps14_bt",
> > +               .ops = &s2mps11_clk_ops,
> > +               .flags = CLK_IS_ROOT,
> > +       },
> > +};
> > +
> > +static struct device_node *s2mps11_clk_parse_dt(struct platform_device *pdev,
> > +               struct clk_init_data *clks_init)
> >  {
> >         struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
> >         struct device_node *clk_np;
> > @@ -145,9 +156,12 @@ static struct device_node *s2mps11_clk_parse_dt(struct platform_device *pdev)
> >         if (!clk_table)
> >                 return ERR_PTR(-ENOMEM);
> >
> > -       for (i = 0; i < S2MPS11_CLKS_NUM; i++)
> > +       for (i = 0; i < S2MPS11_CLKS_NUM; i++) {
> > +               if (!clks_init[i].name)
> > +                       continue; /* Skip clocks not present in some devices */
> >                 of_property_read_string_index(clk_np, "clock-output-names", i,
> > -                               &s2mps11_clks_init[i].name);
> > +                               &clks_init[i].name);
> > +       }
> >
> >         return clk_np;
> >  }
> > @@ -158,6 +172,7 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
> >         struct s2mps11_clk *s2mps11_clks, *s2mps11_clk;
> >         struct device_node *clk_np = NULL;
> >         unsigned int s2mps11_reg;
> > +       struct clk_init_data *clks_init;
> >         int i, ret = 0;
> >         u32 val;
> >
> > @@ -168,25 +183,33 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
> >
> >         s2mps11_clk = s2mps11_clks;
> >
> > -       clk_np = s2mps11_clk_parse_dt(pdev);
> > -       if (IS_ERR(clk_np))
> > -               return PTR_ERR(clk_np);
> > -
> >         switch (platform_get_device_id(pdev)->driver_data) {
> >         case S2MPS11X:
> >                 s2mps11_reg = S2MPS11_REG_RTC_CTRL;
> > +               clks_init = s2mps11_clks_init;
> > +               break;
> > +       case S2MPS14X:
> > +               s2mps11_reg = S2MPS14_REG_RTCCTRL;
> > +               clks_init = s2mps14_clks_init;
> >                 break;
> >         case S5M8767X:
> >                 s2mps11_reg = S5M8767_REG_CTRL1;
> > +               clks_init = s2mps11_clks_init;
> >                 break;
> >         default:
> >                 dev_err(&pdev->dev, "Invalid device type\n");
> >                 return -EINVAL;
> >         };
> >
> > +       clk_np = s2mps11_clk_parse_dt(pdev, clks_init);
> > +       if (IS_ERR(clk_np))
> > +               return PTR_ERR(clk_np);
> > +
> >         for (i = 0; i < S2MPS11_CLKS_NUM; i++, s2mps11_clk++) {
> > +               if (!clks_init[i].name)
> > +                       continue; /* Skip clocks not present in some devices */
> >                 s2mps11_clk->iodev = iodev;
> > -               s2mps11_clk->hw.init = &s2mps11_clks_init[i];
> > +               s2mps11_clk->hw.init = &clks_init[i];
> >                 s2mps11_clk->mask = 1 << i;
> >                 s2mps11_clk->reg = s2mps11_reg;
> >
> > @@ -220,8 +243,12 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
> >         }
> >
> >         if (clk_table) {
> > -               for (i = 0; i < S2MPS11_CLKS_NUM; i++)
> > +               for (i = 0; i < S2MPS11_CLKS_NUM; i++) {
> > +                       /* Skip clocks not present on S2MPS14 */
> > +                       if (!clks_init[i].name)
> > +                               continue;
> >                         clk_table[i] = s2mps11_clks[i].clk;
> > +               }
> >
> >                 clk_data.clks = clk_table;
> >                 clk_data.clk_num = S2MPS11_CLKS_NUM;
> > @@ -250,14 +277,18 @@ static int s2mps11_clk_remove(struct platform_device *pdev)
> >         struct s2mps11_clk *s2mps11_clks = platform_get_drvdata(pdev);
> >         int i;
> >
> > -       for (i = 0; i < S2MPS11_CLKS_NUM; i++)
> > +       for (i = 0; i < S2MPS11_CLKS_NUM; i++) {
> > +               if (!s2mps11_clks[i].lookup)
> > +                       continue; /* Skip clocks not present in some devices */
> >                 clkdev_drop(s2mps11_clks[i].lookup);
> > +       }
> >
> >         return 0;
> >  }
> >
> >  static const struct platform_device_id s2mps11_clk_id[] = {
> >         { "s2mps11-clk", S2MPS11X},
> > +       { "s2mps14-clk", S2MPS14X},
> >         { "s5m8767-clk", S5M8767X},
> >         { },
> >  };
> > --
> > 1.7.9.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

