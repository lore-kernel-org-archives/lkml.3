Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab3GYHru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 03:47:50 -0400
Received: from mail.lang.hm ([64.81.33.126]:44752 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab3GYHrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 03:47:47 -0400
Date: Thu, 25 Jul 2013 00:47:08 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Grant Likely <grant.likely@secretlab.ca>
cc: Tomasz Figa <tomasz.figa@gmail.com>, Wolfram Sang <w.sang@pengutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>, devicetree@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: The future of DT binding maintainership
In-Reply-To: <20130724141112.464623E09C5@localhost>
Message-ID: <alpine.DEB.2.02.1307250043080.24195@nftneq.ynat.uz>
References: <CACxGe6vtJPbbqwpH8Th5S36Hx50f39j1P4OpLb-Um9xQie6Lng@mail.gmail.com> <20130720034647.2B7B43E14BF@localhost> <2962401.WRRoYlXkRr@flatron> <20130724141112.464623E09C5@localhost>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jul 2013, Grant Likely wrote:

> I wouldn't get to hung up about trying to reuse the same file format as
> the .dts files. Most of the bindings are going to be very flat in
> nature, and schemas need to be expresive in a different way from the
> .dts files themselves.
>
> We'll want to have an easy way to define trivial bindings. There are a
> lot of devices that only define a new 'compatible' string, but they
> don't actually require anything more than reg and interrupts. Can we
> maybe have a schema file that lists trivial bindings?

It sounds like a log of the bindings will really consist of something similar to 
"take this other binding definition and change these values"

I think that figuring out a good way to handle this (and make sure that when 
people change one binding, they can know what other bindings they are changing 
through the dependancies) is at least as important as figuring out the formal 
schemas and multiple inheritance issues.

David Lang
