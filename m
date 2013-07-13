Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043Ab3GMBbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 21:31:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757984Ab3GMBbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 21:31:14 -0400
Date: Fri, 12 Jul 2013 18:32:11 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        ksummit-2013-discuss@lists.linux-foundation.org,
        torvalds@linux-foundation.org
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
Message-ID: <20130713013211.GA22726@kroah.com>
References: <20130711214830.611455274@linuxfoundation.org>
 <20130712025745.GA24086@tuxdriver.com>
 <20130712033430.GA3798@kroah.com>
 <2354417.lhslZaMQMB@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2354417.lhslZaMQMB@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 13, 2013 at 02:24:07AM +0200, Rafael J. Wysocki wrote:
> On Thursday, July 11, 2013 08:34:30 PM Greg Kroah-Hartman wrote:
> > On Thu, Jul 11, 2013 at 10:57:46PM -0400, John W. Linville wrote:
> > > On Thu, Jul 11, 2013 at 08:50:23PM -0400, Theodore Ts'o wrote:
> > > 
> > > > In any case, I've been very conservative in _not_ pushing bug fixes to
> > > > Linus after -rc3 (unless they are fixing a regression or the bug fix
> > > > is super-serious); I'd much rather have them cook in the ext4 tree
> > > > where they can get a lot more testing (a full regression test run for
> > > > ext4 takes over 24 hours), and for people trying out linux-next.
> > > > 
> > > > Maybe the pendulum has swung too far in the direction of holding back
> > > > changes and trying to avoid the risk of introducing regressions;
> > > > perhaps this would be a good topic to discuss at the Kernel Summit.
> > > 
> > > Yes, there does seem to be a certain ebb and flow as to how strict
> > > the rules are about what should go into stable, what fixes are "good
> > > enough" for a given -rc, how tight those rule are in -rc2 vs in -rc6,
> > > etc.  If nothing else, a good repetitive flogging and a restatement of
> > > the One True Way to handle these things might be worthwhile once again...
> > 
> > The rules are documented in stable_kernel_rules.txt for what I will
> > accept.
> > 
> > I have been beating on maintainers for 8 years now to actually mark
> > patches for stable, and only this past year have I finally seen people
> > do it (we FINALLY got SCSI patches marked for stable in this merge
> > window!!!)  So now that maintainers are finally realizing that they need
> > to mark patches, I'll be pushing back harder on the patches that they do
> > submit, because the distros are rightfully pushing back on me for
> > accepting things that are outside of the stable_kernel_rules.txt
> > guidelines.
> 
> I don't quite understand why they are pushing back on you rather than on
> the maintainers who have marked the commits they have problems with for
> -stable.  Why are you supposed to play the role of the gatekeeper here?
> Can't maintainers be held responsible for the commits they mark for -stable in
> the same way as they are responsible for the commits they push to Linus?

Because I'm an easy big target and people are lazy.

> Also, I don't really think that the distros have problems with fixes that are
> simple and provably correct, even though the problems they fix don't seem to be
> "serious enough" for -stable.  They rather have problems with subtle changes
> whose impact is difficult to estimate by inspection and you're not going to be
> pushing back on those anyway (exactly because their impact is difficult to
> estimate).

I know that, you know that, but managers who see tons of kernel patches
just get scared :)

> > If you look on the stable@vger list, I've already rejected 3 today and
> > asked about the huge 21 powerpc patches.  Sure, it's not a lot, when
> > staring down 174 more to go, but it's a start...
> 
> And 2 of those 3 rejected were mine and for 1 of them I actually had a very
> specific reason to mark it for -stable as I told you: It fixed a breakage
> introduced inadvertently in 3.10 and I thought it would be good to reduce
> the exposure of that breakage by fixing it in 3.10.1 as well as in 3.11-rc.

There was no real breakage, that is why I rejected it.

greg k-h
