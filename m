Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbaEMPWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:22:50 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:39982 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbaEMPWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:22:44 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/xumLZQJYJBTiS6VFmaSHZW2DHKswRt0A=
X-DKIM: OpenDKIM Filter v2.0.1 titan 37692573EB1
Date: Tue, 13 May 2014 11:22:33 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/7] irqchip: s3c24xx: fix function type for
 IRQCHIP_OF_DECLARE
Message-ID: <20140513152233.GB27822@titan.lakedaemon.net>
References: <1399940993-1773-1-git-send-email-robherring2@gmail.com>
 <1399940993-1773-6-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399940993-1773-6-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob,

On Mon, May 12, 2014 at 07:29:51PM -0500, Rob Herring wrote:
> From: Rob Herring <robh@kernel.org>
> 
> Adding function type checking to IRQCHIP_OF_DECLARE found a type mismatch
> with s3c2410_init_intc_of and s3c2416_init_intc_of. The function only takes
> the 1st 2 parameters.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
>  drivers/irqchip/irq-s3c24xx.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Thomas has asked me to give him a hand with the patches for
drivers/irqchip.  When you add these two to your tree, could you amend
the subject line to conform with the other patches in that directory?

eg (note the capitalization on 'Fix'):

  irqchip: s3c24xx: Fix function type for IRQCHIP_OF_DECLARE
  irqchip: mxs: Fix function type for IRQCHIP_OF_DECLARE

With that change,

Acked-by: Jason Cooper <jason@lakedaemon.net>

Or, if you like, I can apply these two to the branch I'm staging for
Thomas.  Either is fine with me.

thx,

Jason.
