Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936268Ab3DQCND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 22:13:03 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:50438
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936218Ab3DQCNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 22:13:00 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zzc89bh936eIc3f2I148cI542I1432I4015Ic8kzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bh8275dh84d07hz2dh2a8h668h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ahbe9i1155h)
From: Tang Yuantian-B29983 <B29983@freescale.com>
To: Mike Turquette <mturquette@linaro.org>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Li Yang-R58472 <r58472@freescale.com>
Subject: RE: RE: [PATCH v3] clk: add PowerPC corenet clock driver support
Thread-Topic: RE: [PATCH v3] clk: add PowerPC corenet clock driver support
Thread-Index: AQHONQQh3JUKy8HMv0irmwrkXWgM65jYdZMAgAEDg4CAAD75sA==
Date: Wed, 17 Apr 2013 02:12:56 +0000
Message-ID: <D07C73A334FF604B95B3CBD2A545D07B0B145614@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1365497187-8305-1-git-send-email-Yuantian.Tang@freescale.com>
 <D07C73A334FF604B95B3CBD2A545D07B0B144FEF@039-SN2MPN1-013.039d.mgd.msft.net>
 <20130416222721.19887.3395@quantum>
In-Reply-To: <20130416222721.19887.3395@quantum>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.128]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3H2DUFT006637

OK, thanks.

Thanks,
Yuantian


