Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbaJ3JBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 05:01:36 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:38197 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758621AbaJ3JBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 05:01:21 -0400
MIME-Version: 1.0
In-Reply-To: <1414639400.5833.11.camel@mtksdaap41>
References: <1406824943-24052-1-git-send-email-matthias.bgg@gmail.com>
	<1406824943-24052-7-git-send-email-matthias.bgg@gmail.com>
	<CACRpkdbRhGE8tcKj+W_4F9-xmcm-fxcYuCmLOqX-ESC+3PAmyA@mail.gmail.com>
	<CABuKBe+Q3tnN0s22EMY-dK_6FeN_xN9SmrsW3dPONR6QDJ+V_w@mail.gmail.com>
	<CACRpkdZOB=9wQ3R3sfcBEiNXLVRtgob4iLZ9QWXyVrgjqyvGXQ@mail.gmail.com>
	<CABuKBeJOgkDZ8drPf3LnT2jPH7PEWX2__HDM7_jZbg2BhDRy3g@mail.gmail.com>
	<1414158814.14830.610.camel@mtksdaap41>
	<CABuKBe++mqhMCPxci9_4KKgq9vdoLLwZQkdb2xAGMud+=YVhkw@mail.gmail.com>
	<1414639400.5833.11.camel@mtksdaap41>
Date: Thu, 30 Oct 2014 10:01:19 +0100
Message-ID: <CABuKBeLFjQ+B-QVtQf3nBZtBYf9HF=yQWZv17fOdNyZTm9C34A@mail.gmail.com>
Subject: Re: [PATCH 6/7] arm: mediatek: enable gpt6 on boot up to make arch
 timer working
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
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

2014-10-30 4:23 GMT+01:00 Yingjoe Chen <yingjoe.chen@mediatek.com>:
> Hi Matthias,
>
> On Mon, 2014-10-27 at 11:28 +0100, Matthias Brugger wrote:
>> Hi Joe,
>>
>> 2014-10-24 15:53 GMT+02:00 Yingjoe Chen <srv_yingjoe.chen@mediatek.com>:
>> >
>> > Hi Matthias,
>> >
>> > I didn't saw this in v3.18-rc1, are you working on version 2 of this?
>> > mt8135 and m8127 also need this fixup and we need this to have SMP
>> > working.
>>
>> I had a discussion with Mark Rutland from ARM on this [0].
>> At that point he convinced me that this was not critical.
>>
>> If we need this for SMP, things really change here I think.
>
> We have some driver now, and we started to implement SMP enable method
> internally. I think it is reasonable to discuss this now.
> We could include this patch in our SMP patch series. Do you prefer we do
> this?

Alright. Please remind that we don't need to set the cntfreq register
here but define the clock frequency in the dts.

Thanks,
Matthias

>
> Joe.C
>
>
>



-- 
motzblog.wordpress.com
