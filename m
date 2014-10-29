Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934547AbaJ2Q4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:56:34 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59959 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934001AbaJ2QyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:54:10 -0400
Message-ID: <54511B96.4000304@gmail.com>
Date: Wed, 29 Oct 2014 09:53:42 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kevin Cernekee <cernekee@gmail.com>, tglx@linutronix.de,
        jason@lakedaemon.net, ralf@linux-mips.org
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mbizon@freebox.fr, jogo@openwrt.org, linux-mips@linux-mips.org
Subject: Re: [PATCH 04/11] irqchip: Remove ARM dependency for bcm7120-l2 and
 brcmstb-l2
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com> <1414555138-6500-4-git-send-email-cernekee@gmail.com>
In-Reply-To: <1414555138-6500-4-git-send-email-cernekee@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 08:58 PM, Kevin Cernekee wrote:
> This can compile for MIPS (or anything else) now.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

> ---
>  drivers/irqchip/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
> index 6f0e80b..6a03c65 100644
> --- a/drivers/irqchip/Kconfig
> +++ b/drivers/irqchip/Kconfig
> @@ -53,7 +53,6 @@ config ATMEL_AIC5_IRQ
>  
>  config BRCMSTB_L2_IRQ
>  	bool
> -	depends on ARM
>  	select GENERIC_IRQ_CHIP
>  	select IRQ_DOMAIN
>  
> 

