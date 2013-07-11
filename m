Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab3GKWo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:44:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398Ab3GKWo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:44:56 -0400
Date: Thu, 11 Jul 2013 15:44:55 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130711224455.GA17222@kroah.com>
References: <20130711214830.611455274@linuxfoundation.org>
 <20130711222935.GA11340@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130711222935.GA11340@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 06:29:35PM -0400, Dave Jones wrote:
> On Thu, Jul 11, 2013 at 03:01:17PM -0700, Greg Kroah-Hartman wrote:
>  > <rant>
>  >   I'm sitting on top of over 170 more patches that have been marked for
>  >   the stable releases right now that are not included in this set of
>  >   releases.  The fact that there are this many patches for stable stuff
>  >   that are waiting to be merged through the main -rc1 merge window cycle
>  >   is worrying to me.
>  > 
>  >   Why are subsystem maintainers holding on to fixes that are
>  >   _supposedly_ affecting all users?  I mean, 21 powerpc core changes
>  >   that I don't see until a -rc1 merge?  It's as if developers don't
>  >   expect people to use a .0 release and are relying on me to get the
>  >   fixes they have burried in their trees out to users.  That's not that
>  >   nice.  6 "core" iscsi-target fixes?  That's the sign of either a
>  >   broken subsystem maintainer, or a lack of understanding what the
>  >   normal -rc kernel releases are supposed to be for.
> 
> I get the impression as soon as we hit -rc1, some maintainers immediately
> go into "OH SHIT, I CAN'T SEND PATCHES OR LINUS WILL SHOUT AT ME" mode.

I agree.  But it seems that I need to now start shouting at them :(

> And the later in -rc we are, the more reluctant some people seem to be
> at sending stuff. Which, for slowing things down as we go through -rc is great,
> but not so much when people stop sending _everything_ and start thinking
> "I'll just get it in stable in a few weeks".

The 20 powerpc patches are proof of that.  I'm amost considering just
not applying them at all, as obviously they weren't all that important.

> For .10 I had to start making a list of "shit that's broken that there's
> an outstanding patch for" and nagging people to send them week after week.
> Every time I reported a new bug I'd hit, I'd have to explain I wasn't running
> Linus' tree because there was so much other crap I had to carry just to
> get things to a baseline of stability before starting tests.
> 
> By rc7 things got a lot better, but if we have fixes sitting around in
> git trees for weeks on end with no progress, that kinda sucks.

We have patches with assigned CVE numbers sitting in subsystem trees
that didn't hit Linus's tree until this merge window.  Now granted, I
don't necessarily agree that they were worth CVEs, but really, holding
them off from being merged for 2 months or so is really bad, and means
that something seems a bit broken with our development process.

And thanks for nagging people, I really appreciate it, sad it's
necessary.

greg k-h
