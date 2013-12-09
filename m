Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940Ab3LIUiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 15:38:11 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:59041 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286Ab3LIUiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 15:38:08 -0500
Message-ID: <52A62A27.7080408@samsung.com>
Date: Tue, 10 Dec 2013 05:37:59 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
CC: Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>, nicolas.pitre@linaro.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>, linux-doc@vger.kernel.org,
        tomasz.figa@gmail.com, Naour Romain <romain.naour@openwide.fr>,
        Tarek Dakhran <t.dakhran@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
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
Subject: Re: [PATCH v4 2/4] clk: exynos5410: register clocks using common
 clock framework
References: <1385456288-20398-1-git-send-email-v.tyrtov@samsung.com> <1385456288-20398-3-git-send-email-v.tyrtov@samsung.com> <1914850.6CAa0SzDWP@amdc1227>
In-Reply-To: <1914850.6CAa0SzDWP@amdc1227>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/13 01:34, Tomasz Figa wrote:
> Hi Vyacheslav, Tarek,
>
> On Tuesday 26 of November 2013 12:58:06 Vyacheslav Tyrtov wrote:
>> From: Tarek Dakhran<t.dakhran@samsung.com>
>>
>> The EXYNOS5410 clocks are statically listed and registered
>> using the Samsung specific common clock helper functions.
>>
>> Signed-off-by: Tarek Dakhran<t.dakhran@samsung.com>
>> Signed-off-by: Vyacheslav Tyrtov<v.tyrtov@samsung.com>
>> ---
>>   .../devicetree/bindings/clock/exynos5410-clock.txt |  54 +++++
>>   drivers/clk/samsung/Makefile                       |   1 +
>>   drivers/clk/samsung/clk-exynos5410.c               | 239 +++++++++++++++++++++
>>   include/dt-bindings/clock/exynos5410.h             |  32 +++
>>   4 files changed, 326 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/clock/exynos5410-clock.txt
>>   create mode 100644 drivers/clk/samsung/clk-exynos5410.c
>>   create mode 100644 include/dt-bindings/clock/exynos5410.h
>
> Acked-by: Tomasz Figa<t.figa@samsung.com>
>
Tomasz, thanks for your ack on clk stuff.

> This should go through Samsung tree, I guess, since it's a dependency
> of other patches in this series and doesn't depend on any things from
> clock tree. Mike, Kukjin, are you okay with this?
>
Yeah, I'm fine on this series but 4th patch for supporting dual cluster.

Let me take 1 to 3 patches firstly. Thanks.
- Kukjin
