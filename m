Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005AbbA0T5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 14:57:41 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:35195 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758666AbbA0T5i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 14:57:38 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Ulf Hansson <ulf.hansson@linaro.org>,
        "Stephen Boyd" <sboyd@codeaurora.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <CAPDyKFrVseR_Mczn5q0pjcMk6SN1HCebWTis4wOfcH+vfEDnRA@mail.gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Linus Walleij" <linus.walleij@linaro.org>
References: <1421955259-8875-1-git-send-email-sboyd@codeaurora.org>
 <CAPDyKFrVseR_Mczn5q0pjcMk6SN1HCebWTis4wOfcH+vfEDnRA@mail.gmail.com>
Message-ID: <20150127195724.22722.97889@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk: ux500: Drop use of clk-private.h
Date: Tue, 27 Jan 2015 11:57:24 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Ulf Hansson (2015-01-22 23:36:28)
> On 22 January 2015 at 20:34, Stephen Boyd <sboyd@codeaurora.org> wrote:
> > These drivers don't need to include clk-private.h. Remove the
> > include.
> >
> > Cc: Ulf Hansson <ulf.hansson@linaro.org>
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
> 
> I suppose you can queue this through your clk tree directly?

Applied.

Regards,
Mike

> 
> Kind regards
> Uffe
> 
> > ---
> >  drivers/clk/ux500/clk-prcc.c  | 1 -
> >  drivers/clk/ux500/clk-prcmu.c | 1 -
> >  2 files changed, 2 deletions(-)
> >
> > diff --git a/drivers/clk/ux500/clk-prcc.c b/drivers/clk/ux500/clk-prcc.c
> > index bd4769a84485..0e950769ed03 100644
> > --- a/drivers/clk/ux500/clk-prcc.c
> > +++ b/drivers/clk/ux500/clk-prcc.c
> > @@ -8,7 +8,6 @@
> >   */
> >
> >  #include <linux/clk-provider.h>
> > -#include <linux/clk-private.h>
> >  #include <linux/slab.h>
> >  #include <linux/io.h>
> >  #include <linux/err.h>
> > diff --git a/drivers/clk/ux500/clk-prcmu.c b/drivers/clk/ux500/clk-prcmu.c
> > index e2d63bc47436..bf63c96acb1a 100644
> > --- a/drivers/clk/ux500/clk-prcmu.c
> > +++ b/drivers/clk/ux500/clk-prcmu.c
> > @@ -8,7 +8,6 @@
> >   */
> >
> >  #include <linux/clk-provider.h>
> > -#include <linux/clk-private.h>
> >  #include <linux/mfd/dbx500-prcmu.h>
> >  #include <linux/slab.h>
> >  #include <linux/io.h>
> > --
> > The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> > a Linux Foundation Collaborative Project
> >
