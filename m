Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbbAPW6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 17:58:10 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:47280 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbbAPW6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 17:58:08 -0500
MIME-Version: 1.0
Reply-To: cw00.choi@samsung.com
In-Reply-To: <1421410894.8119.9.camel@AMDC1943>
References: <1421407190-6771-1-git-send-email-k.kozlowski@samsung.com>
	<54B8FB31.5090105@samsung.com>
	<1421410894.8119.9.camel@AMDC1943>
Date: Sat, 17 Jan 2015 07:58:06 +0900
Message-ID: <CAGTfZH3PGh27ap192LK=fHBb-ox2ZTTau-CLpFoguyLLs9X32A@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add entry for Maxim PMIC-s on Samsung boards
From: Chanwoo Choi <cwchoi00@gmail.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: rtc-linux@googlegroups.com,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 9:21 PM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:
> On pią, 2015-01-16 at 20:51 +0900, Chanwoo Choi wrote:
>> Hi Krzysztof,
>>
>> On 01/16/2015 08:19 PM, Krzysztof Kozlowski wrote:
>> > Add myself as supporter for Maxim 77686 PMIC and Maxim 14577/77693 MUIC
>> > drivers:
>> >  - mfd (all of them),
>> >  - extcon (extcon-max14577, extcon-max77693)
>> >  - power (max14577_charger.c, 77693 on LKML [1]),
>> >  - regulator (all of them),
>> >  - clock (clk-max77686.c)
>> >  - RTC (rtc-max77686.c).
>> >
>> > Lately I am the author of major contributors to them. These
>> > drivers are used on Exynos-based boards (Trats 2, Gear 1 and Gear 2).
>> >
>> > [1] https://lkml.org/lkml/2015/1/5/139
>> >
>> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>> > Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
>> > cc: Chanwoo Choi <cw00.choi@samsung.com>
>> > Cc: Samuel Ortiz <sameo@linux.intel.com>
>> > Cc: Lee Jones <lee.jones@linaro.org>
>> > Cc: Sebastian Reichel <sre@kernel.org>
>> > Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
>> > Cc: David Woodhouse <dwmw2@infradead.org>
>> > Cc: Liam Girdwood <lgirdwood@gmail.com>
>> > Cc: Mark Brown <broonie@kernel.org>
>> > Cc: Mike Turquette <mturquette@linaro.org>
>> > Cc: Stephen Boyd <sboyd@codeaurora.org>
>> > Cc: Alessandro Zummo <a.zummo@towertech.it>
>> > ---
>> >  MAINTAINERS | 15 +++++++++++++++
>> >  1 file changed, 15 insertions(+)
>> >
>> > diff --git a/MAINTAINERS b/MAINTAINERS
>> > index f017a30eb280..b033fb499186 100644
>> > --- a/MAINTAINERS
>> > +++ b/MAINTAINERS
>> > @@ -6143,6 +6143,21 @@ F:   Documentation/devicetree/bindings/i2c/max6697.txt
>> >  F: drivers/hwmon/max6697.c
>> >  F: include/linux/platform_data/max6697.h
>> >
>> > +MAXIM PMIC AND MUIC DRIVERS FOR EXYNOS BASED BOARDS
>> > +M: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>> > +L: linux-kernel@vger.kernel.org
>> > +S: Supported
>> > +F: drivers/*/*max14577*.c
>> > +F: drivers/*/*max77686*.c
>> > +F: drivers/*/*max77693*.c
>>
>> I knew that you did implement max14577 series because I did cowork to implement it with you.
>>
>> But,
>> The drivers/extcon/extcon-max77693.c was implemented by me
>> and extcon-max14577.c was implemented by me and you.
>>
>> The initial version of drivers/mfd/max77876.c, drivers/regulator/max77686.c
>> was implemented by Jonghwa Lee(jonghwa3.lee@samsung.com).
>>
>> The initial version of drivers/mfd/max77693.c was implmented by me
>> and drivers/mfd/max77693.c by Jonghwa Lee.
>>
>
> Yes, your are right. However I do not change the ownership or authorship
> of these drivers here. You and the others will still be the authors.
> Being the initial author is somehow different then reviewing and
> developing the driver further.
>
> Although you didn't say that explicitly here but if you think there
> should be an entry also for you than I would appreciate it fully.

Yes, If you agree,I think you better add an entry for me. Except for
power-supply drivers, I did co-work to implement these drivers with you.

Best Regards,
Chanwoo Choi
