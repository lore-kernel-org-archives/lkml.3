Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab3FKNwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 09:52:50 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:47793 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab3FKNwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 09:52:49 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 3/7] irq: fix checkpatch error
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, guohanjun@huawei.com
In-Reply-To: <1370517631-8684-4-git-send-email-wangkefeng.wang@huawei.com>
References: <1370517631-8684-1-git-send-email-wangkefeng.wang@huawei.com> <1370517631-8684-4-git-send-email-wangkefeng.wang@huawei.com>
Date: Tue, 11 Jun 2013 14:52:45 +0100
Message-Id: <20130611135246.0717A3E0A90@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jun 2013 19:20:27 +0800, Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
> ERROR: space required before the open parenthesis '('
> WARNING: Prefer pr_warn(... to pr_warning(...
> Just fix above 2 issue.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Applied, thanks.

g.

> ---
>  kernel/irq/irqdomain.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 5a83dde..fd47f33 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -419,7 +419,7 @@ static void irq_domain_disassociate_many(struct irq_domain *domain,
>  		irq_data->hwirq = 0;
>  
>  		/* Clear reverse map */
> -		switch(domain->revmap_type) {
> +		switch (domain->revmap_type) {
>  		case IRQ_DOMAIN_MAP_LINEAR:
>  			if (hwirq < domain->revmap_data.linear.size)
>  				domain->revmap_data.linear.revmap[hwirq] = 0;
> @@ -570,7 +570,7 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
>  	if (domain == NULL)
>  		domain = irq_default_domain;
>  	if (domain == NULL) {
> -		pr_warning("irq_create_mapping called for"
> +		pr_warn("irq_create_mapping called for"
>  			   " NULL domain, hwirq=%lx\n", hwirq);
>  		WARN_ON(1);
>  		return 0;
> @@ -672,7 +672,7 @@ unsigned int irq_create_of_mapping(struct device_node *controller,
>  		if (intsize > 0)
>  			return intspec[0];
>  #endif
> -		pr_warning("no irq domain found for %s !\n",
> +		pr_warn("no irq domain found for %s !\n",
>  			   of_node_full_name(controller));
>  		return 0;
>  	}
> -- 
> 1.8.2.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
