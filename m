Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737Ab3EJRqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 13:46:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48106 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757733Ab3EJRqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 13:46:19 -0400
Date: Fri, 10 May 2013 18:43:44 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Olof Johansson <olof@lixom.net>
Cc: Christian Daudt <csd@broadcom.com>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Will Deacon <will.deacon@arm.com>, "arm@kernel.org" <arm@kernel.org>,
        linux-arm-kernel@lists.infradead.org, csd_b@daudt.org,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] ARM: bcm281xx: Add L2 support for Rev A2 chips
Message-ID: <20130510174344.GX18614@n2100.arm.linux.org.uk>
References: <1367542653-955-1-git-send-email-csd@broadcom.com> <20130509204434.GA16724@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130509204434.GA16724@quad.lixom.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 01:44:34PM -0700, Olof Johansson wrote:
> On Thu, May 02, 2013 at 05:57:33PM -0700, Christian Daudt wrote:
> > Rev A2 SoCs have an unorthodox memory re-mapping and this needs
> > to be reflected in the cache operations.
> > This patch adds new outer cache functions for the l2x0 driver
> > to support this SoC revision. It also adds a new compatible
> > value for the cache to enable this functionality.
> > 
> > Updates from V1:
> > - remove section 1 altogether and note that in comments
> > - simplify section selection caused by section 1 removal
> > - BUG_ON just in case section 1 shows up
> > 
> > Signed-off-by: Christian Daudt <csd@broadcom.com>
> 
> This patch mostly covers code that is on Russells plate, so please feed
> this to his tracker to be picked up by him. Feel free to add:

Yes, but there's a problem.  I don't have bcm11351.dtsi to apply this
patch to.  This is one of the problems of splitting the SoC stuff
from core stuff - either I start doing cross-merges (which cause Linus
and everyone else pain as we've seen this time around) or we have to
stuff everything through a single tree.

Not happy.

Not applying until after -rc1.
