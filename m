Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab3GLFPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 01:15:10 -0400
Received: from 1wt.eu ([62.212.114.60]:34530 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884Ab3GLFPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 01:15:08 -0400
Date: Fri, 12 Jul 2013 07:14:51 +0200
From: Willy Tarreau <w@1wt.eu>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        ksummit-2013-discuss@lists.linux-foundation.org
Subject: Re: When to push bug fixes to mainline
Message-ID: <20130712051451.GC25815@1wt.eu>
References: <20130711214830.611455274@linuxfoundation.org> <20130712005023.GB31005@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130712005023.GB31005@thunk.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 08:50:23PM -0400, Theodore Ts'o wrote:
> On Thu, Jul 11, 2013 at 03:01:17PM -0700, Greg Kroah-Hartman wrote:
> > <rant>
> >   I'm sitting on top of over 170 more patches that have been marked for
> >   the stable releases right now that are not included in this set of
> >   releases.  The fact that there are this many patches for stable stuff
> >   that are waiting to be merged through the main -rc1 merge window cycle
> >   is worrying to me.
> > 
> >   Why are subsystem maintainers holding on to fixes that are
> >   _supposedly_ affecting all users?  I mean, 21 powerpc core changes
> >   that I don't see until a -rc1 merge?  It's as if developers don't
> >   expect people to use a .0 release and are relying on me to get the
> >   fixes they have burried in their trees out to users.  That's not that
> >   nice.  6 "core" iscsi-target fixes?  That's the sign of either a
> >   broken subsystem maintainer, or a lack of understanding what the
> >   normal -rc kernel releases are supposed to be for.
> 
> At least at one point in the past, the rule that Linus had laid down
> after discussing things at Kernel Summits was after -rc2, or maybe
> -rc3 at the latest, the ***only*** fixes that should be sent to Linus
> would be for regression fixes or for really serious data integrity
> issues.  The concern was that people were pushing bug fixes in -rc5 or
> -rc6 that were in some cases causing regressions.

And maybe in the end, having 1/10 patch cause a regression is not *that*
dramatic, and probably less than not fixing the 9 other bugs. In one case
we rely on -stable to merge the 10 fixes, and on the other case we'd rely
on -stable to just revert one of them.

Also there has never been any promise of very stable mainline kernels,
and at the same time the rules for getting patches in -stable are strict.
So this means that most fixes should probably be pushed to mainline anyway
otherwise we risk never to get them, which means lower overall quality.

Just my two cents,
Willy

