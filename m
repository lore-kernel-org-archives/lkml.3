Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbaEXKPv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 06:15:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbaEXKPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 06:15:50 -0400
Message-ID: <53807139.6060308@redhat.com>
Date: Sat, 24 May 2014 12:15:21 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>, kishon@ti.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] phy: sun4i: depend on RESET_CONTROLLER
References: <1400871088-16894-1-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1400871088-16894-1-git-send-email-maxime.ripard@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/23/2014 08:51 PM, Maxime Ripard wrote:
> The driver depend on the reset framework in a mandatory way. Make sure
> reset_control_get is defined by adding this dependency in Kconfig
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Reported-by: Arnd Bergmann <arnd@arndb.de>

Good catch.

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans


> ---
>  drivers/phy/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 16a2f067c242..1d8099a56a91 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -112,6 +112,7 @@ config PHY_EXYNOS5250_SATA
>  config PHY_SUN4I_USB
>  	tristate "Allwinner sunxi SoC USB PHY driver"
>  	depends on ARCH_SUNXI && HAS_IOMEM && OF
> +	depends on RESET_CONTROLLER
>  	select GENERIC_PHY
>  	help
>  	  Enable this to support the transceiver that is part of Allwinner
> 
