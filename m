Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab3GLDdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 23:33:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab3GLDdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 23:33:35 -0400
Date: Thu, 11 Jul 2013 20:34:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org,
        ksummit-2013-discuss@lists.linux-foundation.org
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
Message-ID: <20130712033430.GA3798@kroah.com>
References: <20130711214830.611455274@linuxfoundation.org>
 <20130712005023.GB31005@thunk.org>
 <20130712025745.GA24086@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130712025745.GA24086@tuxdriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 10:57:46PM -0400, John W. Linville wrote:
> On Thu, Jul 11, 2013 at 08:50:23PM -0400, Theodore Ts'o wrote:
> 
> > In any case, I've been very conservative in _not_ pushing bug fixes to
> > Linus after -rc3 (unless they are fixing a regression or the bug fix
> > is super-serious); I'd much rather have them cook in the ext4 tree
> > where they can get a lot more testing (a full regression test run for
> > ext4 takes over 24 hours), and for people trying out linux-next.
> > 
> > Maybe the pendulum has swung too far in the direction of holding back
> > changes and trying to avoid the risk of introducing regressions;
> > perhaps this would be a good topic to discuss at the Kernel Summit.
> 
> Yes, there does seem to be a certain ebb and flow as to how strict
> the rules are about what should go into stable, what fixes are "good
> enough" for a given -rc, how tight those rule are in -rc2 vs in -rc6,
> etc.  If nothing else, a good repetitive flogging and a restatement of
> the One True Way to handle these things might be worthwhile once again...

The rules are documented in stable_kernel_rules.txt for what I will
accept.

I have been beating on maintainers for 8 years now to actually mark
patches for stable, and only this past year have I finally seen people
do it (we FINALLY got SCSI patches marked for stable in this merge
window!!!)  So now that maintainers are finally realizing that they need
to mark patches, I'll be pushing back harder on the patches that they do
submit, because the distros are rightfully pushing back on me for
accepting things that are outside of the stable_kernel_rules.txt
guidelines.

If you look on the stable@vger list, I've already rejected 3 today and
asked about the huge 21 powerpc patches.  Sure, it's not a lot, when
staring down 174 more to go, but it's a start...

greg k-h
