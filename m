Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab3HVHxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:53:32 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:49918 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab3HVHxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:53:30 -0400
MIME-Version: 1.0
In-Reply-To: <201308220947.29715.poeschel@lemonage.de>
References: <201308211719.57748.poeschel@lemonage.de> <5214FBA8.5000603@wwwdotorg.org>
 <201308220947.29715.poeschel@lemonage.de>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 22 Aug 2013 08:52:49 +0100
Message-ID: <CAGVrzcZ2bOxJxxheNXkQ9x1TLOeQW1UzbFz5sc6=Gg6Cv+2Q_Q@mail.gmail.com>
Subject: Re: [PATCH] of: add vendor prefix for Microchip Technology Inc
To: Lars Poeschel <poeschel@lemonage.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2013/8/22 Lars Poeschel <poeschel@lemonage.de>:
> On Wednesday 21 August 2013 at 19:40:56, Stephen Warren wrote:
>> On 08/21/2013 09:19 AM, Lars Poeschel wrote:
>> > Trivial patch to add Microchip Technology Inc. to the list
>> > of devicetree vendor prefixes, as it is already used in
>> > Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
>>
>> Oh dear. Perhaps it can be legacy-ified...
>>
>> > diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt
>> >
>> > +mcp        Microchip Technology Inc.
>>
>> If I saw "mcp," in a *.dts file, I wouldn't immediately think
>> "Microchip".
>>
>> Their stock ticker appears to be MCHP, so I'd suggest either "mchp" or
>> "microchip" instead; that latter being my personal preference.
>
> Any other opinions?
> If there are other voices who don't like it, we can change it. There is no
> in-tree dts file using this yet.
> How can a renaming be done? Would that involve changing the drivers (and
> module) name too? Or do we have the difference between "mcp" in the drivers
> name and "microchip" for device tree properties? In the latter case, I'd
> vote against it - if anyone cares. ;-)

We have recently had an interesting debate for the Broadcom vendor
prefix, so in light of this debate, I would go for the full name
directly and use "microchip". That said, this does not necessarily
mean that drivers containing "mcp" in their files/filenames must also
be renamed.
-- 
Florian
