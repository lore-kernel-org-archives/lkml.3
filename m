Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbaJUI6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:58:20 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:34899 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaJUI6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:58:16 -0400
MIME-Version: 1.0
In-Reply-To: <1412260136.4875.9.camel@pengutronix.de>
References: <1411443545-24951-1-git-send-email-srv_hongzhou.yang@mediatek.com>
	<1411443545-24951-5-git-send-email-srv_hongzhou.yang@mediatek.com>
	<CACRpkda-K7w-bY0uSdnZvzEKEeQg38oExoHPSW61kEv9Wv20mA@mail.gmail.com>
	<20140924124044.GC4992@pengutronix.de>
	<CACRpkdbtN-BDEwpJO2swnOjCe3UJhD5WOXXKBV0hPOe2M2=k7Q@mail.gmail.com>
	<1412260136.4875.9.camel@pengutronix.de>
Date: Tue, 21 Oct 2014 10:58:15 +0200
Message-ID: <CACRpkdZv30EAH2vzyfaOQQ4uzEjQ8DwSSHiPr-TsbWUMDmHj7Q@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] ARM: dts: mt8135: Add pinctrl node for mt8135.
From: Linus Walleij <linus.walleij@linaro.org>
To: Lucas Stach <l.stach@pengutronix.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Mark Rutland <mark.rutland@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "Hongzhou.Yang" <srv_hongzhou.yang@mediatek.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King <linux@arm.linux.org.uk>, srv_heupstream@mediatek.com,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hongzhou Yang <hongzhou.yang@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Joe.C" <yingjoe.chen@mediatek.com>, dandan.he@mediatek.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2014 at 4:28 PM, Lucas Stach <l.stach@pengutronix.de> wrote:
> Am Donnerstag, den 02.10.2014, 16:02 +0200 schrieb Linus Walleij:

>> > Agreed for standardized device tree bindings, but not for using strings.
>>
>> What is the alternative? Device Tree is very much about strings,
>> as is shown by the pin config bindings.
>>
> Mhm, maybe we are still talking about different things but I just don't
> get your point. Traditionally DT is more about plain numbers than
> strings. Look at the early examples of PCI or other bus bindings,
> defined back in the IEEE 1275 days. Almost everything back then has
> been mapped to plain numbers.
>
> Using strings only bloats the DT, not only in it's source form, but also
> as a compiled DTB. (...)

OK I think we have arrived (in this thread and in others) to the old
discussion of whether to use groups or per-pin function setting in
drivers.

Let us move forward like this:

I have proposed a general binding of functions+groups (as strings)
which will be suitable for some.

What would you propose as a general binding for systems using
per-pin configuration?

My problem as a subsystem maintainer is that there are too many
custom bindings. We need to standardize on something.

For pin config we have attained some consensus, and that is indeed
using strings "bias-pull-up" etc, simply because there is no
sane way to enumerate them all, and it is simple to read by
humans.

Yours,
Linus Walleij
