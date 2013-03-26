Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab3CZRe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:34:59 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10675 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab3CZRe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:34:58 -0400
X-IronPort-AV: E=Sophos;i="4.84,913,1355126400"; 
   d="scan'208";a="32623548"
Message-ID: <5151DC41.7090307@codeaurora.org>
Date: Tue, 26 Mar 2013 10:34:57 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Tony Lindgren <tony@atomide.com>, linux-arm-msm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Sascha Hauer <kernel@pengutronix.de>, Barry Song <baohua.song@csr.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCHv2] ARM: Push selects for TWD/SCU into machine entries
References: <1362007694-3419-1-git-send-email-sboyd@codeaurora.org> <512E9A39.3070207@wwwdotorg.org> <51354E35.1080804@codeaurora.org> <201303052234.32723.arnd@arndb.de> <5144C8DC.9010104@codeaurora.org>
In-Reply-To: <5144C8DC.9010104@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/13 12:32, Stephen Boyd wrote:
> On 3/5/2013 2:34 PM, Arnd Bergmann wrote:
>> On Tuesday 05 March 2013, Stephen Boyd wrote:
>>> On 02/27/13 15:43, Stephen Warren wrote:
>>>> Seems simple enough it doesn't really need many, but for Tegra,
>>>> Acked-by: Stephen Warren <swarren@nvidia.com>
>>>>
>>>> Which kernel is this going into? It's possible Tegra will get converted
>>>> to multi-platform in 3.10, which might move that main ARCH_TEGRA block
>>>> from arch/arm/Kconfig into arch/arm/mach-tegra/Kconfig, although I
>>>> suppose it doesn't have to move it. I think some/all(?) other
>>>> multi-platform conversions have moved their main Kconfig option like
>>>> that though.
>>> Thanks. I'm hoping that Arnd/Olof can pick this up. I'm not sure which
>>> version it will go into.
>>>
>> Hmm, it certainly looks useful to me. I think it should go into the next
>> cleanup branch as a base, so others can build on top of it. We will
>> also need it for the Exynos multiplatform patches that I hope can land
>> in 3.10 as well.
>>
>> Sneaking it in through the fixes branch would make life easier for us,
>> but it doesn't feel right.
> Arnd, can you pick this up into the arm-soc tree now? It would be good
> to get this into next so that conflicts are avoided later on.
>

Arnd?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

