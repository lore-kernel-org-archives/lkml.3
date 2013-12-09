Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab3LII5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:57:07 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:47285 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932553Ab3LII5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:57:01 -0500
Message-ID: <52A585D9.4000605@gmail.com>
Date: Mon, 09 Dec 2013 09:56:57 +0100
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Sergei Ianovich <ynvich@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: Re: [PATCH 4/9] ARM: pxa: remove unused variable
References: <1386348542-9584-1-git-send-email-ynvich@gmail.com> <1386543229-1542-1-git-send-email-ynvich@gmail.com> <1386543229-1542-5-git-send-email-ynvich@gmail.com>
In-Reply-To: <1386543229-1542-5-git-send-email-ynvich@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2013 11:53 PM, Sergei Ianovich wrote:
> Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
> CC: Daniel Mack <zonque@gmail.com>
> ---
>  arch/arm/mach-pxa/irq.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/arm/mach-pxa/irq.c b/arch/arm/mach-pxa/irq.c
> index b6cc181..432842c 100644
> --- a/arch/arm/mach-pxa/irq.c
> +++ b/arch/arm/mach-pxa/irq.c
> @@ -236,7 +236,6 @@ void __init pxa_dt_irq_init(int (*fn)(struct irq_data *, unsigned int))
>  {
>  	struct device_node *node;
>  	const struct of_device_id *of_id;
> -	struct pxa_intc_conf *conf;
>  	struct resource res;
>  	int n, ret;
>  
> @@ -246,7 +245,6 @@ void __init pxa_dt_irq_init(int (*fn)(struct irq_data *, unsigned int))
>  		return;
>  	}
>  	of_id = of_match_node(intc_ids, node);
> -	conf = of_id->data;

A similar patch was already merged by Haojian recently. You should
probably rebase your patch stack on top of his maintainer tree.


Daniel

