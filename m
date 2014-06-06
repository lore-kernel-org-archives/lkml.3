Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaFFGyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 02:54:43 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:40882 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbaFFGym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 02:54:42 -0400
Date: Fri, 6 Jun 2014 07:54:36 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] mfd: STw481x: allow modular build
Message-ID: <20140606065436.GN24240@lee--X1>
References: <1402003454-1989084-1-git-send-email-arnd@arndb.de>
 <1402003454-1989084-4-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402003454-1989084-4-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jun 2014, Arnd Bergmann wrote:

> This driver depends on I2C, which may be a loadable module.
> While you'd probably want both to be built-in in practice,
> allowing a modular build avoids possible randconfig link
> errors.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/mfd/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 2dd838f..6cc4b6a 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -1226,7 +1226,7 @@ config MFD_WM8994
>  	  functionaltiy of the device other drivers must be enabled.
>  
>  config MFD_STW481X
> -	bool "Support for ST Microelectronics STw481x"
> +	tristate "Support for ST Microelectronics STw481x"
>  	depends on I2C && ARCH_NOMADIK
>  	select REGMAP_I2C
>  	select MFD_CORE

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
