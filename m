Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab3CLNZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 09:25:19 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:52833 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab3CLNZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 09:25:17 -0400
Date: Tue, 12 Mar 2013 09:25:10 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Morris <jmorris@namei.org>, Linus <torvalds@linux-foundation.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: unneeded merge in the security tree
Message-ID: <20130312132510.GH18595@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	James Morris <jmorris@namei.org>,
	Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20130312100950.e45ef0e721492ff0d5fd7c8d@canb.auug.org.au>
 <alpine.LRH.2.02.1303121510270.25612@tundra.namei.org>
 <20130312041641.GE18595@thunk.org>
 <20130312161823.86ea101fc4e45285b205817f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312161823.86ea101fc4e45285b205817f@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 04:18:23PM +1100, Stephen Rothwell wrote:
> Well, you used to be able to merge a tag and it would just fast forward
> if possible.  That was changed (for good reason), but now gives us this
> outcome.   Also, "git merge --ff" does not override that behaviour, but
> "git merge --ff-only" does.  Also, of course, if (say) origin/master had
> been v3.9-rc2, then "git merge origin/master" would have also just done a
> fast forward.

I'm probably old school (or maybe wacky school --- who knows :-), but
what I usually do is something like this:

git branch -a --contains HEAD   # make sure the HEAD pointer is
git tag --contains HEAD         # include where I think it should be
git reset --hard v3.9-rc2

Yeah, it's more key strokes than "git merge --ff-only v3.9-rc2", but I
can type the above faster because they're finger macros for me.  :-)

					- Ted
