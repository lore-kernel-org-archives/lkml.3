Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbaKDPzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:55:37 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:40943 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbaKDPze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:55:34 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/3] of/irq: Export of_irq_get()
To: Wolfram Sang <wsa@the-dreams.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>
In-Reply-To: <20141030141644.GE23852@katana>
References: <1414677578-27412-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1414677578-27412-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<20141030141644.GE23852@katana>
Date: Tue, 04 Nov 2014 15:55:27 +0000
Message-Id: <20141104155527.3CF78C423D0@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2014 15:16:44 +0100
, Wolfram Sang <wsa@the-dreams.de>
 wrote:
> On Thu, Oct 30, 2014 at 03:59:36PM +0200, Laurent Pinchart wrote:
> > The function will be used by the I2C core which can be compiled as a
> > module.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> 
> I think it makes sense if I take this via I2C to get the dependencies
> for the later patches right?

Agreed.

Acked-by: Grant Likely <grant.likely@linaro.org>

> 
> > ---
> >  drivers/of/irq.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/of/irq.c b/drivers/of/irq.c
> > index 1471e0a223a5..0d7765807f49 100644
> > --- a/drivers/of/irq.c
> > +++ b/drivers/of/irq.c
> > @@ -405,6 +405,7 @@ int of_irq_get(struct device_node *dev, int index)
> >  
> >  	return irq_create_of_mapping(&oirq);
> >  }
> > +EXPORT_SYMBOL_GPL(of_irq_get);
> >  
> >  /**
> >   * of_irq_get_byname - Decode a node's IRQ and return it as a Linux irq number
> > -- 
> > 2.0.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

