Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935264AbaLLSRG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 13:17:06 -0500
Received: from mo2.mail-out.ovh.net ([178.32.228.2]:54050 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935145AbaLLSRF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 13:17:05 -0500
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH] clk: rockchip: add CLK_IGNORE_UNUSED flag to fix USB Host
From: NEO-Technologies / Julien CHAUVEAU 
	<julien.chauveau@neo-technologies.fr>
In-Reply-To: <CABgxDoKKjwDf8+OuWiTjzpbGonshZ0fHXXMvSkJi1Z1U_7AsNA@mail.gmail.com>
Date: Fri, 12 Dec 2014 19:01:23 +0100
Cc: Heiko Stuebner <heiko@sntech.de>, Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "moderated list:ARM/Rockchip SoC..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "open list:COMMON CLK FRAMEWORK" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <E20CB6ED-61C3-40B5-84E5-95B2A1F4B8FB@neo-technologies.fr>
References: <1418396066-31360-1-git-send-email-julien.chauveau@neo-technologies.fr> <CABgxDoKKjwDf8+OuWiTjzpbGonshZ0fHXXMvSkJi1Z1U_7AsNA@mail.gmail.com>
To: Romain Perier <romain.perier@gmail.com>
X-Mailer: Apple Mail (2.1993)
X-Ovh-Tracer-Id: 3277213154274115645
X-Ovh-Remote: 193.248.240.88 (laubervilliers-656-1-116-88.w193-248.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejiedrgeejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejiedrgeejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Le 12 déc. 2014 à 16:44, Romain Perier <romain.perier@gmail.com> a écrit :
> 
> Hi,
> 
> 2014-12-12 15:54 GMT+01:00 Julien CHAUVEAU
> <julien.chauveau@neo-technologies.fr>:
>> This patch adds CLK_IGNORE_UNUSED flag to hclk_usb_peri, hclk_usbotg0 and hclk_usbotg1
>> because these clocks must remain enabled to use the USB controllers in host mode.
>> 
>> This fixes a regression introduced by patch "clk: rockchip: disable unused clocks"
>> https://lkml.kernel.org/g/1415092270-24932-1-git-send-email-kever.yang@rock-chips.com
> 
> Could you refer the commit id instead ? something like "commit <ID>
> ("title of the corresponding commit »)  

OK, I'll resubmit with commit 78eaf6095cc7 ("clk: rockchip: disable unused clocks").

> (and use scripts/checkpatch.pl
> on your patch to be sure that the commit form is okay).
> 

That’s already done:

scripts/checkpatch.pl 0001-clk-rockchip-add-CLK_IGNORE_UNUSED-flag-to-fix-USB-H.patch 
total: 0 errors, 0 warnings, 30 lines checked

> 
> I confirm the regression.
> 
> Romain

