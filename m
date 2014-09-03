Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbaICLvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 07:51:09 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:26388 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755341AbaICLvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 07:51:07 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+um8dOqRWNrlxzjyHUETsVeHLvy92mTdg=
X-DKIM: OpenDKIM Filter v2.0.1 titan 42B055D6A5A
Date: Wed, 3 Sep 2014 07:51:00 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, santosh.shilimkar@ti.com,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irqchip: keystone: remove warning unsigned 'kirq->irq'
 is never less than zero
Message-ID: <20140903115100.GH30467@titan.lakedaemon.net>
References: <1406126430-9978-1-git-send-email-grygorii.strashko@ti.com>
 <1409246189-29727-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409246189-29727-1-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 08:16:29PM +0300, Grygorii Strashko wrote:
> Remove static checker warning:
> 
> 	drivers/irqchip/irq-keystone.c:166 keystone_irq_probe()
> 	warn: unsigned 'kirq->irq' is never less than zero.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  drivers/irqchip/irq-keystone.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to irqchip/keystone

thx,

Jason.
