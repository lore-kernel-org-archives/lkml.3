Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbaILGDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 02:03:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57532 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbaILGDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 02:03:41 -0400
Message-ID: <54128C9B.10904@ti.com>
Date: Fri, 12 Sep 2014 11:33:07 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <b.zolnierkie@samsung.com>, <srinivas.kandagatla@gmail.com>,
        <maxime.coquelin@st.com>, <patrice.chotard@st.com>,
        <lee.jones@linaro.org>
Subject: Re: [PATCH] phy: miphy365x: Select GENERIC_PHY rather than depends
 on
References: <1410457647-14086-1-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1410457647-14086-1-git-send-email-peter.griffin@linaro.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 11 September 2014 11:17 PM, Peter Griffin wrote:
> Change miphy365x over to select GENERIC_PHY like all other phy drivers.

A patch for this by Lee Jones has already been merged and should come up in
this -rc cycle.

Thanks
Kishon
> Also update the help message as the new stih410 SoC doesn't have this
> phy (it is very similar to sti407), so the stih41x naming is sadly no
> longer correct.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  drivers/phy/Kconfig | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index d361d98..68bfe07 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -39,14 +39,14 @@ config PHY_MVEBU_SATA
>  	select GENERIC_PHY
>  
>  config PHY_MIPHY365X
> -	tristate "STMicroelectronics MIPHY365X PHY driver for STiH41x series"
> +	tristate "STMicroelectronics MIPHY365X PHY driver for STiH415/6 series"
>  	depends on ARCH_STI
> -	depends on GENERIC_PHY
>  	depends on HAS_IOMEM
>  	depends on OF
> +	select GENERIC_PHY
>  	help
>  	  Enable this to support the miphy transceiver (for SATA/PCIE)
> -	  that is part of STMicroelectronics STiH41x SoC series.
> +	  that is part of STMicroelectronics STiH415/6 SoC series.
>  
>  config OMAP_CONTROL_PHY
>  	tristate "OMAP CONTROL PHY Driver"
> 
