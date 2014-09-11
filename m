Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbaIKPGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:06:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47308 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751649AbaIKPGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:06:33 -0400
Date: Thu, 11 Sep 2014 17:06:31 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irqchip: atmel-aic5: sama5d3 has 48 IRQs
Message-ID: <20140911170631.58a47ff9@bbrezillon>
In-Reply-To: <1410446511-29477-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1410446511-29477-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014 16:41:51 +0200
Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> The FUSE and RAM controllers don't have any connected IRQs, reducing the number
> of IRQs to 48.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

> ---
>  drivers/irqchip/irq-atmel-aic5.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/irqchip/irq-atmel-aic5.c b/drivers/irqchip/irq-atmel-aic5.c
> index 04fe2c1b5178..dc7d98607a89 100644
> --- a/drivers/irqchip/irq-atmel-aic5.c
> +++ b/drivers/irqchip/irq-atmel-aic5.c
> @@ -341,7 +341,7 @@ static int __init aic5_of_init(struct device_node *node,
>  	return 0;
>  }
>  
> -#define NR_SAMA5D3_IRQS		50
> +#define NR_SAMA5D3_IRQS		48
>  
>  static int __init sama5d3_aic5_of_init(struct device_node *node,
>  				       struct device_node *parent)



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
