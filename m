Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724Ab3HBD3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 23:29:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60920 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab3HBD3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 23:29:17 -0400
Date: Fri, 2 Aug 2013 11:30:33 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-usb <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Add separate section for USB NETWORKING
 DRIVERS
Message-ID: <20130802033033.GA2658@kroah.com>
References: <1375316960686@kroah.org>
 <1375343328.2034.34.camel@joe-AO722>
 <20130801075656.GA8074@kroah.com>
 <1375344595.2034.38.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375344595.2034.38.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 01:09:55AM -0700, Joe Perches wrote:
> On Thu, 2013-08-01 at 15:56 +0800, Greg KH wrote:
> > On Thu, Aug 01, 2013 at 12:48:48AM -0700, Joe Perches wrote:
> > > There are several drivers in drivers/net/usb/ that
> > > do not have specific MAINTAINERS that should have
> > > emails forwarded to the linux-usb mailing list.
> 
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> []
> > > +USB NETWORKING DRIVERS
> > > +L:	linux-usb@vger.kernel.org
> > > +S:	Odd Fixes
> > > +F:	drivers/net/usb/
> > 
> > But netdev is the one that applies these patches, not linux-usb, so this
> > isn't correct either.
> > 
> > sorry,
> 
> Lots of "maintainers" don't apply patches.

I have no idea what you are meaning here.

> This is simply a means to forward patches to
> relevant lists that may have reviewers that care
> about changes to certain files.
> 
> You suggested that linux-usb should get copies
> of these patches.

Yes, they should, for review, but so should netdev.

> These files are not marked as "Maintained", just
> "Odd fixes".  I suppose these could be marked
> "Orphan" instead.
> 
> You have a suggestion otherwise?

Add netdev to the L: list as well.

thanks,

greg k-h
