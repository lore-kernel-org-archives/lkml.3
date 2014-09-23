Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbaIWFXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 01:23:30 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:62606 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaIWFX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 01:23:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140923050339.GF7487@localhost>
References: <1411150632-25695-1-git-send-email-f.fainelli@gmail.com> <20140923050339.GF7487@localhost>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Mon, 22 Sep 2014 22:22:47 -0700
Message-ID: <CAGVrzcZD+h76CjD925PmcP94JDSqRwt2VgTj_SJNHBTfCNwFqw@mail.gmail.com>
Subject: Re: [PATCH] ARM: mach-bcm: offer a new maintainer and process
To: Olof Johansson <olof@lixom.net>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, "arm@kernel.org" <arm@kernel.org>,
        Matt Porter <mporter@linaro.org>, Christian Daudt <bcm@fixthebug.org>,
        Jonathan Richardson <jonathar@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>, Ray Jui <rjui@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marc Carino <marc.ceeeee@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-22 22:03 GMT-07:00 Olof Johansson <olof@lixom.net>:
> On Fri, Sep 19, 2014 at 11:17:11AM -0700, Florian Fainelli wrote:
>> Hi all,
>>
>> As some of you may have seen in the news, Broadcom has recently stopped
>> its mobile SoC activities. Upstream support for Broadcom's Mobile SoCs
>> was an effort initially started by Christian Daudt and his team, and then
>> continued by Alex Eleder and Matter Porter assigned to a particular landing
>> team within Linaro to help Broadcom doing so.
>>
>> As part of this effort, Christian and Matt volunteered for centralizing pull
>> requests coming from the arch/arm/mach-bcm/* directory and as of today, they
>> are still responsible for merging mach-bcm pull requests coming from brcmstb,
>> bcm5301x, bcm2835 and bcm63xx, creating an intermediate layer to the arm-soc
>> tree.
>>
>> Following the mobile group shut down, our group (in which Brian, Gregory, Marc,
>> Kevin and myself are) inherited these mobile SoC platforms, although at this
>> point we cannot comment on the future of mobile platforms, we know that our
>> Linaro activities have been stopped.
>>
>> We have not heard much from Christian and Matt in a while, and some of our pull
>> requests have been stalling as a result. We would like to offer both a new
>> maintainer for the mobile platforms as well as reworking the pull request
>> process:
>>
>> - our group has now full access to these platforms, putting us in the best
>>   position to support Mobile SoCs questions
>
> So, one question I have is whether it makes sense to keep the mobile
> platforms in the kernel if the line of business is ending?

I leave it to Scott for more details, but last we talked he mentioned
what has been upstreamed is useful for some other platforms he cares
about.

>
> While I truly do appreciate the work done by Matt and others, there's
> also little chance that it'll see substantial use by anyone. The Capri
> boards aren't common out in the wild and I'm not aware of any dev
> boards or consumer products with these SoCs that might want to run
> mainline? Critical things such as power management and graphics are
> missing from the current platform support in the kernel, so nobody is
> likely to want it on their Android phone, etc.
>
> Maybe the answer to this is "keep it for now, revisit sometime later",
> which is perfectly sane -- it has practically no cost to keep it around
> the way it's looking now.

Right, let's adopt that approach for now, and we can revisit that
later in light of Scott and his group's work.
--
Florian
