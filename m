Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab3GYEPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 00:15:14 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:58648 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab3GYEPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 00:15:08 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: The future of DT binding maintainership
To: Jon Loeliger <jdl@jdl.com>, Tomasz Figa <tomasz.figa@gmail.com>
Cc: "Chaiken, Alison" <Alison_Chaiken@mentor.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <E1V1Nkn-00072x-Df@jdl.com>
References: <CACxGe6vtJPbbqwpH8Th5S36Hx50f39j1P4OpLb-Um9xQie6Lng@mail.gmail.com> <2962401.WRRoYlXkRr@flatron> <60BA5429A0E1584BA3633194F6F993B502B21362@NA-MBX-03.mgc.mentorg.com> <1925583.R0td2pS6as@flatron> <E1V1Nkn-00072x-Df@jdl.com>
Date: Wed, 24 Jul 2013 21:26:16 +0100
Message-Id: <20130724202617.049E33E13AF@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jul 2013 16:34:49 -0500, Jon Loeliger <jdl@jdl.com> wrote:
> 
> > > Is there a schema out there in the wild that exemplifies what you mean?
> > 
> > Not really. The format of schemas is currently in design stage. I'm 
> > currently rethinking some details of what I have in my mind. Give me some 
> > more time and I will post an RFC to the ML with all that written down.
> 
> ...and...
> 
> > > The schema-check idea reminds me of the W3C HTML validators:
> > > 
> > >       http://validator.w3.org/
> > > 
> > > Since device-tree source looks a bit like XML (or maybe more like JSON),
> > > will be the schemas be similar in spirit to DTDs, and is it helpful to
> > > think of the validator in this spirit?   Or will the checker be more
> > > like "gcc -Wall", since it will be invoked by a compiler?
> > 
> > My idea is to implement compile time verification in dtc, so I guess it 
> > will be more like the latter. Since dts is what dtc can already parse, my 
> > plan is to keep the schemas in spirit to dts, just modifying/extending it 
> > to allow specifying bindings with them, rather than static values.
> > 
> > Best regards,
> > Tomasz
> 
> It is possible to add some-damn XML DTD parsing and

/me runs screaming.

g.
