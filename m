Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab3A3ITT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:19:19 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:48526 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3A3ITQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:19:16 -0500
MIME-Version: 1.0
In-Reply-To: <076f01cdfea7$8e752d90$ab5f88b0$@samsung.com>
References: <1358868680-5757-1-git-send-email-gautam.vivek@samsung.com>
	<1358868680-5757-2-git-send-email-gautam.vivek@samsung.com>
	<076f01cdfea7$8e752d90$ab5f88b0$@samsung.com>
Date: Wed, 30 Jan 2013 13:49:14 +0530
Message-ID: <CAFp+6iGfLWpnq5AXjCVieaDUU94bJFaLAkSWPTz0Sj3=ec_56g@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ARM: Exynos5250: Enabling samsung-usbphy driver
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-samsung-soc@vger.kernel.org,
        p.paneri@samsung.com, devicetree-discuss@lists.ozlabs.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        sylvester.nawrocki@gmail.com, tomasz.figa@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,


On Wed, Jan 30, 2013 at 10:36 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Vivek Gautam wrote:
>>
>> Adding usbphy node for Exynos5250 along with the
>> necessary device data to be parsed.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>  arch/arm/boot/dts/exynos5250.dtsi |   15 +++++++++++++++
>>  1 files changed, 15 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/exynos5250.dtsi
>> b/arch/arm/boot/dts/exynos5250.dtsi
>> index 30485de..610e338 100644
>> --- a/arch/arm/boot/dts/exynos5250.dtsi
>> +++ b/arch/arm/boot/dts/exynos5250.dtsi
>> @@ -275,6 +275,21 @@
>>               #size-cells = <0>;
>>       };
>>
>> +     usbphy@12130000 {
>
> Please put above node by order of address.
>

Sure will do that. Actually thought the listing was as per IPs.

>> +             compatible = "samsung,exynos5250-usbphy";
>> +             reg = <0x12130000 0x100>;
>> +             #address-cells = <1>;
>> +             #size-cells = <1>;
>> +             ranges;
>> +
>> +             usbphy-sys {
>> +                           /* USB device and host PHY_CONTROL registers
> */
>
> Please add the binding documentation instead of comment here.
>

Bindings documentation already added at
"Documentation/devicetree/bindings/usb/samsung-usbphy.txt"
merged in 'usb-next'.

>> +                     reg = <0x10040704 0x8>,
>> +                           /* USB2.0 PHY configuration register */
>> +                           <0x10050230 0x4>;
>> +             };
>> +     };
>> +
>>       amba {
>>               #address-cells = <1>;
>>               #size-cells = <1>;
>> --
>> 1.7.6.5
>




-- 
Thanks & Regards
Vivek
