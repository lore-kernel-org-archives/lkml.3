Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbaCNRRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:17:30 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44454 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150AbaCNRR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:17:26 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-cc-532339a37b9b
Message-id: <532339A1.7060509@samsung.com>
Date: Fri, 14 Mar 2014 18:17:21 +0100
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Yuvaraj Kumar <yuvaraj.cd@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Cc: "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        sunil joshi <joshi@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Jingoo Han <jg1.han@samsung.com>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Christoffer Dall <christoffer.dall@linaro.com>,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
Subject: Re: RESEND [PATCH V9 2/2] ARM: dts: exynos5250: Enable ahci sata and
 sata phy
References: <1393931452-18237-1-git-send-email-yuvaraj.cd@samsung.com>
 <5315D5D6.2070308@ti.com>
 <CAKuRcOLC-2rP1O4Lk=TjsZw4RLx5DzdddU07QRHmsqvzGFB87Q@mail.gmail.com>
In-reply-to: <CAKuRcOLC-2rP1O4Lk=TjsZw4RLx5DzdddU07QRHmsqvzGFB87Q@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t/xy7qLLZWDDeadFLPYOGM9q8XiD+vY
	LOYfOcdq0f9mIavFgT87GC0uL7zEavF91xd2i94FV9ksLjztASo5uoPJYtPja6wWC9uWsFhc
	3jWHzWLp9YtMFq8OtrFYPDzazWpx9lS5g6DHmnlrGD0u9/UyeeycdZfd49PMyewed67tYfPY
	vKTeo2/LKkaP4ze2M3l83iTnsXFuaABXFJdNSmpOZllqkb5dAlfGgvaXbAVtzhVnb/9nb2Cc
	YNDFyMkhIWAi0XzvBTOELSZx4d56ti5GLg4hgaWMEs0XPrNAOJ8ZJY7cbARyODh4BbQkHv2P
	A2lgEVCVaFj5mRXEZhNQk/jc8IgNxOYHKlnTdJ0FxBYViJCYO3EzWJxXQFDix+R7YHERgQCJ
	5/t3sYLMZxZYwirxdGYHWJEwUMOq0w+hrljJKLHp3E6wBKdAsMTjljYwm1nAWmLlpG2MELa8
	xOY1b5knMArOQrJkFpKyWUjKFjAyr2IUTS1NLihOSs810itOzC0uzUvXS87P3cQIicivOxiX
	HrM6xCjAwajEw6uhqhwsxJpYVlyZe4hRgoNZSYR3vzFQiDclsbIqtSg/vqg0J7X4ECMTB6dU
	A6PmsW06Fq+bBTUeP/kdcHPnkpReOx+lwgfXw3MjT9YapDwwfeQr9nZB2dmgd+XS5rfVW9Yr
	H36+7sSihJfHtA2CXZ9Gzdzp0CUR8eW9uJKTw7zjp5oSfjaxd68rfTTh26Jthk9Vjh46HBlt
	r8fSLbPx9LJ5Fha6j71n8Fyd4/07LE/3757UcCclluKMREMt5qLiRAAreTJ2pgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yuvaraj,

