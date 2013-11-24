Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab3KXRFF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 12:05:05 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:55518 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753052Ab3KXRFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 12:05:02 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+0G68b1BvnBpZ9ZJWhBebGr05HdKfMsnc=
Date: Sun, 24 Nov 2013 12:04:46 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] irqchip: orion: reverse irq handling priority
Message-ID: <20131124170446.GH29241@titan.lakedaemon.net>
References: <1384525354-901-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1384525354-901-2-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384525354-901-2-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 03:22:32PM +0100, Sebastian Hesselbarth wrote:
> Non-DT irq handlers were working through irq causes from most-significant
> to least-significant bit, while DT irqchip driver does it the other way
> round. This revealed some more HW issues on Kirkwood peripheral IP, where
> spurious sdio irqs can happen although IP's irq enable registers are all
> zero. Although, not directly related with the described issue, reverse
> irq bit handling back to original order by replacing ffs() with fls().
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/irqchip/irq-orion.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

Acked-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
