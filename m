Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaIAIAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 04:00:25 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:63013 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbaIAIAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 04:00:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAN_we7MQAqEsRaQc_pkRE_KXx9zZNLDBR2aHUrazM30Nv3udmQ@mail.gmail.com>
References: <1409212920-28526-1-git-send-email-gautam.vivek@samsung.com>
	<1409212920-28526-6-git-send-email-gautam.vivek@samsung.com>
	<CAN_we7MQAqEsRaQc_pkRE_KXx9zZNLDBR2aHUrazM30Nv3udmQ@mail.gmail.com>
Date: Mon, 1 Sep 2014 13:30:21 +0530
X-Google-Sender-Auth: Fa8nkfDxAwnZhJVbVe9YDinX_CY
Message-ID: <CAFp+6iHsfg6Ru0LBN=JviV=-mSdmuSo9Te3EXYF+X8jssD_BYQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] phy: exynos5-usbdrd: Adding Kconfig dependency for Exynos7
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Daniele Forsi <dforsi@gmail.com>
Cc: USB list <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, kishon <kishon@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 8:36 PM, Daniele Forsi <dforsi@gmail.com> wrote:
> 2014-08-28 10:02 GMT+02:00 Vivek Gautam:
>
>> This USB 3.0 PHY controller is also present on Exynos7
>> platform, so adding the dependency on ARCH_EXYNOS7 for this driver.
>
>> +++ b/drivers/phy/Kconfig
>> @@ -186,7 +186,7 @@ config PHY_EXYNOS5250_USB2
>>
>>  config PHY_EXYNOS5_USBDRD
>>         tristate "Exynos5 SoC series USB DRD PHY driver"
>> -       depends on ARCH_EXYNOS5 && OF
>> +       depends on (ARCH_EXYNOS5 || ARCH_EXYNOS7) && OF
>
> shouldn't that prompt and its help text be updated to mention also Exynos7?

Right, even that has to be updated accordingly. Will update the same in next
version of the patch. Thanks for pointing this.



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
