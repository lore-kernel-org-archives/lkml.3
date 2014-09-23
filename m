Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaIWFD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 01:03:59 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:36244 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaIWFD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 01:03:57 -0400
Date: Mon, 22 Sep 2014 22:03:39 -0700
From: Olof Johansson <olof@lixom.net>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de, arm@kernel.org,
        mporter@linaro.org, bcm@fixthebug.org, jonathar@broadcom.com,
        sbranden@broadcom.com, rjui@broadcom.com, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, hauke@hauke-m.de,
        swarren@wwwdotorg.org, computersforpeace@gmail.com,
        marc.ceeeee@gmail.com, cernekee@gmail.com, gregory.0xf0@gmail.com
Subject: Re: [PATCH] ARM: mach-bcm: offer a new maintainer and process
Message-ID: <20140923050339.GF7487@localhost>
References: <1411150632-25695-1-git-send-email-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411150632-25695-1-git-send-email-f.fainelli@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 11:17:11AM -0700, Florian Fainelli wrote:
> Hi all,
> 
> As some of you may have seen in the news, Broadcom has recently stopped
> its mobile SoC activities. Upstream support for Broadcom's Mobile SoCs
> was an effort initially started by Christian Daudt and his team, and then
> continued by Alex Eleder and Matter Porter assigned to a particular landing
> team within Linaro to help Broadcom doing so.
> 
> As part of this effort, Christian and Matt volunteered for centralizing pull
> requests coming from the arch/arm/mach-bcm/* directory and as of today, they
> are still responsible for merging mach-bcm pull requests coming from brcmstb,
> bcm5301x, bcm2835 and bcm63xx, creating an intermediate layer to the arm-soc
> tree.
> 
> Following the mobile group shut down, our group (in which Brian, Gregory, Marc,
> Kevin and myself are) inherited these mobile SoC platforms, although at this
> point we cannot comment on the future of mobile platforms, we know that our
> Linaro activities have been stopped.
> 
> We have not heard much from Christian and Matt in a while, and some of our pull
> requests have been stalling as a result. We would like to offer both a new
> maintainer for the mobile platforms as well as reworking the pull request
> process:
> 
> - our group has now full access to these platforms, putting us in the best
>   position to support Mobile SoCs questions

So, one question I have is whether it makes sense to keep the mobile
platforms in the kernel if the line of business is ending?

While I truly do appreciate the work done by Matt and others, there's
also little chance that it'll see substantial use by anyone. The Capri
boards aren't common out in the wild and I'm not aware of any dev
boards or consumer products with these SoCs that might want to run
mainline? Critical things such as power management and graphics are
missing from the current platform support in the kernel, so nobody is
likely to want it on their Android phone, etc.

Maybe the answer to this is "keep it for now, revisit sometime later",
which is perfectly sane -- it has practically no cost to keep it around
the way it's looking now.


-Olof

