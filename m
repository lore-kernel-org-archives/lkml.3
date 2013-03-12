Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab3CLEQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 00:16:48 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:52738 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab3CLEQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 00:16:46 -0400
Date: Tue, 12 Mar 2013 00:16:41 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: James Morris <jmorris@namei.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: unneeded merge in the security tree
Message-ID: <20130312041641.GE18595@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	James Morris <jmorris@namei.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20130312100950.e45ef0e721492ff0d5fd7c8d@canb.auug.org.au>
 <alpine.LRH.2.02.1303121510270.25612@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1303121510270.25612@tundra.namei.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 03:10:53PM +1100, James Morris wrote:
> On Tue, 12 Mar 2013, Stephen Rothwell wrote:
> > The top commit in the security tree today is a merge of v3.9-rc2.  This
> > is a completely unnecessary merge as the tree before the merge was a
> > subset of v3.9-rc1 and so if the merge had been done using anything but
> > the tag, it would have just been a fast forward.  I know that this is now
> > deliberate behaviour on git's behalf, but isn't there some way we can
> > make this easier on maintainers who are just really just trying to pick a
> > new starting point for their trees after a release?  (at least I assume
> > that is what James was trying to do)
> 
> Yes, and I was merging to a tag as required by Linus.

Why not just force the head of the security tree to be v3.9-rc2?  Then
you don't end up creating a completely unnecessary merge commit, and
users who were at the previous head of the security tree will
experience a fast forward when they pull your new head.

	     	  	       	    	      	  - Ted
