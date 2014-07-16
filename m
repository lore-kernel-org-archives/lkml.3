Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbaGPMHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:07:14 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:51244 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbaGPMHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:07:10 -0400
Message-ID: <53C66AEB.7030906@mm-sol.com>
Date: Wed, 16 Jul 2014 15:07:07 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: pramod.gurav.etc@gmail.com
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Josh Cartwright <joshc@codeaurora.org>,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] regmap: Kconfig: Select SPMI when REGMAP_SPMI is selected
References: <1405510797-755-1-git-send-email-pramod.gurav.etc@gmail.com>
In-Reply-To: <1405510797-755-1-git-send-email-pramod.gurav.etc@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

<snip>
> 
> Signed-off-by: Pramod Gurav <pramod.gurav.etc@gmail.com>
> CC: Josh Cartwright <joshc@codeaurora.org>
> CC: Mark Brown <broonie@linaro.org>
> ---
> This was found when I enabled support for Qualcomm QPNP PMICs and was
> compiling it. It selects REGMAP_SPMI and hence the crash.
> 
>  drivers/base/regmap/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
> index 4251570..1aa9d71 100644
> --- a/drivers/base/regmap/Kconfig
> +++ b/drivers/base/regmap/Kconfig
> @@ -16,6 +16,7 @@ config REGMAP_SPI
>  	tristate
>  
>  config REGMAP_SPMI
> +	select SPMI

NO, IMO the CONFIG_SPMI should be enabled by qcom_defconfig and
multi_v7_defconfig. See CONFIG_I2C and REGMAP_I2C for example.

-- 
regards,
Stan
