Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab3HUFYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 01:24:47 -0400
Received: from 1wt.eu ([62.212.114.60]:35454 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab3HUFYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 01:24:46 -0400
Date: Wed, 21 Aug 2013 07:24:24 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Guenter Roeck <linux@roeck-us.net>, Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposed stable release changes
Message-ID: <20130821052424.GE16424@1wt.eu>
References: <20130820224032.GA20491@kroah.com> <20130820225815.GD16424@1wt.eu> <20130820231232.GB703@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820231232.GB703@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 04:12:32PM -0700, Greg KH wrote:
> On Wed, Aug 21, 2013 at 12:58:15AM +0200, Willy Tarreau wrote:
> > Hi Greg,
> > 
> > On Tue, Aug 20, 2013 at 03:40:32PM -0700, Greg KH wrote:
> > > Hi all,
> > > 
> > > Given that I had to just revert a patch in the recent stable releases
> > > that didn't get enough time to "bake" in Linus's tree (or in -next), I
> > > figured it was worth discussing some possible changes with how "fast" I
> > > pick up patches for stable releases.
> > > 
> > > So, how about this proposal:
> > > 
> > > - I will wait for a -rc to come out with the patch in it before putting
> > >   it into a stable release, unless:
> > > 	- the maintainer ACKs it, or sends it directly (like DaveM does
> > > 	  for networking patches)
> > > 	- I have seen enough discussion about a patch to show that it
> > > 	  really does fix something / is good / doesn't cause problems.
> > > 	- obviously safe, i.e. "add a device id" type thing.
> > > 
> > > Given that we have -rc releases every week, except for the initial -rc1
> > > release, I don't think this will really cause any major delays.
> > 
> > In the last discussion you initiated on the subject, I proposed something
> > even more conservative which was the same as above except instead of
> > "wait for a -rc", it was "wait for rc1 after a full release containing
> > the patch", unless one of the conditions you proposed, or another one
> > which would be a tag "urgent" or something like this in the patch.
> 
> Waiting 3 months is too long, in my opinion, sorry.

I meant only for the non-important ones. Their authors will qualify the
ones that are important and must not wait. The same way as now many patches
are correctly tagged "cc: stable", I suspect that we could end up with maybe
80% of patches tagged as "must not wait", and the remaining 20% would indeed
wait up to 3 months, but if their authors think they should wait maybe we
should trust them.

Willy

