Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaBLJdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:33:18 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:55136 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbaBLJdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:33:16 -0500
Message-ID: <52FB3FDA.4060307@mm-sol.com>
Date: Wed, 12 Feb 2014 11:33:14 +0200
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] hwrng: msm: switch Kconfig to ARCH_QCOM depends
References: <1392150105-21057-1-git-send-email-galak@codeaurora.org>
In-Reply-To: <1392150105-21057-1-git-send-email-galak@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> We've split Qualcomm MSM support into legacy and multiplatform.  The RNG
> driver is only relevant on the multiplatform supported SoCs so switch the
> Kconfig depends to ARCH_QCOM.
> 
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> ---
>  drivers/char/hw_random/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index 2f2b084..289bd3a 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -343,7 +343,7 @@ config HW_RANDOM_TPM
>  
>  config HW_RANDOM_MSM
>  	tristate "Qualcomm MSM Random Number Generator support"
> -	depends on HW_RANDOM && ARCH_MSM
> +	depends on HW_RANDOM && ARCH_QCOM
>  	---help---
>  	  This driver provides kernel-side support for the Random Number
>  	  Generator hardware found on Qualcomm MSM SoCs.
> 

IMO, after this change the "MSM" abbreviation in help clause is
irrelevant, could you remove it?

Reviewed-by: Stanimir Varbanov <svarbanov@mm-sol.com>

regards,
Stan
