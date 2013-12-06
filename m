Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab3LFRIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 12:08:09 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:51615 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab3LFRIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 12:08:06 -0500
Message-ID: <52A20470.3040700@wwwdotorg.org>
Date: Fri, 06 Dec 2013 10:08:00 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ashwini Ghuge <aghuge@nvidia.com>
Subject: Re: [PATCH 4/4] pinctrl: tegra: add pinmux controller driver for
 Tegra124
References: <1386241070-4350-1-git-send-email-ldewangan@nvidia.com> <1386241070-4350-5-git-send-email-ldewangan@nvidia.com> <52A10C7B.8070406@wwwdotorg.org> <52A16E65.70908@nvidia.com>
In-Reply-To: <52A16E65.70908@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2013 11:27 PM, Laxman Dewangan wrote:
> On Friday 06 December 2013 05:00 AM, Stephen Warren wrote:
>> On 12/05/2013 03:57 AM, Laxman Dewangan wrote:
>>> From: Ashwini Ghuge <aghuge@nvidia.com>
>>>
>>> This adds a driver for the Tegra124 pinmux, and required
>>> parameterization data for Tegra124.
>>>
>>> The driver uses the common Tegra pincontrol driver utility
>>> functions to implement the majority of the driver.
>>>
>>> This driver is not compatible with the earlier NVIDIA's SoCs,
>>> hence add new compatibile as "nvidia,tegra124-pinmux".
>>>
>>> Originally written by Ashwini Gguhe.
>>> ldewangan:
>>>          - cleanup the patches,
>>>          - Fix address issue.
...
>> (BTW, those 2 patches would go through the pinctrl tree, and patches 2/4
>> and 3/4 would go through the Tegra tree. You generally shouldn't posted
>> patches that will be applied to different trees in the same series,
>> since there aren't dependencies).
>
> Fine.
> Should I sent the diff or full change? I think full change as this need
> to go on pincontrol subsystem, not in Tegra.

Please send complete patches for the new driver. The patch I have in my
local tree isn't going anywhere; I just have the early version that
Ashwini posted applied locally for testing. A final complete patch
should be sent to the pinctrl maintainer in the normal way.
