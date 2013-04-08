Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936526Ab3DHPpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:45:03 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:41880 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936454Ab3DHPpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:45:02 -0400
Message-ID: <5162E5FA.8080807@atmel.com>
Date: Mon, 8 Apr 2013 17:44:58 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [PATCH] ARM: at91: remove unused dbgu_readl() macro
References: <1364981103-22980-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1364981103-22980-1-git-send-email-nicolas.ferre@atmel.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 11:25 AM, Nicolas Ferre :
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

I stack this up on at91-3.10-cleanup right now.

> ---
>  arch/arm/mach-at91/include/mach/at91_dbgu.h | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/include/mach/at91_dbgu.h b/arch/arm/mach-at91/include/mach/at91_dbgu.h
> index 2aa0c5e..3b59485 100644
> --- a/arch/arm/mach-at91/include/mach/at91_dbgu.h
> +++ b/arch/arm/mach-at91/include/mach/at91_dbgu.h
> @@ -16,9 +16,6 @@
>  #ifndef AT91_DBGU_H
>  #define AT91_DBGU_H
>  
> -#define dbgu_readl(dbgu, field) \
> -	__raw_readl(AT91_VA_BASE_SYS + dbgu + AT91_DBGU_ ## field)
> -
>  #if !defined(CONFIG_ARCH_AT91X40)
>  #define AT91_DBGU_CR		(0x00)	/* Control Register */
>  #define AT91_DBGU_MR		(0x04)	/* Mode Register */
> 


-- 
Nicolas Ferre
