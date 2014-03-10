Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbaCJNIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 09:08:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60606 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbaCJNIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 09:08:36 -0400
Date: Mon, 10 Mar 2014 14:08:35 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irqchip: Silence sparse warning
In-Reply-To: <1393981281-25553-1-git-send-email-sboyd@codeaurora.org>
Message-ID: <alpine.LNX.2.00.1403101407440.3690@pobox.suse.cz>
References: <1393981281-25553-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2014, Stephen Boyd wrote:

> drivers/irqchip/irqchip.c:27:13: warning: symbol 'irqchip_init'
> was not declared. Should it be static?
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Why do we have to have drivers/irqchip/irqchip.h and 
include/linux/irqchip.h anyway?

> ---
>  drivers/irqchip/irqchip.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/irqchip/irqchip.c b/drivers/irqchip/irqchip.c
> index f496afce29de..3469141f10f6 100644
> --- a/drivers/irqchip/irqchip.c
> +++ b/drivers/irqchip/irqchip.c
> @@ -10,6 +10,7 @@
>  
>  #include <linux/init.h>
>  #include <linux/of_irq.h>
> +#include <linux/irqchip.h>
>  
>  #include "irqchip.h"

-- 
Jiri Kosina
SUSE Labs
