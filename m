Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbaK0A5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 19:57:23 -0500
Received: from regular1.263xmail.com ([211.150.99.140]:41386 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbaK0A5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 19:57:22 -0500
X-263anti-spam: KSV:0;BIG:0;ABS:1;DNS:0;ATT:0;SPF:S;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 1
X-SKE-CHECKED: 1
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: linux-kernel@vger.kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <8360ee9bf07b4b9fa73da5a74fccb02f>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <547676B0.9030001@rock-chips.com>
Date: Thu, 27 Nov 2014 08:56:16 +0800
From: Chris Zhong <zyw@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kevin Hilman <khilman@kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 4/4] ARM: dts: rockchip: add suspend settings for rk3288-evb-rk808
References: <1416900743-29204-1-git-send-email-zyw@rock-chips.com>	<1416900743-29204-5-git-send-email-zyw@rock-chips.com> <CAD=FV=V29zCpcEHE+rq6q_6SOZ_NOJgc5FiwmJ9jnRZK4mMUhw@mail.gmail.com>
In-Reply-To: <CAD=FV=V29zCpcEHE+rq6q_6SOZ_NOJgc5FiwmJ9jnRZK4mMUhw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/27/2014 06:52 AM, Doug Anderson wrote:
> Chris,
>
> On Mon, Nov 24, 2014 at 11:32 PM, Chris Zhong <zyw@rock-chips.com> wrote:
>>                          vcc_ddr: DCDC_REG3 {
>>                                  regulator-always-on;
>>                                  regulator-boot-on;
>>                                  regulator-name = "vcc_ddr";
>> +                               regulator-suspend-mem-enabled;
> The "regulator-suspend-mem-enabled" is not an upstream property and
> isn't doing anything.  It should be removed.
>
> Possibly this is something Heiko could do when applying  (depends on
> what he wants) if no other spins are required.
>>                          vcc_18: LDO_REG7 {
>> @@ -128,6 +163,11 @@
>>                                  regulator-min-microvolt = <1800000>;
>>                                  regulator-max-microvolt = <1800000>;
>>                                  regulator-name = "vcc_18";
>> +                               regulator-suspend-mem-microvolt = <1800000>;
> Another non-upstream property: regulator-suspend-mem-microvolt
Ah, missed these two. I should remove all the regulator-suspend-mem-*, 
they are from Gerrit.
Thank you.
>
>
>


