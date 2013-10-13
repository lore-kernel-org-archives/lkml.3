Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab3JMHUR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 03:20:17 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:35193 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab3JMHUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 03:20:15 -0400
Date: Sun, 13 Oct 2013 09:20:03 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: tglx@linutronix.de, juhosg@openwrt.org, srivatsa.bhat@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] avr32: remove deprecated IRQF_DISABLED
Message-ID: <20131013072003.GA11195@samfundet.no>
References: <1381550641-5894-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381550641-5894-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Sat 12 Oct 2013 06:04:01 +0200 or thereabout, Michael Opdenacker wrote:
> This patch proposes to remove the use of the IRQF_DISABLED flag
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Thank you for cleaning (-:

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/kernel/time.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/avr32/kernel/time.c b/arch/avr32/kernel/time.c
> index 12f828a..d0f771b 100644
> --- a/arch/avr32/kernel/time.c
> +++ b/arch/avr32/kernel/time.c
> @@ -59,7 +59,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
>  static struct irqaction timer_irqaction = {
>  	.handler	= timer_interrupt,
>  	/* Oprofile uses the same irq as the timer, so allow it to be shared */
> -	.flags		= IRQF_TIMER | IRQF_DISABLED | IRQF_SHARED,
> +	.flags		= IRQF_TIMER | IRQF_SHARED,
>  	.name		= "avr32_comparator",
>  };
>  
-- 
mvh
Hans-Christian Egtvedt
