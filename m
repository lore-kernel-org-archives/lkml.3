Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726Ab3CSUQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:16:51 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:34780 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166Ab3CSUQu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:16:50 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Shawn Guo <shawn.guo@linaro.org>, Fabio Estevam <festevam@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20130217080219.GF15048@S2101-09.ap.freescale.net>
Cc: <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
References: <1360591636-10575-1-git-send-email-festevam@gmail.com>
 <20130217080219.GF15048@S2101-09.ap.freescale.net>
Message-ID: <20130319201028.8663.21942@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH] clk: mxs: Fix sparse warnings
Date: Tue, 19 Mar 2013 13:10:28 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Shawn Guo (2013-02-17 00:02:20)
> On Mon, Feb 11, 2013 at 12:07:16PM -0200, Fabio Estevam wrote:
> > From: Fabio Estevam <fabio.estevam@freescale.com>
> > 
> > Fix the following sparse warnings:
> > 
> > drivers/clk/mxs/clk.c:17:1: warning: symbol 'mxs_lock' was not declared. Should it be static?
> > drivers/clk/mxs/clk.c:19:5: warning: symbol 'mxs_clk_wait' was not declared. Should it be static?
> > 
> > Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Acked-by: Shawn Guo <shawn.guo@linaro.org>
> 

Taken into clk-next.

Thanks,
Mike

> > ---
> >  drivers/clk/mxs/clk.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/clk/mxs/clk.c b/drivers/clk/mxs/clk.c
> > index b24d560..5301bce 100644
> > --- a/drivers/clk/mxs/clk.c
> > +++ b/drivers/clk/mxs/clk.c
> > @@ -13,6 +13,7 @@
> >  #include <linux/io.h>
> >  #include <linux/jiffies.h>
> >  #include <linux/spinlock.h>
> > +#include "clk.h"
> >  
> >  DEFINE_SPINLOCK(mxs_lock);
> >  
> > -- 
> > 1.7.9.5
> >
