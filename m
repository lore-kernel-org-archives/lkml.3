Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab3JMXpq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 19:45:46 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41010 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab3JMXpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 19:45:45 -0400
Date: Mon, 14 Oct 2013 00:45:07 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: timer-sp: remove deprecated IRQF_DISABLED
Message-ID: <20131013234507.GH25034@n2100.arm.linux.org.uk>
References: <1381546322-4632-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381546322-4632-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you want to either send these to the patch system, or alternatively
collect them up in a git tree somewhere for me and/or arm-soc to pull...

On Sat, Oct 12, 2013 at 04:52:02AM +0200, Michael Opdenacker wrote:
> This patch proposes to remove the use of the IRQF_DISABLED flag
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  arch/arm/common/timer-sp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/common/timer-sp.c b/arch/arm/common/timer-sp.c
> index e901d0f..ce922d0 100644
> --- a/arch/arm/common/timer-sp.c
> +++ b/arch/arm/common/timer-sp.c
> @@ -175,7 +175,7 @@ static struct clock_event_device sp804_clockevent = {
>  
>  static struct irqaction sp804_timer_irq = {
>  	.name		= "timer",
> -	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
> +	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
>  	.handler	= sp804_timer_interrupt,
>  	.dev_id		= &sp804_clockevent,
>  };
> -- 
> 1.8.1.2
> 
