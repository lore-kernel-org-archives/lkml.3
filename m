Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab3JRQUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 12:20:37 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:46826 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab3JRQUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 12:20:36 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+u+Yl56tFHDD5Af7Ysz/uClMel2Vh4VZc=
Date: Fri, 18 Oct 2013 12:20:22 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Kevin Hilman <khilman@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] ARM: kirkwood: remove lagacy clk workarounds
Message-ID: <20131018162022.GM22434@titan.lakedaemon.net>
References: <1382097253-15624-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20131018144741.GL22434@titan.lakedaemon.net>
 <20131018161743.GA29595@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131018161743.GA29595@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 01:17:44PM -0300, Ezequiel Garcia wrote:
> On Fri, Oct 18, 2013 at 10:47:41AM -0400, Jason Cooper wrote:
> > On Fri, Oct 18, 2013 at 01:54:13PM +0200, Sebastian Hesselbarth wrote:
> > > With legacy devices converted to DT and a proper ethernet MAC
> > > workaround, we can now remove the clk workarounds for legacy
> > > devices. While at it, also cleanup the list of includes.
> > > 
> > > Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> > > ---
> > > As a follow-up patch for latest mvebu PRs, this patch is based on
> > >  git://git.infradead.org/linux-mvebu.git tags/soc-3.13-2
> > > 
> > > Cc: Jason Cooper <jason@lakedaemon.net>
> > > Cc: Andrew Lunn <andrew@lunn.ch>
> > > Cc: Russell King <linux@arm.linux.org.uk>
> > > Cc: Kevin Hilman <khilman@linaro.org>
> > > Cc: linux-arm-kernel@lists.infradead.org
> > > Cc: linux-kernel@vger.kernel.org
> > > ---
> > >  arch/arm/mach-kirkwood/board-dt.c |   42 ++----------------------------------
> > >  1 files changed, 3 insertions(+), 39 deletions(-)
> > 
> > Applied to mvebu/soc
> > 
> 
> Weird: I've tried to do this clean-up myself and my usual tests with network
> built as a module failed somehow. Maybe I missed something and did something
> stupid?
> 
> Of course, I'll re-try and let you all know...

Please do.  You can try mvebu/for-next now. It has this and everything
else we need to test for the merge window.

thx,

Jason.
