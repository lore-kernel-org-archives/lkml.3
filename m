Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218AbaK1Dk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 22:40:27 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:45888 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaK1DkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 22:40:25 -0500
MIME-Version: 1.0
In-Reply-To: <CAGOxZ52XtT-Aq-HJFq7GAzfAq6GEdrzKeez_=fwJR-Z2rkUF+g@mail.gmail.com>
References: <CAGOxZ53TUvZhSDLfeCuyvBwVcrkQhFnftQzk1DbkU_krdoFbZA@mail.gmail.com>
	<1416834381-11314-1-git-send-email-gautam.vivek@samsung.com>
	<CAGOxZ52XtT-Aq-HJFq7GAzfAq6GEdrzKeez_=fwJR-Z2rkUF+g@mail.gmail.com>
Date: Fri, 28 Nov 2014 09:10:24 +0530
Message-ID: <CAFp+6iHG42h3oCkO8mWG4DnpP-X-kh4VanoQOv3By831Ly5DdA@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] arm64: exynos: Add bus1 pinctrl node on exynos7
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Kukjin Kim <kgene@kernel.org>
Cc: Alim Akhtar <alim.akhtar@gmail.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "robh+dt" <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,


On Wed, Nov 26, 2014 at 6:59 PM, Alim Akhtar <alim.akhtar@gmail.com> wrote:
> Hi Vivek,
>
> On Mon, Nov 24, 2014 at 6:36 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
>> BUS1 pinctrl provides gpios for usb and power regulator
>> available on exynos7-espresso board. So add relevant device
>> node for pinctrl-bus1.
>>
>> Signed-off-by: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> ---

We can pick this up for 3.19 rc1 ?

>>
> Looks good to me.
> Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
>
>> This patch was part of series:
>> "[PATCH 00/11] Exynos7: Adding USB 3.0 support"
>>  https://lkml.org/lkml/2014/11/21/247
>>
>> Changes since V1:
>>  - Added support for all pin banks which are part of BUS1 pin controller.
>>
>>  arch/arm64/boot/dts/exynos/exynos7-pinctrl.dtsi |   82 +++++++++++++++++++++++
>>  arch/arm64/boot/dts/exynos/exynos7.dtsi         |    7 ++
>>  2 files changed, 89 insertions(+)
>>
>> diff --git a/arch/arm64/boot/dts/exynos/exynos7-pinctrl.dtsi b/arch/arm64/boot/dts/exynos/exynos7-pinctrl.dtsi
>> index 2eef4a2..c367f0a 100644
>> --- a/arch/arm64/boot/dts/exynos/exynos7-pinctrl.dtsi
>> +++ b/arch/arm64/boot/dts/exynos/exynos7-pinctrl.dtsi
>> @@ -335,6 +335,88 @@
>>         };
>>  };
>>
>> +&pinctrl_bus1 {
>> +       gpf0: gpf0 {
>> +               gpio-controller;
>> +               #gpio-cells = <2>;
>> +
>> +               interrupt-controller;
>> +               #interrupt-cells = <2>;
>> +       };
>> +
>> +       gpf1: gpf1 {
>> +               gpio-controller;
>> +               #gpio-cells = <2>;
>> +
>> +               interrupt-controller;
>> +               #interrupt-cells = <2>;
>> +       };
>> +
>> +       gpf2: gpf2 {
>> +               gpio-controller;
>> +               #gpio-cells = <2>;
>> +
>> +               interrupt-controller;
>> +               #interrupt-cells = <2>;
>> +       };
>> +
>> +       gpf3: gpf3 {
>> +               gpio-controller;
>> +               #gpio-cells = <2>;
>> +
>> +               interrupt-controller;
>> +               #interrupt-cells = <2>;
>> +       };
>> +
>> +       gpf4: gpf4 {
>> +               gpio-controller;
>> +               #gpio-cells = <2>;
>> +
>> +               interrupt-controller;
>> +               #interrupt-cells = <2>;
>> +       };
>> +
>> +       gpf5: gpf5 {
>> +               gpio-controller;
>> +               #gpio-cells = <2>;
>> +
>> +               interrupt-controller;
>> +               #interrupt-cells = <2>;
>> +       };
>> +
>> +       gpg1: gpg1 {
>> +               gpio-controller;
>> +               #gpio-cells = <2>;
>> +
>> +               interrupt-controller;
>> +               #interrupt-cells = <2>;
>> +       };
>> +
>> +       gpg2: gpg2 {
>> +               gpio-controller;
>> +               #gpio-cells = <2>;
>> +
>> +               interrupt-controller;
>> +               #interrupt-cells = <2>;
>> +       };
>> +
>> +       gph1: gph1 {
>> +               gpio-controller;
>> +               #gpio-cells = <2>;
>> +
>> +               interrupt-controller;
>> +               #interrupt-cells = <2>;
>> +       };
>> +
>> +       gpv6: gpv6 {
>> +               gpio-controller;
>> +               #gpio-cells = <2>;
>> +
>> +               interrupt-controller;
>> +               #interrupt-cells = <2>;
>> +       };
>> +};
>> +
>>  &pinctrl_nfc {
>>         gpj0: gpj0 {
>>                 gpio-controller;
>> diff --git a/arch/arm64/boot/dts/exynos/exynos7.dtsi b/arch/arm64/boot/dts/exynos/exynos7.dtsi
>> index 1d9e4c9..e633b02 100644
>> --- a/arch/arm64/boot/dts/exynos/exynos7.dtsi
>> +++ b/arch/arm64/boot/dts/exynos/exynos7.dtsi
>> @@ -26,6 +26,7 @@
>>                 pinctrl5 = &pinctrl_ese;
>>                 pinctrl6 = &pinctrl_fsys0;
>>                 pinctrl7 = &pinctrl_fsys1;
>> +               pinctrl8 = &pinctrl_bus1;
>>         };
>>
>>         cpus {
>> @@ -242,6 +243,12 @@
>>                         interrupts = <0 383 0>;
>>                 };
>>
>> +               pinctrl_bus1: pinctrl@14870000 {
>> +                       compatible = "samsung,exynos7-pinctrl";
>> +                       reg = <0x14870000 0x1000>;
>> +                       interrupts = <0 384 0>;
>> +               };
>> +
>>                 pinctrl_nfc: pinctrl@14cd0000 {
>>                         compatible = "samsung,exynos7-pinctrl";
>>                         reg = <0x14cd0000 0x1000>;
>> --
>> 1.7.10.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Regards,
> Alim
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
