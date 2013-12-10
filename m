Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab3LJJuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:50:52 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51214 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab3LJJur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:50:47 -0500
X-AuditID: cbfec7f5-b7fd16d000007299-7f-52a6e3f41855
Message-id: <52A6E3E1.1060907@samsung.com>
Date: Tue, 10 Dec 2013 13:50:25 +0400
From: Tarek Dakhran <t.dakhran@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>
Cc: Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>, nicolas.pitre@linaro.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>, linux-doc@vger.kernel.org,
        tomasz.figa@gmail.com, Naour Romain <romain.naour@openwide.fr>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, Dave.Martin@arm.com,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-samsung-soc@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH v4 2/4] clk: exynos5410: register clocks using common clock
 framework
References: <1385456288-20398-1-git-send-email-v.tyrtov@samsung.com>
 <1385456288-20398-3-git-send-email-v.tyrtov@samsung.com>
 <1914850.6CAa0SzDWP@amdc1227> <52A62A27.7080408@samsung.com>
In-reply-to: <52A62A27.7080408@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0iTYRiGefcd9m04+lpqr1IKQkRKptGPF5MQsniTiFDKqECnLjWd2j4n
	WZSSZjE0ljU00znBmW7qaFuesJl2wg4z8YiWmGLZRoaHSLNpzv3x3/U83M91/3gYQtxF+jKp
	GdlSeYYkPYAWku/X3g7tX5quiw5R1+9Dpc0veEizuBvdquoEqPqVjULrUw4K2ewNAJVoh2hk
	mh6mUE1RLYkGOippVN5n5aHxARHSjfTz0Iyqn0YL39b4SFXWRKKX9Ru25h9lJLKs3AXI3l1E
	ImO5g0Rmk5pA+o5/AKnLl/kREDdqGgEuLCimsXZxkI+d+lkCt1d84eOGJ0s0thseUfjzcCeN
	52w2PjbX5mH7MInvWfQAtw5rCLxo8sNPq86c3nZeGJ4kTU/NkcoPHIkXptz/66CztKKr9mVh
	PngnVAKGgewh2NTBKYFgA73hpwkjrQRCRszqAHxe2ctzD78AVFvm+K6UiA2Etq5F2sUkuwdO
	drVSLhHNBkFLW5Rr7cWeg06NEbjj2+HygwnSxZ4shlN2DelyEqyahqsfHm46d7AXoP2rkXCX
	WQHMN69uXgg2pLpi7WYZwR6GDaUtwM3+0Nz4k1ABtmJLScWWWMWWmBYQeuAlVSRmcQnJsoPB
	nETGKTKSgxMzZSbgfvrvNqB7E9YDWAYEeIjgmi5aTElyuFxZD4AMEeApMvTWRYtFSZLca1J5
	ZpxckS7legCPEfjmg/TYhf6WkZ6o0D7vkiuRjgjFrqFnTDavV5wwdja0lbK2XI4aD1KFX1o/
	sWYZvC34Prn3aM3M3tfW0cdxA8Fp7cf1ae1K6YqP+Hp19x3/sY8njQkqj7qbIyErODbMw+g5
	VHhx4U+BT/yNY5Ex86t5o/MzMYZTVH3bztk6A+F0+uUEkFyKJDSQkHOS/5369snSAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 12:37 AM, Kukjin Kim wrote:
> On 12/10/13 01:34, Tomasz Figa wrote:
>> Hi Vyacheslav, Tarek,
>>
>> On Tuesday 26 of November 2013 12:58:06 Vyacheslav Tyrtov wrote:
>>> From: Tarek Dakhran<t.dakhran@samsung.com>
>>>
>>> The EXYNOS5410 clocks are statically listed and registered
>>> using the Samsung specific common clock helper functions.
>>>
>>> Signed-off-by: Tarek Dakhran<t.dakhran@samsung.com>
>>> Signed-off-by: Vyacheslav Tyrtov<v.tyrtov@samsung.com>
>>> ---
>>>   .../devicetree/bindings/clock/exynos5410-clock.txt |  54 +++++
>>>   drivers/clk/samsung/Makefile                       |   1 +
>>>   drivers/clk/samsung/clk-exynos5410.c               | 239 
>>> +++++++++++++++++++++
>>>   include/dt-bindings/clock/exynos5410.h             |  32 +++
>>>   4 files changed, 326 insertions(+)
>>>   create mode 100644 
>>> Documentation/devicetree/bindings/clock/exynos5410-clock.txt
>>>   create mode 100644 drivers/clk/samsung/clk-exynos5410.c
>>>   create mode 100644 include/dt-bindings/clock/exynos5410.h
>>
>> Acked-by: Tomasz Figa<t.figa@samsung.com>
>>
> Tomasz, thanks for your ack on clk stuff.
>
>> This should go through Samsung tree, I guess, since it's a dependency
>> of other patches in this series and doesn't depend on any things from
>> clock tree. Mike, Kukjin, are you okay with this?
>>
> Yeah, I'm fine on this series but 4th patch for supporting dual cluster.
>
> Let me take 1 to 3 patches firstly. Thanks.
> - Kukjin
>

Hi,

Today (10/12/2013) I will release [PATCH v5] without dual cluster support.
EDCS (exynos dual cluster support) will be moved to separate patch.

Best regards,
     Tarek Dakhran.