On 14.03.2014 09:25, Yuvaraj Kumar wrote:
> kgene,
> Please pick this patch.
>
> On Tue, Mar 4, 2014 at 7:02 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>>
>>
>> On Tuesday 04 March 2014 04:40 PM, Yuvaraj Kumar C D wrote:
>>>
>>> This patch adds dt entry for ahci sata controller and its
>>> corresponding phy controller.phy node has been added w.r.t
>>> new generic phy framework.
>>>
>>> Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
>>
>>
>> FWIW
>> Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
>>
>>> ---
>>>    .../devicetree/bindings/ata/exynos-sata-phy.txt    |   14 --------
>>>    .../devicetree/bindings/ata/exynos-sata.txt        |   25 +++++++++-----
>>>    .../devicetree/bindings/phy/samsung-phy.txt        |   36
>>> ++++++++++++++++++++
>>>    arch/arm/boot/dts/exynos5250-arndale.dts           |   21 ++++++++++++
>>>    arch/arm/boot/dts/exynos5250-smdk5250.dts          |   17 +++++----
>>>    arch/arm/boot/dts/exynos5250.dtsi                  |   18 +++++++---
>>>    6 files changed, 98 insertions(+), 33 deletions(-)
>>>    delete mode 100644
>>> Documentation/devicetree/bindings/ata/exynos-sata-phy.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/ata/exynos-sata-phy.txt
>>> b/Documentation/devicetree/bindings/ata/exynos-sata-phy.txt
>>> deleted file mode 100644
>>> index 37824fa..0000000
>>> --- a/Documentation/devicetree/bindings/ata/exynos-sata-phy.txt
>>> +++ /dev/null
>>> @@ -1,14 +0,0 @@
>>> -* Samsung SATA PHY Controller
>>> -
>>> -SATA PHY nodes are defined to describe on-chip SATA Physical layer
>>> controllers.
>>> -Each SATA PHY controller should have its own node.
>>> -
>>> -Required properties:
>>> -- compatible        : compatible list, contains
>>> "samsung,exynos5-sata-phy"
>>> -- reg               : <registers mapping>
>>> -
>>> -Example:
>>> -        sata@ffe07000 {
>>> -                compatible = "samsung,exynos5-sata-phy";
>>> -                reg = <0xffe07000 0x1000>;
>>> -        };
>>> diff --git a/Documentation/devicetree/bindings/ata/exynos-sata.txt
>>> b/Documentation/devicetree/bindings/ata/exynos-sata.txt
>>> index 0849f10..b2adb1f 100644
>>> --- a/Documentation/devicetree/bindings/ata/exynos-sata.txt
>>> +++ b/Documentation/devicetree/bindings/ata/exynos-sata.txt
>>> @@ -4,14 +4,21 @@ SATA nodes are defined to describe on-chip Serial ATA
>>> controllers.
>>>    Each SATA controller should have its own node.
>>>
>>>    Required properties:
>>> -- compatible        : compatible list, contains "samsung,exynos5-sata"
>>> -- interrupts        : <interrupt mapping for SATA IRQ>
>>> -- reg               : <registers mapping>
>>> -- samsung,sata-freq : <frequency in MHz>
>>> +- compatible           : compatible list, contains "samsung,exynos5-sata"
>>> +- interrupts           : <interrupt mapping for SATA IRQ>
>>> +- reg                  : <registers mapping>
>>> +- samsung,sata-freq    : <frequency in MHz>
>>> +- phys                 : as mentioned in phy-bindings.txt
>>> +- phy-names            : as mentioned in phy-bindings.txt
>>>
>>>    Example:
>>> -        sata@ffe08000 {
>>> -                compatible = "samsung,exynos5-sata";
>>> -                reg = <0xffe08000 0x1000>;
>>> -                interrupts = <115>;
>>> -        };
>>> +       sata@122f0000 {
>>> +               compatible = "snps,dwc-ahci";
>>> +               samsung,sata-freq = <66>;
>>> +               reg = <0x122f0000 0x1ff>;
>>> +               interrupts = <0 115 0>;
>>> +               clocks = <&clock 277>, <&clock 143>;
>>> +               clock-names = "sata", "sclk_sata";
>>> +               phys = <&sata_phy>;
>>> +               phy-names = "sata-phy";
>>> +       };
>>> diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt
>>> b/Documentation/devicetree/bindings/phy/samsung-phy.txt
>>> index c0fccaa..a937f75 100644
>>> --- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
>>> +++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
>>> @@ -20,3 +20,39 @@ Required properties:
>>>    - compatible : should be "samsung,exynos5250-dp-video-phy";
>>>    - reg : offset and length of the Display Port PHY register set;
>>>    - #phy-cells : from the generic PHY bindings, must be 0;
>>> +
>>> +Samsung SATA PHY Controller
>>> +---------------------------
>>> +
>>> +SATA PHY nodes are defined to describe on-chip SATA Physical layer
>>> controllers.
>>> +Each SATA PHY controller should have its own node.
>>> +
>>> +Required properties:
>>> +- compatible        : compatible list, contains
>>> "samsung,exynos5250-sata-phy"
>>> +- reg : offset and length of the SATA PHY register set;
>>> +- #phy-cells : from the generic phy bindings;
>>> +
>>> +Example:
>>> +       sata_phy: sata-phy@12170000 {
>>> +               compatible = "samsung,exynos5250-sata-phy";
>>> +               reg = <0x12170000 0x1ff>;
>>> +               clocks = <&clock 287>;
>>> +               clock-names = "sata_phyctrl";
>>> +               #phy-cells = <0>;
>>> +               samsung,exynos-sataphy-i2c-phandle = <&sata_phy_i2c>;
>>> +               samsung,syscon-phandle = <&pmu_syscon>;

The example lists properties that are not documented by the text above 
(clocks, clock-names, samsung,exynos-sataphy-i2c-phandle, 
samsung,syscon-phandle). Why is so?

>>> +       };
>>> +
>>> +Device-Tree bindings for sataphy i2c client driver
>>> +--------------------------------------------------
>>> +
>>> +Required properties:
>>> +compatible: Should be "samsung,exynos-sataphy-i2c"
>>> +- reg: I2C address of the sataphy i2c device.
>>> +
>>> +Example:
>>> +
>>> +       sata_phy_i2c:sata-phy@38 {
>>> +               compatible = "samsung,exynos-sataphy-i2c";
>>> +               reg = <0x38>;
>>> +       };
>>> diff --git a/arch/arm/boot/dts/exynos5250-arndale.dts
>>> b/arch/arm/boot/dts/exynos5250-arndale.dts
>>> index 38b96a4..97eef40 100644
>>> --- a/arch/arm/boot/dts/exynos5250-arndale.dts
>>> +++ b/arch/arm/boot/dts/exynos5250-arndale.dts
>>> @@ -375,6 +375,27 @@
>>>                  };
>>>          };
>>>
>>> +       i2c@121D0000 {
>>> +               status = "okay";
>>> +               samsung,i2c-sda-delay = <100>;
>>> +               samsung,i2c-max-bus-freq = <40000>;
>>> +               samsung,i2c-slave-addr = <0x38>;
>>> +
>>> +               sata_phy_i2c:sata-phy@38 {
>>> +                       compatible = "samsung,exynos-sataphy-i2c";
>>> +                       reg = <0x38>;
>>> +               };

This node should be present in SoC-level dtsi file, as the address of 
the PHY does not depend on particular board.

>>> +       };
>>> +
>>> +       sata@122F0000 {
>>> +               status = "okay";
>>> +       };
>>> +
>>> +       sata-phy@12170000 {
>>> +               status = "okay";
>>> +               samsung,exynos-sataphy-i2c-phandle = <&sata_phy_i2c>;

Same here. The value of samsung,exynos-sataphy-i2c-phandle property is 
not board-specific and should be in higher level dtsi file.

>>> +       };
>>> +
>>>          mmc_0: mmc@12200000 {
>>>                  status = "okay";
>>>                  num-slots = <1>;
>>> diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts
>>> b/arch/arm/boot/dts/exynos5250-smdk5250.dts
>>> index f76946e..81782c1b 100644
>>> --- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
>>> +++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
>>> @@ -242,16 +242,12 @@
>>>                  samsung,i2c-slave-addr = <0x38>;
>>>                  status = "okay";
>>>
>>> -               sata-phy {
>>> -                       compatible = "samsung,sata-phy";
>>> +               sata_phy_i2c:sata-phy@38 {
>>> +                       compatible = "samsung,exynos-sataphy-i2c";
>>>                          reg = <0x38>;
>>>                  };

Ditto.

>>>          };
>>>
>>> -       sata@122F0000 {
>>> -               samsung,sata-freq = <66>;
>>> -       };
>>> -
>>>          i2c@12C80000 {
>>>                  samsung,i2c-sda-delay = <100>;
>>>                  samsung,i2c-max-bus-freq = <66000>;
>>> @@ -274,6 +270,15 @@
>>>                  };
>>>          };
>>>
>>> +       sata@122F0000 {
>>> +               status = "okay";
>>> +       };
>>> +
>>> +       sata-phy@12170000 {
>>> +               status = "okay";
>>> +               samsung,exynos-sataphy-i2c-phandle = <&sata_phy_i2c>;
>>> +       };

Ditto.

Best regards,
Tomasz
