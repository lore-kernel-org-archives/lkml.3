Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaH1PHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 11:07:07 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:33234 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaH1PHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 11:07:04 -0400
MIME-Version: 1.0
In-Reply-To: <1409212920-28526-6-git-send-email-gautam.vivek@samsung.com>
References: <1409212920-28526-1-git-send-email-gautam.vivek@samsung.com>
	<1409212920-28526-6-git-send-email-gautam.vivek@samsung.com>
Date: Thu, 28 Aug 2014 17:06:58 +0200
Message-ID: <CAN_we7MQAqEsRaQc_pkRE_KXx9zZNLDBR2aHUrazM30Nv3udmQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] phy: exynos5-usbdrd: Adding Kconfig dependency for Exynos7
From: Daniele Forsi <dforsi@gmail.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: USB list <linux-usb@vger.kernel.org>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, kishon@ti.com, kgene.kim@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-28 10:02 GMT+02:00 Vivek Gautam:

> This USB 3.0 PHY controller is also present on Exynos7
> platform, so adding the dependency on ARCH_EXYNOS7 for this driver.

> +++ b/drivers/phy/Kconfig
> @@ -186,7 +186,7 @@ config PHY_EXYNOS5250_USB2
>
>  config PHY_EXYNOS5_USBDRD
>         tristate "Exynos5 SoC series USB DRD PHY driver"
> -       depends on ARCH_EXYNOS5 && OF
> +       depends on (ARCH_EXYNOS5 || ARCH_EXYNOS7) && OF

shouldn't that prompt and its help text be updated to mention also Exynos7?

-- 
Daniele Forsi
