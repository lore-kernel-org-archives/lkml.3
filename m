Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab3KSUjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 15:39:12 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:55279 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab3KSUjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 15:39:10 -0500
MIME-Version: 1.0
In-Reply-To: <52840E8F.3060803@broadcom.com>
References: <1380846199-12829-1-git-send-email-syin@broadcom.com>
	<051069C10411E24D9749790C498526FA1BE0B7D7@SJEXCHMB12.corp.ad.broadcom.com>
	<CACRpkdYSLxp2M4HghcUdjEYGh-UQ+DaiCGp6yee+Qds6DR9poA@mail.gmail.com>
	<201311050026.56321.heiko@sntech.de>
	<527835FE.2030102@wwwdotorg.org>
	<5279A319.5060701@broadcom.com>
	<CACRpkdaxPv6CLMjab_4umyUvbBVYcazjmwx_LGRK76vxT4VUqA@mail.gmail.com>
	<527C3080.5050202@broadcom.com>
	<CACRpkdaf9dVqpE5uFQ5L64n+wXO0AYr5-e1WvYc4rWjVTsTg1w@mail.gmail.com>
	<52840E8F.3060803@broadcom.com>
Date: Tue, 19 Nov 2013 21:39:09 +0100
Message-ID: <CACRpkdYFOUoXwensdfQL=K7OEV=GioXj8AFxTSGukQH2A268BQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] ARM: pinctrl: Add Broadcom Capri pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Sherman Yin <syin@broadcom.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 12:43 AM, Sherman Yin <syin@broadcom.com> wrote:
> On 13-11-11 02:01 AM, Linus Walleij wrote:
>>>
>>> I would imagine that the platform-specific device tree bindings would
>>> need
>>> to clearly explain what the valid values are, as they should.
>>
>> But this is not a platform-specific binding. These are the
>> generic pin configuration bindings we're talking about.
>
> Yes, the properties are generic, but I was under the impression that the
> values can be "custom", such as these:

Well if it makes sense, we should try to make them non-custom.

And drivers should still try to be similar, if possible.

>> If you want arrays of booleans that is a matter for the OF core
>> parser I think.
>
> I was thinking of just using integers and accepting only 1 and 0, everything
> else is error.

Hm OK maybe. You need to talk to the OF people about that.

Yours,
Linus Walleij
