Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934099AbaJ3ORM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:17:12 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:50741 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934023AbaJ3ORL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:17:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH 1/3] of/irq: Export of_irq_get()
Date: Thu, 30 Oct 2014 16:17:19 +0200
Message-ID: <2139081.L8ZrMAojpq@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <20141030141644.GE23852@katana>
References: <1414677578-27412-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1414677578-27412-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <20141030141644.GE23852@katana>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 October 2014 15:16:44 Wolfram Sang wrote:
> On Thu, Oct 30, 2014 at 03:59:36PM +0200, Laurent Pinchart wrote:
> > The function will be used by the I2C core which can be compiled as a
> > module.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> 
> I think it makes sense if I take this via I2C to get the dependencies
> for the later patches right?

It would be easier, yes.

> > ---
> > 
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
> >  
> >  }
> > 
> > +EXPORT_SYMBOL_GPL(of_irq_get);
> > 
> >  /**
> >  
> >   * of_irq_get_byname - Decode a node's IRQ and return it as a Linux irq
> >   number

-- 
Regards,

Laurent Pinchart

