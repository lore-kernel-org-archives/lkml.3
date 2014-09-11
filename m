Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbaIKQ1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:27:31 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48301 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757177AbaIKQ1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:27:30 -0400
Date: Thu, 11 Sep 2014 18:27:27 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/7] irqchip: atmel-aic5: Add sama5d4 support
Message-ID: <20140911162727.GA3131@piout.net>
References: <1410450852-1834-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1410450852-1834-2-git-send-email-alexandre.belloni@free-electrons.com>
 <20140911182411.0366ad98@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140911182411.0366ad98@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2014 at 18:24:11 +0200, Thomas Petazzoni wrote :
> Dear Alexandre Belloni,
> 
> On Thu, 11 Sep 2014 17:54:06 +0200, Alexandre Belloni wrote:
> > Add sama5d4 support to irq-atmel-aic5.
> > 
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> > ---
> > Cc: Jason Cooper <jason@lakedaemon.net>
> >  drivers/irqchip/irq-atmel-aic5.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/drivers/irqchip/irq-atmel-aic5.c b/drivers/irqchip/irq-atmel-aic5.c
> > index dc7d98607a89..a11aae8fb006 100644
> > --- a/drivers/irqchip/irq-atmel-aic5.c
> > +++ b/drivers/irqchip/irq-atmel-aic5.c
> > @@ -295,6 +295,7 @@ static void __init sama5d3_aic_irq_fixup(struct device_node *root)
> >  
> >  static const struct of_device_id __initdata aic5_irq_fixups[] = {
> >  	{ .compatible = "atmel,sama5d3", .data = sama5d3_aic_irq_fixup },
> > +	{ .compatible = "atmel,sama5d4", .data = sama5d3_aic_irq_fixup },
> >  	{ /* sentinel */ },
> >  };
> 
> Sorry for the nitpick, but this seems to lack an updated to the DT
> binding documentation, to add the new compatible string.
> 

The Atmel SoC compatibles are not actually documented anywhere, yet...


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
