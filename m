Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab3FXK7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:59:54 -0400
Received: from nasmtp01.atmel.com ([192.199.1.246]:59896 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752553Ab3FXKvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:51:19 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Jun 2013 06:51:19 EDT
Message-ID: <51C8230E.20804@atmel.com>
Date: Mon, 24 Jun 2013 18:44:30 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] ARM: at91/PMC: at91sam9n12 family have a PLLB
References: <cover.1372064763.git.nicolas.ferre@atmel.com> <1a09cb9b88027ff0f5226d977786275f0463b930.1372064763.git.nicolas.ferre@atmel.com>
In-Reply-To: <1a09cb9b88027ff0f5226d977786275f0463b930.1372064763.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 05:08 PM, Nicolas Ferre wrote:
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Bo Shen <voice.shen@atmel.com>

> ---
>   arch/arm/mach-at91/clock.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
> index 085a79d..978de42 100644
> --- a/arch/arm/mach-at91/clock.c
> +++ b/arch/arm/mach-at91/clock.c
> @@ -75,7 +75,6 @@ EXPORT_SYMBOL_GPL(at91_pmc_base);
>   #define cpu_has_pllb()		(!(cpu_is_at91sam9rl() \
>   				|| cpu_is_at91sam9g45() \
>   				|| cpu_is_at91sam9x5() \
> -				|| cpu_is_at91sam9n12() \
>   				|| cpu_is_sama5d3()))
>
>   #define cpu_has_upll()		(cpu_is_at91sam9g45() \
>

