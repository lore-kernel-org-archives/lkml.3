Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbaKRTjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 14:39:16 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:58848 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246AbaKRTjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 14:39:14 -0500
Message-ID: <546BA05E.4090605@gmail.com>
Date: Tue, 18 Nov 2014 20:39:10 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
To: Antoine Tenart <antoine.tenart@free-electrons.com>, kishon@ti.com,
        p.zabel@pengutronix.de
CC: arnd@arndb.de, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] phy: berlin_usb: depends on RESET_CONTROLLER
References: <1416231192-27056-1-git-send-email-antoine.tenart@free-electrons.com> <1416231192-27056-2-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1416231192-27056-2-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.11.2014 14:33, Antoine Tenart wrote:
> The Berlin USB PHY driver uses the Berlin reset controller
> unconditionally. Make it depending on RESET_CONTROLLER.
>
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>

Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

> ---
>   drivers/phy/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index b6da75f563e7..38ca6ff00aef 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -17,7 +17,7 @@ config GENERIC_PHY
>
>   config PHY_BERLIN_USB
>   	tristate "Marvell Berlin USB PHY Driver"
> -	depends on ARCH_BERLIN && HAS_IOMEM && OF
> +	depends on ARCH_BERLIN && RESET_CONTROLLER && HAS_IOMEM && OF
>   	select GENERIC_PHY
>   	help
>   	  Enable this to support the USB PHY on Marvell Berlin SoCs.
>

