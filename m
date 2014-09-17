Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbaIQQTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:19:52 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45121 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870AbaIQQTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:19:50 -0400
Message-ID: <5419B485.8010002@ti.com>
Date: Wed, 17 Sep 2014 21:49:17 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <kgene.kim@samsung.com>, <maxime.ripard@free-electrons.com>,
        <linux-samsung-soc@vger.kernel.org>
CC: <patches@linaro.org>, <lee.jones@linaro.org>
Subject: Re: [PATCH 7/9] phy: remove .owner field for drivers using module_platform_driver
References: <1408106416-19044-1-git-send-email-peter.griffin@linaro.org> <1408106416-19044-8-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1408106416-19044-8-git-send-email-peter.griffin@linaro.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 15 August 2014 06:10 PM, Peter Griffin wrote:
> This patch removes the superflous .owner field for drivers which
> use the module_platform_driver or platform_driver_register api,
> as this is overriden in __platform_driver_register.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  drivers/phy/phy-bcm-kona-usb2.c     | 1 -
>  drivers/phy/phy-berlin-sata.c       | 1 -
>  drivers/phy/phy-exynos-dp-video.c   | 1 -
>  drivers/phy/phy-exynos-mipi-video.c | 1 -
>  drivers/phy/phy-exynos5-usbdrd.c    | 1 -
>  drivers/phy/phy-exynos5250-sata.c   | 1 -
>  drivers/phy/phy-hix5hd2-sata.c      | 1 -
>  drivers/phy/phy-miphy365x.c         | 1 -
>  drivers/phy/phy-mvebu-sata.c        | 1 -
>  drivers/phy/phy-omap-control.c      | 1 -
>  drivers/phy/phy-omap-usb2.c         | 1 -
>  drivers/phy/phy-qcom-apq8064-sata.c | 1 -
>  drivers/phy/phy-qcom-ipq806x-sata.c | 1 -
>  drivers/phy/phy-samsung-usb2.c      | 1 -
>  drivers/phy/phy-sun4i-usb.c         | 1 -
>  drivers/phy/phy-ti-pipe3.c          | 1 -
>  drivers/phy/phy-twl4030-usb.c       | 1 -

twl4030-usb doesn't use module_platform_driver. Care to resend this patch
along? I've merged all other patches in this series.

Cheers
Kishon
