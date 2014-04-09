Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014AbaDILlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:41:49 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:46977 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758486AbaDILlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:41:45 -0400
MIME-Version: 1.0
In-Reply-To: <53452B59.8030901@samsung.com>
References: <1396967803-28868-1-git-send-email-gautam.vivek@samsung.com>
	<1396967803-28868-6-git-send-email-gautam.vivek@samsung.com>
	<53452B59.8030901@samsung.com>
Date: Wed, 9 Apr 2014 17:04:46 +0530
X-Google-Sender-Auth: UR8JIOvgxeA_Yr-KfpfOlekClDc
Message-ID: <CAFp+6iGQMS5_YAimBRdV-P2h3LczQEHMq_cXGrOtHJSZqM7UfQ@mail.gmail.com>
Subject: Re: [PATCH V4 5/5] usb-phy: samsung-usb3: Remove older
 phy-samsung-usb3 driver
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org, kishon <kishon@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kamil Debski <k.debski@samsung.com>, Jingoo Han <jg1.han@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,
'

On Wed, Apr 9, 2014 at 4:43 PM, Tomasz Figa <t.figa@samsung.com> wrote:
> Hi Vivek,
>
Thanks for reviewing the patch series.

>
> On 08.04.2014 16:36, Vivek Gautam wrote:
>>
>> Removing this older USB 3.0 DRD controller PHY driver, since
>> a new driver based on generic phy framework is now available.
>>
>> Also removing the dt node for older driver from Exynos5250
>> device tree and updating the dt node for DWC3 controller.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>
>> NOTE: This patch should be merged only when the new USB 3.0
>> DRD phy controller driver is available in the tree from the
>> patches:
>>         phy: Add new Exynos5 USB 3.0 PHY driver; and
>>         dt: exynos5250: Enable support for generic USB DRD phy
>>
>>   arch/arm/boot/dts/exynos5250.dtsi  |   17 +-
>>   drivers/usb/phy/phy-samsung-usb.h  |   83 ---------
>>   drivers/usb/phy/phy-samsung-usb3.c |  350
>> ------------------------------------
>>   3 files changed, 2 insertions(+), 448 deletions(-)
>>   delete mode 100644 drivers/usb/phy/phy-samsung-usb3.c
>>
>> diff --git a/arch/arm/boot/dts/exynos5250.dtsi
>> b/arch/arm/boot/dts/exynos5250.dtsi
>> index 92c6fcd..1cb1e91 100644
>> --- a/arch/arm/boot/dts/exynos5250.dtsi
>> +++ b/arch/arm/boot/dts/exynos5250.dtsi
>
>
> IMHO driver and dts changes should be separated into two patches, first
> updating device tree to use the new driver and second removing the driver.

Sure will separate the patch into driver and dts change.

>
> After fixing this issue,
>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
>
> --
> Best regards,
> Tomasz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
