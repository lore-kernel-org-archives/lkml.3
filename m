Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbaIWMya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 08:54:30 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:42336 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaIWMy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 08:54:28 -0400
Date: Tue, 23 Sep 2014 08:54:23 -0400
From: Matt Porter <mporter@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de, arm@kernel.org,
        bcm@fixthebug.org, jonathar@broadcom.com, sbranden@broadcom.com,
        rjui@broadcom.com, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, hauke@hauke-m.de,
        swarren@wwwdotorg.org, computersforpeace@gmail.com,
        marc.ceeeee@gmail.com, cernekee@gmail.com, gregory.0xf0@gmail.com
Subject: Re: [PATCH] ARM: mach-bcm: offer a new maintainer and process
Message-ID: <20140923125423.GC12283@beef>
References: <1411150632-25695-1-git-send-email-f.fainelli@gmail.com>
 <20140923050339.GF7487@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923050339.GF7487@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 10:03:39PM -0700, Olof Johansson wrote:
> On Fri, Sep 19, 2014 at 11:17:11AM -0700, Florian Fainelli wrote:
> > Hi all,
> > 
> > As some of you may have seen in the news, Broadcom has recently stopped
> > its mobile SoC activities. Upstream support for Broadcom's Mobile SoCs
> > was an effort initially started by Christian Daudt and his team, and then
> > continued by Alex Eleder and Matter Porter assigned to a particular landing
> > team within Linaro to help Broadcom doing so.
> > 
> > As part of this effort, Christian and Matt volunteered for centralizing pull
> > requests coming from the arch/arm/mach-bcm/* directory and as of today, they
> > are still responsible for merging mach-bcm pull requests coming from brcmstb,
> > bcm5301x, bcm2835 and bcm63xx, creating an intermediate layer to the arm-soc
> > tree.
> > 
> > Following the mobile group shut down, our group (in which Brian, Gregory, Marc,
> > Kevin and myself are) inherited these mobile SoC platforms, although at this
> > point we cannot comment on the future of mobile platforms, we know that our
> > Linaro activities have been stopped.
> > 
> > We have not heard much from Christian and Matt in a while, and some of our pull
> > requests have been stalling as a result. We would like to offer both a new
> > maintainer for the mobile platforms as well as reworking the pull request
> > process:
> > 
> > - our group has now full access to these platforms, putting us in the best
> >   position to support Mobile SoCs questions
> 
> So, one question I have is whether it makes sense to keep the mobile
> platforms in the kernel if the line of business is ending?
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

It won't hurt my feelings if it's decided that it has no value being in
the kernel. :) All I can offer is that *maybe* somebody will have a root
exploit for the bcm281xx Roku platforms (that lasts) and/or some of the
capri and hawaii handsets out there and find it useful as a starting
point to work from an Android vendor tree. I don't know if anybody cares
about hacking those platforms or not.

As mentioned in a followup, the VoIP parts (or some of them, at least)
are part of the bcm281xx family and we were expecting them to submit an
ethernet driver for the past year. There were repeated reminders that
they really care about mainline so I would expect it would be premature
to remove that support until we hear from them.

-Matt
