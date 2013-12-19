Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab3LSH5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 02:57:32 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:59662 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab3LSH5a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 02:57:30 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        "Boris BREZILLON" <b.brezillon@overkiz.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <52B01A50.4080209@atmel.com>
Cc: "Fengguang Wu" <fengguang.wu@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1387229127-7605-1-git-send-email-b.brezillon@overkiz.com>
 <52B01A50.4080209@atmel.com>
Message-ID: <20131219075725.18119.80803@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk: at91: fix pmc_clk_ids data type attriubte
Date: Wed, 18 Dec 2013 23:57:25 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Nicolas Ferre (2013-12-17 01:33:04)
> On 16/12/2013 22:25, Boris BREZILLON :
> > Fix pmc_clk_ids data type attribute (__initdata -> __initconst).
> > 
> > Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> > Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> 
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> I take it in at91-3.14-cleanup2 branch and send it upstream through
> arm-soc like any other CCF material for AT91 for the 3.14 release.
> 
> I guess that even without Mike Acked-by, this little fix can follow this
> path.

I can take it into the clk tree if you prefer.

Regards,
Mike

> 
> Bye,
> 
> > ---
> >  drivers/clk/at91/pmc.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
> > index 7b9db60..4c03eda 100644
> > --- a/drivers/clk/at91/pmc.c
> > +++ b/drivers/clk/at91/pmc.c
> > @@ -228,7 +228,7 @@ out_free_pmc:
> >       return NULL;
> >  }
> >  
> > -static const struct of_device_id pmc_clk_ids[] __initdata = {
> > +static const struct of_device_id pmc_clk_ids[] __initconst = {
> >       /* Main clock */
> >       {
> >               .compatible = "atmel,at91rm9200-clk-main",
> > 
> 
> 
> -- 
> Nicolas Ferre