> -----Original Message-----
> From: Mike Turquette [mailto:mturquette@linaro.org]
> Sent: 2013å¹´4æœˆ17æ—¥ 6:27
> To: Tang Yuantian-B29983; Tang Yuantian-B29983
> Cc: linus.walleij@linaro.org; viresh.kumar@linaro.org;
> shawn.guo@linaro.org; ulf.hansson@linaro.org; linux-
> kernel@vger.kernel.org; devicetree-discuss@lists.ozlabs.org; linuxppc-
> dev@lists.ozlabs.org; linux-doc@vger.kernel.org; Li Yang-R58472
> Subject: Re: RE: [PATCH v3] clk: add PowerPC corenet clock driver support
> 
> Quoting Tang Yuantian-B29983 (2013-04-15 23:59:34)
> > Hi Mike,
> >
> > I really appreciate if you can spend some times to review this patch.
> >
> 
> Yauntian,
> 
> Thanks for submitting this patch.  I have frozen the changes I plan to
> submit for 3.10, with the exception of any last-minute fixes.  I'll take
> a closer look at this after the merge window.
> 
> Regards,
> Mike
> 
> > Thanks,
> > Yuantian
> >
> >
> > > -----Original Message-----
> > > From: Tang Yuantian-B29983
> > > Sent: 2013å¹´4æœˆ9æ—¥ 16:46
> > > To: mturquette@linaro.org
> > > Cc: linus.walleij@linaro.org; viresh.kumar@linaro.org;
> > > shawn.guo@linaro.org; ulf.hansson@linaro.org; linux-
> > > kernel@vger.kernel.org; devicetree-discuss@lists.ozlabs.org;
> > > linuxppc- dev@lists.ozlabs.org; linux-doc@vger.kernel.org; Tang
> > > Yuantian-B29983; Tang Yuantian-B29983; Li Yang-R58472
> > > Subject: [PATCH v3] clk: add PowerPC corenet clock driver support
> > >
> > > From: Tang Yuantian <yuantian.tang@freescale.com>
> > >
> > > This adds the clock driver for Freescale PowerPC corenet series SoCs
> > > using common clock infrastructure.
> > >
> > > Signed-off-by: Tang Yuantian <Yuantian.Tang@freescale.com>
> > > Signed-off-by: Li Yang <leoli@freescale.com>
> > > ---
> > > v3:
> > >       - remove the module author and description
> > > v2:
> > >       - add the document for device tree clock bindings
> > >
> > >  arch/powerpc/platforms/Kconfig.cputype |   1 +
> > >  drivers/clk/Kconfig                    |   7 +
> > >  drivers/clk/Makefile                   |   1 +
> > >  drivers/clk/clk-ppc-corenet.c          | 280
> > > +++++++++++++++++++++++++++++++++
> > >  4 files changed, 289 insertions(+)
> > >  create mode 100644 drivers/clk/clk-ppc-corenet.c
> > >
> > > diff --git a/arch/powerpc/platforms/Kconfig.cputype
> > > b/arch/powerpc/platforms/Kconfig.cputype
> > > index 18e3b76..cf065b8 100644
> > > --- a/arch/powerpc/platforms/Kconfig.cputype
> > > +++ b/arch/powerpc/platforms/Kconfig.cputype
> > > @@ -158,6 +158,7 @@ config E500
> > >  config PPC_E500MC
> > >       bool "e500mc Support"
> > >       select PPC_FPU
> > > +     select COMMON_CLK
> > >       depends on E500
> > >       help
> > >         This must be enabled for running on e500mc (and derivatives
> > > diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig index
> > > a47e6ee..6e2fd9c
> > > 100644
> > > --- a/drivers/clk/Kconfig
> > > +++ b/drivers/clk/Kconfig
> > > @@ -63,6 +63,13 @@ config CLK_TWL6040
> > >         McPDM. McPDM module is using the external bit clock on the
> > > McPDM bus
> > >         as functional clock.
> > >
> > > +config CLK_PPC_CORENET
> > > +     bool "Clock driver for PowerPC corenet platforms"
> > > +     depends on PPC_E500MC && OF
> > > +     ---help---
> > > +       This adds the clock driver support for Freescale PowerPC
> corenet
> > > +       platforms using common clock framework.
> > > +
> > >  endmenu
> > >
> > >  source "drivers/clk/mvebu/Kconfig"
> > > diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile index
> > > 300d477..6720319 100644
> > > --- a/drivers/clk/Makefile
> > > +++ b/drivers/clk/Makefile
> > > @@ -34,3 +34,4 @@ obj-$(CONFIG_X86)           += x86/
> > >  obj-$(CONFIG_COMMON_CLK_WM831X) += clk-wm831x.o
> > >  obj-$(CONFIG_COMMON_CLK_MAX77686) += clk-max77686.o
> > >  obj-$(CONFIG_CLK_TWL6040)    += clk-twl6040.o
> > > +obj-$(CONFIG_CLK_PPC_CORENET)        += clk-ppc-corenet.o
> > > diff --git a/drivers/clk/clk-ppc-corenet.c b/drivers/clk/clk-ppc-
> > > corenet.c new file mode 100644 index 0000000..a2d483f
> > > --- /dev/null
> > > +++ b/drivers/clk/clk-ppc-corenet.c
> > > @@ -0,0 +1,280 @@
> > > +/*
> > > + * Copyright 2013 Freescale Semiconductor, Inc.
> > > + *
> > > + * This program is free software; you can redistribute it and/or
> > > +modify
> > > + * it under the terms of the GNU General Public License version 2
> > > +as
> > > + * published by the Free Software Foundation.
> > > + *
> > > + * clock driver for Freescale PowerPC corenet SoCs.
> > > + */
> > > +#include <linux/clk-provider.h>
> > > +#include <linux/io.h>
> > > +#include <linux/kernel.h>
> > > +#include <linux/module.h>
> > > +#include <linux/of_platform.h>
> > > +#include <linux/of.h>
> > > +#include <linux/slab.h>
> > > +
> > > +struct cmux_clk {
> > > +     struct clk_hw hw;
> > > +     void __iomem *reg;
> > > +     u32 flags;
> > > +};
> > > +
> > > +#define PLL_KILL                     BIT(31)
> > > +#define      CLKSEL_SHIFT            27
> > > +#define CLKSEL_ADJUST                BIT(0)
> > > +#define to_cmux_clk(p)               container_of(p, struct cmux_clk,
> hw)
> > > +
> > > +static void __iomem *base;
> > > +static unsigned int clocks_per_pll;
> > > +
> > > +static int cmux_set_parent(struct clk_hw *hw, u8 idx) {
> > > +     struct cmux_clk *clk = to_cmux_clk(hw);
> > > +     u32 clksel;
> > > +
> > > +     clksel = ((idx / clocks_per_pll) << 2) + idx % clocks_per_pll;
> > > +     if (clk->flags & CLKSEL_ADJUST)
> > > +             clksel += 8;
> > > +     clksel = (clksel & 0xf) << CLKSEL_SHIFT;
> > > +     iowrite32be(clksel, clk->reg);
> > > +
> > > +     return 0;
> > > +}
> > > +
> > > +static u8 cmux_get_parent(struct clk_hw *hw) {
> > > +     struct cmux_clk *clk = to_cmux_clk(hw);
> > > +     u32 clksel;
> > > +
> > > +     clksel = ioread32be(clk->reg);
> > > +     clksel = (clksel >> CLKSEL_SHIFT) & 0xf;
> > > +     if (clk->flags & CLKSEL_ADJUST)
> > > +             clksel -= 8;
> > > +     clksel = (clksel >> 2) * clocks_per_pll + clksel % 4;
> > > +
> > > +     return clksel;
> > > +}
> > > +
> > > +const struct clk_ops cmux_ops = {
> > > +     .get_parent = cmux_get_parent,
> > > +     .set_parent = cmux_set_parent, };
> > > +
> > > +static void __init core_mux_init(struct device_node *np) {
> > > +     struct clk *clk;
> > > +     struct clk_init_data init;
> > > +     struct cmux_clk *cmux_clk;
> > > +     struct device_node *node;
> > > +     int rc, count, i;
> > > +     u32     offset;
> > > +     const char *clk_name;
> > > +     const char **parent_names;
> > > +
> > > +     rc = of_property_read_u32(np, "reg", &offset);
> > > +     if (rc) {
> > > +             pr_err("%s: could not get reg property\n", np->name);
> > > +             return;
> > > +     }
> > > +
> > > +     /* get the input clock source count */
> > > +     count = of_property_count_strings(np, "clock-names");
> > > +     if (count < 0) {
> > > +             pr_err("%s: get clock count error\n", np->name);
> > > +             return;
> > > +     }
> > > +     parent_names = kzalloc((sizeof(char *) * count), GFP_KERNEL);
> > > +     if (!parent_names) {
> > > +             pr_err("%s: could not allocate parent_names\n",
> __func__);
> > > +             return;
> > > +     }
> > > +
> > > +     for (i = 0; i < count; i++)
> > > +             parent_names[i] = of_clk_get_parent_name(np, i);
> > > +
> > > +     cmux_clk = kzalloc(sizeof(struct cmux_clk), GFP_KERNEL);
> > > +     if (!cmux_clk) {
> > > +             pr_err("%s: could not allocate cmux_clk\n", __func__);
> > > +             goto err_name;
> > > +     }
> > > +     cmux_clk->reg = base + offset;
> > > +
> > > +     node = of_find_compatible_node(NULL, NULL, "fsl,p4080-
> clockgen");
> > > +     if (node && (offset >= 0x80))
> > > +             cmux_clk->flags = CLKSEL_ADJUST;
> > > +
> > > +     rc = of_property_read_string_index(np, "clock-output-names",
> > > +                     0, &clk_name);
> > > +     if (rc) {
> > > +             pr_err("%s: read clock names error\n", np->name);
> > > +             goto err_clk;
> > > +     }
> > > +
> > > +     init.name = clk_name;
> > > +     init.ops = &cmux_ops;
> > > +     init.parent_names = parent_names;
> > > +     init.num_parents = count;
> > > +     init.flags = 0;
> > > +     cmux_clk->hw.init = &init;
> > > +
> > > +     clk = clk_register(NULL, &cmux_clk->hw);
> > > +     if (IS_ERR(clk)) {
> > > +             pr_err("%s: could not register clock\n", clk_name);
> > > +             goto err_clk;
> > > +     }
> > > +
> > > +     rc = of_clk_add_provider(np, of_clk_src_simple_get, clk);
> > > +     if (rc) {
> > > +             pr_err("Could not register clock provider for
> node:%s\n",
> > > +                      np->name);
> > > +             goto err_clk;
> > > +     }
> > > +     goto err_name;
> > > +
> > > +err_clk:
> > > +     kfree(cmux_clk);
> > > +err_name:
> > > +     /* free *_names because they are reallocated when registered */
> > > +     kfree(parent_names);
> > > +}
> > > +
> > > +static void __init core_pll_init(struct device_node *np) {
> > > +     u32 offset, mult;
> > > +     int i, rc, count;
> > > +     const char *clk_name, *parent_name;
> > > +     struct clk_onecell_data *onecell_data;
> > > +     struct clk      **subclks;
> > > +
> > > +     rc = of_property_read_u32(np, "reg", &offset);
> > > +     if (rc) {
> > > +             pr_err("%s: could not get reg property\n", np->name);
> > > +             return;
> > > +     }
> > > +
> > > +     /* get the multiple of PLL */
> > > +     mult = ioread32be(base + offset);
> > > +
> > > +     /* check if this PLL is disabled */
> > > +     if (mult & PLL_KILL) {
> > > +             pr_debug("PLL:%s is disabled\n", np->name);
> > > +             return;
> > > +     }
> > > +     mult = (mult >> 1) & 0x3f;
> > > +
> > > +     parent_name = of_clk_get_parent_name(np, 0);
> > > +     if (!parent_name) {
> > > +             pr_err("PLL: %s must have a parent\n", np->name);
> > > +             return;
> > > +     }
> > > +
> > > +     count = of_property_count_strings(np, "clock-output-names");
> > > +     if (count < 0 || count > 4) {
> > > +             pr_err("%s: clock is not supported\n", np->name);
> > > +             return;
> > > +     }
> > > +
> > > +     /* output clock number per PLL */
> > > +     clocks_per_pll = count;
> > > +
> > > +     subclks = kzalloc(sizeof(struct clk *) * count, GFP_KERNEL);
> > > +     if (!subclks) {
> > > +             pr_err("%s: could not allocate subclks\n", __func__);
> > > +             return;
> > > +     }
> > > +
> > > +     onecell_data = kzalloc(sizeof(struct clk_onecell_data),
> GFP_KERNEL);
> > > +     if (!onecell_data) {
> > > +             pr_err("%s: could not allocate onecell_data\n",
> __func__);
> > > +             goto err_clks;
> > > +     }
> > > +
> > > +     for (i = 0; i < count; i++) {
> > > +             rc = of_property_read_string_index(np, "clock-output-
> names",
> > > +                             i, &clk_name);
> > > +             if (rc) {
> > > +                     pr_err("%s: could not get clock names\n", np-
> >name);
> > > +                     goto err_cell;
> > > +             }
> > > +
> > > +             /*
> > > +              * when count == 4, there are 4 output clocks:
> > > +              * /1, /2, /3, /4 respectively
> > > +              * when count < 4, there are at least 2 output clocks:
> > > +              * /1, /2, (/4, if count == 3) respectively.
> > > +              */
> > > +             if (count == 4)
> > > +                     subclks[i] = clk_register_fixed_factor(NULL,
> clk_name,
> > > +                                     parent_name, 0, mult, 1 + i);
> > > +             else
> > > +
> > > +                     subclks[i] = clk_register_fixed_factor(NULL,
> clk_name,
> > > +                                     parent_name, 0, mult, 1 << i);
> > > +
> > > +             if (IS_ERR(subclks[i])) {
> > > +                     pr_err("%s: could not register clock\n",
> clk_name);
> > > +                     goto err_cell;
> > > +             }
> > > +     }
> > > +
> > > +     onecell_data->clks = subclks;
> > > +     onecell_data->clk_num = count;
> > > +
> > > +     rc = of_clk_add_provider(np, of_clk_src_onecell_get,
> onecell_data);
> > > +     if (rc) {
> > > +             pr_err("Could not register clk provider for node:%s\n",
> > > +                      np->name);
> > > +             goto err_cell;
> > > +     }
> > > +
> > > +     return;
> > > +err_cell:
> > > +     kfree(onecell_data);
> > > +err_clks:
> > > +     kfree(subclks);
> > > +}
> > > +
> > > +static const struct of_device_id clk_match[] __initconst = {
> > > +     { .compatible = "fixed-clock", .data = of_fixed_clk_setup, },
> > > +     { .compatible = "fsl,core-pll-clock", .data = core_pll_init, },
> > > +     { .compatible = "fsl,core-mux-clock", .data = core_mux_init, },
> > > +     {}
> > > +};
> > > +
> > > +static int __init ppc_corenet_clk_probe(struct platform_device *pdev)
> {
> > > +     struct device_node *np;
> > > +
> > > +     np = pdev->dev.of_node;
> > > +     base = of_iomap(np, 0);
> > > +     if (!base) {
> > > +             dev_err(&pdev->dev, "iomap error\n");
> > > +             return -ENOMEM;
> > > +     }
> > > +     of_clk_init(clk_match);
> > > +
> > > +     return 0;
> > > +}
> > > +
> > > +static const struct of_device_id ppc_clk_ids[] __initconst = {
> > > +     { .compatible = "fsl,qoriq-clockgen-1.0", },
> > > +     { .compatible = "fsl,qoriq-clockgen-2", },
> > > +     {}
> > > +};
> > > +
> > > +static struct platform_driver ppc_corenet_clk_driver = {
> > > +     .driver = {
> > > +             .name = "ppc_corenet_clock",
> > > +             .owner = THIS_MODULE,
> > > +             .of_match_table = ppc_clk_ids,
> > > +     },
> > > +     .probe = ppc_corenet_clk_probe, };
> > > +
> > > +static int __init ppc_corenet_clk_init(void) {
> > > +     return platform_driver_register(&ppc_corenet_clk_driver);
> > > +}
> > > +subsys_initcall(ppc_corenet_clk_init);
> > > --
> > > 1.8.0

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
