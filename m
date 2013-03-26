Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142Ab3CZKHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 06:07:17 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:17128 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab3CZKHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 06:07:15 -0400
Message-ID: <5151734C.60605@atmel.com>
Date: Tue, 26 Mar 2013 11:07:08 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: AT91: Fix typo in restart code panic message
References: <1364032738-6371-1-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1364032738-6371-1-git-send-email-maxime.ripard@free-electrons.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2013 10:58 AM, Maxime Ripard :
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

And queued in at91-3.9-fixes.

Thanks Maxime.


> ---
>  arch/arm/mach-at91/setup.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
> index 4b67847..6b4608d 100644
> --- a/arch/arm/mach-at91/setup.c
> +++ b/arch/arm/mach-at91/setup.c
> @@ -333,7 +333,7 @@ static void at91_dt_rstc(void)
>  
>  	of_id = of_match_node(rstc_ids, np);
>  	if (!of_id)
> -		panic("AT91: rtsc no restart function availlable\n");
> +		panic("AT91: rtsc no restart function available\n");
>  
>  	arm_pm_restart = of_id->data;
>  
> 


-- 
Nicolas Ferre
