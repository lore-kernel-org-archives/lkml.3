Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab3GLHcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 03:32:53 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58874 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753027Ab3GLHcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 03:32:51 -0400
Message-ID: <1373614367.2057.5.camel@dabdike>
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        ksummit-2013-discuss@lists.linux-foundation.org,
        torvalds@linux-foundation.org
Date: Fri, 12 Jul 2013 08:32:47 +0100
In-Reply-To: <20130712033430.GA3798@kroah.com>
References: <20130711214830.611455274@linuxfoundation.org>
	 <20130712005023.GB31005@thunk.org> <20130712025745.GA24086@tuxdriver.com>
	 <20130712033430.GA3798@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 20:34 -0700, Greg Kroah-Hartman wrote:
> On Thu, Jul 11, 2013 at 10:57:46PM -0400, John W. Linville wrote:
> > On Thu, Jul 11, 2013 at 08:50:23PM -0400, Theodore Ts'o wrote:
> > 
> > > In any case, I've been very conservative in _not_ pushing bug fixes to
> > > Linus after -rc3 (unless they are fixing a regression or the bug fix
> > > is super-serious); I'd much rather have them cook in the ext4 tree
> > > where they can get a lot more testing (a full regression test run for
> > > ext4 takes over 24 hours), and for people trying out linux-next.
> > > 
> > > Maybe the pendulum has swung too far in the direction of holding back
> > > changes and trying to avoid the risk of introducing regressions;
> > > perhaps this would be a good topic to discuss at the Kernel Summit.
> > 
> > Yes, there does seem to be a certain ebb and flow as to how strict
> > the rules are about what should go into stable, what fixes are "good
> > enough" for a given -rc, how tight those rule are in -rc2 vs in -rc6,
> > etc.  If nothing else, a good repetitive flogging and a restatement of
> > the One True Way to handle these things might be worthwhile once again...
> 
> The rules are documented in stable_kernel_rules.txt for what I will
> accept.
> 
> I have been beating on maintainers for 8 years now to actually mark
> patches for stable, and only this past year have I finally seen people
> do it (we FINALLY got SCSI patches marked for stable in this merge
> window!!!)

What do you mean FINALLY? There've been SCSI patches marked for stable
in every other merge window as well.  The whole reason I ran the stable
patch tracker before you took it over was so I could get the Cc: to
stable stuff working.

James

>   So now that maintainers are finally realizing that they need
> to mark patches, I'll be pushing back harder on the patches that they do
> submit, because the distros are rightfully pushing back on me for
> accepting things that are outside of the stable_kernel_rules.txt
> guidelines.
> 
> If you look on the stable@vger list, I've already rejected 3 today and
> asked about the huge 21 powerpc patches.  Sure, it's not a lot, when
> staring down 174 more to go, but it's a start...
> 
> greg k-h
> _______________________________________________
> Ksummit-2013-discuss mailing list
> Ksummit-2013-discuss@lists.linuxfoundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/ksummit-2013-discuss



