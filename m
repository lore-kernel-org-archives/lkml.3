Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbaIKQ15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:27:57 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:16527 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354AbaIKQ1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:27:55 -0400
Message-ID: <5411CD86.2030900@atmel.com>
Date: Thu, 11 Sep 2014 18:27:50 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] irqchip: atmel-aic5: sama5d3 has 48 IRQs
References: <1410446511-29477-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1410446511-29477-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2014 16:41, Alexandre Belloni :
> The FUSE and RAM controllers don't have any connected IRQs, reducing the number
> of IRQs to 48.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

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
> 


-- 
Nicolas Ferre
