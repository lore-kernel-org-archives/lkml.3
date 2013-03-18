Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab3CRNmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 09:42:00 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:65247 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab3CRNl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 09:41:59 -0400
MIME-Version: 1.0
In-Reply-To: <006301ce211d$a6caa670$f45ff350$%han@samsung.com>
References: <1363195099-15919-1-git-send-email-dianders@chromium.org>
	<006301ce211d$a6caa670$f45ff350$%han@samsung.com>
Date: Mon, 18 Mar 2013 19:11:57 +0530
Message-ID: <CAFp+6iFXd-4uFfc4v_kWf_FTBmeHkNwsEV0QoyHCzza8evgd9A@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: add usb 2.0 clock references to exynos5250
 device tree
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Padmavathi Venna <padma.v@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Fri, Mar 15, 2013 at 7:07 AM, Jingoo Han <jg1.han@samsung.com> wrote:
>
> On Thursday, March 14, 2013 2:18 AM, Doug Anderson wrote:
>>
>> This is a fixup to two device tree nodes that have already landed but
>> without clock nodes since the transition to common clock happened at
>> the same time.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>
> The clock number and name are right.
>
> Reviewed-by: Jingoo Han <jg1.han@samsung.com>
>
>
> Best regards,
> Jingoo Han
>
>> ---
>>  arch/arm/boot/dts/exynos5250.dtsi | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
>> index 24c52e6..59be603 100644
>> --- a/arch/arm/boot/dts/exynos5250.dtsi
>> +++ b/arch/arm/boot/dts/exynos5250.dtsi
>> @@ -402,12 +402,18 @@
>>               compatible = "samsung,exynos4210-ehci";
>>               reg = <0x12110000 0x100>;
>>               interrupts = <0 71 0>;
>> +
>> +             clocks = <&clock 285>;
>> +             clock-names = "usbhost";
>>       };
>>
>>       usb@12120000 {
>>               compatible = "samsung,exynos4210-ohci";
>>               reg = <0x12120000 0x100>;
>>               interrupts = <0 71 0>;
>> +
>> +             clocks = <&clock 285>;
>> +             clock-names = "usbhost";

tested this patch with smdk5250 h/w.

Tested-by: Vivek Gautam <gautam.vivek@samsung.com>


-- 
Thanks & Regards
Vivek
