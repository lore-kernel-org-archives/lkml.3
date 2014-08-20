Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbaHTPWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:22:31 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55551 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbaHTPW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:22:29 -0400
Message-ID: <53F4BD19.2030308@ti.com>
Date: Wed, 20 Aug 2014 20:52:01 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add entry for the Samsung USB2 PHY driver
References: <1408526986-30561-1-git-send-email-k.debski@samsung.com>
In-Reply-To: <1408526986-30561-1-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wednesday 20 August 2014 02:59 PM, Kamil Debski wrote:
> Signed-off-by: Kamil Debski <k.debski@samsung.com>

Thanks :-) Please add a commit log however obvious the patch is.

Cheers
Kishon
> ---
>  MAINTAINERS |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 05dc39d..548602f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7873,6 +7873,19 @@ S:	Supported
>  L:	netdev@vger.kernel.org
>  F:	drivers/net/ethernet/samsung/sxgbe/
>  
> +SAMSUNG USB2 PHY DRIVER
> +M:	Kamil Debski <k.debski@samsung.com>
> +L:	linux-kernel@vger.kernel.org
> +S:	Supported
> +F:	Documentation/devicetree/bindings/phy/samsung-phy.txt
> +F:	Documentation/phy/samsung-usb2.txt
> +F:	drivers/phy/phy-exynos4210-usb2.c
> +F:	drivers/phy/phy-exynos4x12-usb2.c
> +F:	drivers/phy/phy-exynos5250-usb2.c
> +F:	drivers/phy/phy-s5pv210-usb2.c
> +F:	drivers/phy/phy-samsung-usb2.c
> +F:	drivers/phy/phy-samsung-usb2.h
> +
>  SERIAL DRIVERS
>  M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>  L:	linux-serial@vger.kernel.org
> 
