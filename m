Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaINGgh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 02:36:37 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:64274 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752353AbaINGgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 02:36:33 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+fz3dYzGuplBy7wzCr7vmnuRaUFOvQ0xY=
X-DKIM: OpenDKIM Filter v2.0.1 titan 166F15E14E3
Date: Sun, 14 Sep 2014 02:36:20 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irqchip: atmel-aic5: sama5d3 has 48 IRQs
Message-ID: <20140914063620.GM21986@titan.lakedaemon.net>
References: <1410446511-29477-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410446511-29477-1-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 04:41:51PM +0200, Alexandre Belloni wrote:
> The FUSE and RAM controllers don't have any connected IRQs, reducing the number
> of IRQs to 48.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  drivers/irqchip/irq-atmel-aic5.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to irqchip/atmel with Boris' and Nicolas' Acks.

thx,

Jason.
