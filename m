Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbaJ0K2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 06:28:48 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:63105 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaJ0K2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 06:28:46 -0400
MIME-Version: 1.0
In-Reply-To: <1414158814.14830.610.camel@mtksdaap41>
References: <1406824943-24052-1-git-send-email-matthias.bgg@gmail.com>
	<1406824943-24052-7-git-send-email-matthias.bgg@gmail.com>
	<CACRpkdbRhGE8tcKj+W_4F9-xmcm-fxcYuCmLOqX-ESC+3PAmyA@mail.gmail.com>
	<CABuKBe+Q3tnN0s22EMY-dK_6FeN_xN9SmrsW3dPONR6QDJ+V_w@mail.gmail.com>
	<CACRpkdZOB=9wQ3R3sfcBEiNXLVRtgob4iLZ9QWXyVrgjqyvGXQ@mail.gmail.com>
	<CABuKBeJOgkDZ8drPf3LnT2jPH7PEWX2__HDM7_jZbg2BhDRy3g@mail.gmail.com>
	<1414158814.14830.610.camel@mtksdaap41>
Date: Mon, 27 Oct 2014 11:28:44 +0100
Message-ID: <CABuKBe++mqhMCPxci9_4KKgq9vdoLLwZQkdb2xAGMud+=YVhkw@mail.gmail.com>
Subject: Re: [PATCH 6/7] arm: mediatek: enable gpt6 on boot up to make arch
 timer working
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Yingjoe Chen <srv_yingjoe.chen@mediatek.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stefan@agner.ch" <stefan@agner.ch>,
        Stephen Warren <swarren@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Mike Turquette <mturquette@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "Berg, Anders" <anders.berg@lsi.com>,
        Jason Cooper <jason@lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

2014-10-24 15:53 GMT+02:00 Yingjoe Chen <srv_yingjoe.chen@mediatek.com>:
>
> Hi Matthias,
>
> I didn't saw this in v3.18-rc1, are you working on version 2 of this?
> mt8135 and m8127 also need this fixup and we need this to have SMP
> working.

I had a discussion with Mark Rutland from ARM on this [0].
At that point he convinced me that this was not critical.

If we need this for SMP, things really change here I think.

Cheers,
Matthias

[0] https://lkml.org/lkml/2014/8/21/170

>
> Joe.C
>
>



-- 
motzblog.wordpress.com
