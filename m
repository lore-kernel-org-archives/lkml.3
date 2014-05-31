Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935171AbaEaDhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 23:37:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935134AbaEaDhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 23:37:13 -0400
Date: Fri, 30 May 2014 20:37:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sune =?iso-8859-1?Q?M=F8lgaard?= <sune@molgaard.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Summarizing deprecations
Message-ID: <20140531033711.GA1697@kroah.com>
References: <53893895.3040202@molgaard.org>
 <20140531022151.GA32348@kroah.com>
 <538944E2.2070706@molgaard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <538944E2.2070706@molgaard.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2014 at 04:56:34AM +0200, Sune Mølgaard wrote:
> Hi Greg, and thank you for correcting me!
> 
> Greg KH wrote:
> [snip]
> > Not true at all.
> 
> I trust you to know enough to be correct, but as we speak, I have at
> least 3 pieces of hardware, whose (out-of-tree) drivers regularly fail
> to compile come a new rc1. I usually manage to find or create a patch,
> but the breakage is usually due to months-old deprecations of system
> calls that finally (and understandably) where removed in those new rc1s.

What specific drivers are they?  Why are the drivers out of the tree?
I'll gladly add them to the drivers/staging/ directory as long as the
license of them allows me to do so.  That way api changes will happen
automatically for them.

> My experience is that vendors are not only blissfully aware of such
> changes until removal, but will generally only support final kernel
> versions - even if the deprecation/removal was announced several
> versions earlier.

In other words, no matter what we do, things outside of the kernel tree
will break.  This is on the vendor, not us now.  They know where to find
us, we have no idea who they are.

> > Have you looked at the kernel backport group and scripts?  They do much
> > of this already, automatically, backporting newer drivers to older
> > kernel versions for people stuck at those releases.  I think what you
> > want is already completed...
> 
> Whereas I thank you for those pointers, I now realize that I failed to
> mention a few crucial details.
> 
> My "knee-jerk" comment above was based on a rather important point that
> I failed to mention, namely that what I was talking about was drivers
> employing closed binary blobs, obviously and naturally precluding them
> from mainlining.

Then they are on their own as they are violating our license when
redistributing such a monstrosity.  They know the issues involved, and
are willing to pay the price to do such a thing.  There's nothing we can
do about them, sorry.  Go bug the vendor, not us.

And buy better hardware next time :)

greg k-h
