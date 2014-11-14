Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbaKNJwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 04:52:25 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:39383 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754643AbaKNJwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 04:52:22 -0500
Date: Fri, 14 Nov 2014 09:52:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Takashi Iwai <tiwai@suse.de>, "Wang, Yalin" <Yalin.Wang@sonymobile.com>,
        "'Will Deacon'" <will.deacon@arm.com>,
        "'Ard Biesheuvel'" <ard.biesheuvel@linaro.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'akinobu.mita@gmail.com'" <akinobu.mita@gmail.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC V6 2/3] arm:add bitrev.h file to support rbit instruction
Message-ID: <20141114095205.GF4042@n2100.arm.linux.org.uk>
References: <20141030135749.GE32589@arm.com>
 <35FD53F367049845BC99AC72306C23D103E010D18272@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18273@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18275@CNBJMBX05.corpusers.net>
 <20141113235322.GC4042@n2100.arm.linux.org.uk>
 <1415923530.4223.17.camel@perches.com>
 <20141114001720.GD4042@n2100.arm.linux.org.uk>
 <1415925943.4141.1.camel@perches.com>
 <20141114011832.GE4042@n2100.arm.linux.org.uk>
 <1415928394.4141.3.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415928394.4141.3.camel@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 05:26:34PM -0800, Joe Perches wrote:
> On Fri, 2014-11-14 at 01:18 +0000, Russell King - ARM Linux wrote:
> > On Thu, Nov 13, 2014 at 04:45:43PM -0800, Joe Perches wrote:
> > > I think you shouldn't apply these patches or updated
> > > ones either until all the current uses are converted.
> > 
> > Where are the dependencies mentioned?
> 
> I mentioned it when these patches (which are not
> mine btw), were submitted the second time.

Yes, I'm well aware that the author of the ARM patches are Yalin Wang.

> https://lkml.org/lkml/2014/10/27/69
> 
> > How do I get to know when all
> > the dependencies are met?
> 
> No idea.
> 
> > Who is tracking the dependencies?
> 
> Not me.

Right, what that means is that no one is doing that.  What you've also
said in this thread now is that the ARM patches should not be applied
until all the other users are converted.  As those patches are going via
other trees, that means the ARM patches can only be applied _after_ the
next merge window _if_ all maintainers pick up the previous set.

As I'm not tracking the status of what other maintainers do, I'm simply
going to avoid applying these patches until after the next merge window
and hope that the other maintainers pick the dependent patches up and get
them in during the next merge window.  If not, I guess we'll see compile
breakage.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
