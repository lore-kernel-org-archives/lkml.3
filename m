Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbaLAI4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 03:56:30 -0500
Received: from regular1.263xmail.com ([211.150.99.135]:47672 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbaLAI43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 03:56:29 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: linux-kernel@vger.kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <3f1940c148671c760def8bcd4f095540>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <547C2D2D.8050409@rock-chips.com>
Date: Mon, 01 Dec 2014 16:56:13 +0800
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
        Tony Xie <xxx@rock-chips.com>, Kumar Gala <galak@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 3/4] ARM: dts: add RK3288 suspend support
References: <1416900743-29204-1-git-send-email-zyw@rock-chips.com>	<1416900743-29204-4-git-send-email-zyw@rock-chips.com> <CAD=FV=Vv3ZG3WjMSkGdAW=2Vpev2JWfqJtyFdX=PVB_YjY7__g@mail.gmail.com>
In-Reply-To: <CAD=FV=Vv3ZG3WjMSkGdAW=2Vpev2JWfqJtyFdX=PVB_YjY7__g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/01/2014 01:26 PM, Doug Anderson wrote:
> Chris,
>
> On Mon, Nov 24, 2014 at 11:32 PM, Chris Zhong <zyw@rock-chips.com> wrote:
>> add pmu sram node for suspend, add global_pwroff pinctrl.
>> The pmu sram is used to store the resume code.
>> global_pwroff is held low level at work, it would be pull to high
>> when entering suspend. reference this in the board DTS file since
>> some boards need it.
>>
>> Signed-off-by: Tony Xie <xxx@rock-chips.com>
>> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>> Reviewed-by: Doug Anderson <dianders@chromium.org>
>> Tested-by: Doug Anderson <dianders@chromium.org>
>>
>> ---
>>
>> Changes in v9: None
> This is untrue.  v8 had more stuff than v9.  See:
>
> https://patchwork.kernel.org/patch/5311621/
>
> vs.
>
> https://patchwork.kernel.org/patch/5372911/
>
> I prefer v8.
>
>
>
Ah, I missed the ddr pinctrl in V9, Thank you.
I have modified it, and post the V10.

