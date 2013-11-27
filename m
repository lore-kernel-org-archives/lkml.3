Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab3K0DVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 22:21:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41379 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab3K0DVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 22:21:14 -0500
Date: Tue, 26 Nov 2013 19:22:01 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add HSI subsystem
Message-ID: <20131127032201.GB22475@kroah.com>
References: <1385403450-18018-1-git-send-email-sre@debian.org>
 <CACRpkdYSXDAwS1mxLtUL7qpHkfD1efo1QF0OMKS-YHKM-689Kw@mail.gmail.com>
 <20131127001241.GA20111@earth.universe>
 <20131127001909.GB22610@kroah.com>
 <20131127012600.GA23214@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131127012600.GA23214@earth.universe>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 02:26:02AM +0100, Sebastian Reichel wrote:
> On Tue, Nov 26, 2013 at 04:19:09PM -0800, Greg Kroah-Hartman wrote:
> > On Wed, Nov 27, 2013 at 01:12:42AM +0100, Sebastian Reichel wrote:
> > > On Wed, Nov 27, 2013 at 12:30:48AM +0100, Linus Walleij wrote:
> > > > > +M:     Sebastian Reichel <sre@debian.org>
> > > > > +S:     Maintained
> > > > > +F:     Documentation/hsi/
> > > > > +F:     drivers/hsi/
> > > > > +F:     include/linux/hsi/
> > > > > +F:     include/uapi/linux/hsi/
> > > > 
> > > > Don't add directories that do not exist (yet).
> > > 
> > > Sorry, that was not my intention. The documentation path was
> > > supposed to be "Documentation/ABI/testing/sysfs-bus-hsi". The
> > > other directories should exist. I will send an updated patch.
> > > 
> > > Am I right, that this should go through Greg?
> > 
> > Why me?
> 
> As far as i know the change is supposed to go through the
> subsystem's git tree by default, but drivers/hsi is currently
> orphaned.
> 
> You were suggested by scripts/get_maintainer.pl, because you
> did some commits in drivers/hsi. You also maintain drivers/core
> and drivers/misc, so I thought you would be a good entry point.

Ok, if you have no other conduit, I'll be glad to do that for you, I do
it for lots of other "misc" driver subsystems like this.

So, feel free to resend this, with the correct include line, and I'll be
glad to queue it up.

thanks,

greg k-h
