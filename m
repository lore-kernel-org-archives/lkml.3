Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab3EUJG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 05:06:56 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:36961 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3EUJGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 05:06:55 -0400
Message-ID: <519B3932.7030508@atmel.com>
Date: Tue, 21 May 2013 11:06:58 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wenyou Yang <wenyou.yang@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <plagnioj@jcrosoft.com>,
        <linux@maxim.org.za>
Subject: Re: [PATCH] ARM: at91: Fix: Change internal SRAM memory type to "MT_MEMORY_SO"
References: <1369011911-21282-1-git-send-email-wenyou.yang@atmel.com> <1369011979-21354-1-git-send-email-wenyou.yang@atmel.com>
In-Reply-To: <1369011979-21354-1-git-send-email-wenyou.yang@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/05/2013 03:06, Wenyou Yang :
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

And stacked on at91-3.10-fixes.

Best regards,

> ---
>   arch/arm/mach-at91/setup.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
> index e2f4bdd..d68be6c 100644
> --- a/arch/arm/mach-at91/setup.c
> +++ b/arch/arm/mach-at91/setup.c
> @@ -80,7 +80,7 @@ void __init at91_init_sram(int bank, unsigned long base, unsigned int length)
>
>   	desc->pfn = __phys_to_pfn(base);
>   	desc->length = length;
> -	desc->type = MT_DEVICE;
> +	desc->type = MT_MEMORY_SO;
>
>   	pr_info("AT91: sram at 0x%lx of 0x%x mapped at 0x%lx\n",
>   		base, length, desc->virtual);
>


-- 
Nicolas Ferre
