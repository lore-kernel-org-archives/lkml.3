Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab3FXNTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 09:19:15 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34755 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3FXNTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 09:19:14 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] genirq: irqchip: document gcflags arg of irq_alloc_domain_generic_chips
To: James Hogan <james.hogan@imgtec.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, James Hogan <james.hogan@imgtec.com>
In-Reply-To: <1371564513-4327-1-git-send-email-james.hogan@imgtec.com>
References: <1371564513-4327-1-git-send-email-james.hogan@imgtec.com>
Date: Mon, 24 Jun 2013 14:19:10 +0100
Message-Id: <20130624131910.87C913E0A89@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jun 2013 15:08:33 +0100, James Hogan <james.hogan@imgtec.com> wrote:
> Commit 088f40b7b027dad6519712ff224a5798dd62a204 ("genirq: Generic chip:
> Add linear irq domain support") missed kerneldoc for the gcflags
> argument of irq_alloc_domain_generic_chips(). Add it now.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  kernel/irq/generic-chip.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
> index 95575d8..a746a8f 100644
> --- a/kernel/irq/generic-chip.c
> +++ b/kernel/irq/generic-chip.c
> @@ -251,12 +251,13 @@ irq_gc_init_mask_cache(struct irq_chip_generic *gc, enum irq_gc_flags flags)
>   * @irqs_per_chip:	Number of interrupts each chip handles
>   * @num_ct:		Number of irq_chip_type instances associated with this
>   * @name:		Name of the irq chip
>   * @handler:		Default flow handler associated with these chips
>   * @clr:		IRQ_* bits to clear in the mapping function
>   * @set:		IRQ_* bits to set in the mapping function
> + * @gcflags:		Generic chip specific setup flags
>   */
>  int irq_alloc_domain_generic_chips(struct irq_domain *d, int irqs_per_chip,
>  				   int num_ct, const char *name,
>  				   irq_flow_handler_t handler,
>  				   unsigned int clr, unsigned int set,
>  				   enum irq_gc_flags gcflags)
> -- 
> 1.8.1.2
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
email sent from notmuch.vim plugin
