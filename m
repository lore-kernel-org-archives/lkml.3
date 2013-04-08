Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936574Ab3DHPt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:49:27 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:42351 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936409Ab3DHPt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:49:26 -0400
Message-ID: <5162E704.4020805@atmel.com>
Date: Mon, 8 Apr 2013 17:49:24 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <trivial@kernel.org>
Subject: Re: [PATCH 2/2] ARM: at91: remove trailing semicolon from macros
References: <1365346199-29525-1-git-send-email-jhovold@gmail.com> <1365346199-29525-2-git-send-email-jhovold@gmail.com>
In-Reply-To: <1365346199-29525-2-git-send-email-jhovold@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2013 04:49 PM, Johan Hovold :
> Remove trailing semicolon from register-access macros.
> 
> Signed-off-by: Johan Hovold <jhovold@gmail.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Now in at91-3.10-cleanup. Thanks,

> ---
>  arch/arm/mach-at91/at91_rstc.h                | 2 +-
>  arch/arm/mach-at91/at91_shdwc.h               | 2 +-
>  arch/arm/mach-at91/at91x40_time.c             | 2 +-
>  arch/arm/mach-at91/include/mach/at91_matrix.h | 2 +-
>  arch/arm/mach-at91/include/mach/at91_st.h     | 2 +-
>  5 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/at91_rstc.h b/arch/arm/mach-at91/at91_rstc.h
> index 875fa33..a600e69 100644
> --- a/arch/arm/mach-at91/at91_rstc.h
> +++ b/arch/arm/mach-at91/at91_rstc.h
> @@ -23,7 +23,7 @@ extern void __iomem *at91_rstc_base;
>  	__raw_readl(at91_rstc_base + field)
>  
>  #define at91_rstc_write(field, value) \
> -	__raw_writel(value, at91_rstc_base + field);
> +	__raw_writel(value, at91_rstc_base + field)
>  #else
>  .extern at91_rstc_base
>  #endif
> diff --git a/arch/arm/mach-at91/at91_shdwc.h b/arch/arm/mach-at91/at91_shdwc.h
> index 60478ea..9e29f31 100644
> --- a/arch/arm/mach-at91/at91_shdwc.h
> +++ b/arch/arm/mach-at91/at91_shdwc.h
> @@ -23,7 +23,7 @@ extern void __iomem *at91_shdwc_base;
>  	__raw_readl(at91_shdwc_base + field)
>  
>  #define at91_shdwc_write(field, value) \
> -	__raw_writel(value, at91_shdwc_base + field);
> +	__raw_writel(value, at91_shdwc_base + field)
>  #endif
>  
>  #define AT91_SHDW_CR		0x00			/* Shut Down Control Register */
> diff --git a/arch/arm/mach-at91/at91x40_time.c b/arch/arm/mach-at91/at91x40_time.c
> index 0e57e44..f4c81c2 100644
> --- a/arch/arm/mach-at91/at91x40_time.c
> +++ b/arch/arm/mach-at91/at91x40_time.c
> @@ -33,7 +33,7 @@
>  	__raw_readl(AT91_IO_P2V(AT91_TC) + field)
>  
>  #define at91_tc_write(field, value) \
> -	__raw_writel(value, AT91_IO_P2V(AT91_TC) + field);
> +	__raw_writel(value, AT91_IO_P2V(AT91_TC) + field)
>  
>  /*
>   *	3 counter/timer units present.
> diff --git a/arch/arm/mach-at91/include/mach/at91_matrix.h b/arch/arm/mach-at91/include/mach/at91_matrix.h
> index 02fae9d..f8996c9 100644
> --- a/arch/arm/mach-at91/include/mach/at91_matrix.h
> +++ b/arch/arm/mach-at91/include/mach/at91_matrix.h
> @@ -14,7 +14,7 @@ extern void __iomem *at91_matrix_base;
>  	__raw_readl(at91_matrix_base + field)
>  
>  #define at91_matrix_write(field, value) \
> -	__raw_writel(value, at91_matrix_base + field);
> +	__raw_writel(value, at91_matrix_base + field)
>  
>  #else
>  .extern at91_matrix_base
> diff --git a/arch/arm/mach-at91/include/mach/at91_st.h b/arch/arm/mach-at91/include/mach/at91_st.h
> index 969aac2..67fdbd1 100644
> --- a/arch/arm/mach-at91/include/mach/at91_st.h
> +++ b/arch/arm/mach-at91/include/mach/at91_st.h
> @@ -23,7 +23,7 @@ extern void __iomem *at91_st_base;
>  	__raw_readl(at91_st_base + field)
>  
>  #define at91_st_write(field, value) \
> -	__raw_writel(value, at91_st_base + field);
> +	__raw_writel(value, at91_st_base + field)
>  #else
>  .extern at91_st_base
>  #endif
> 


-- 
Nicolas Ferre
