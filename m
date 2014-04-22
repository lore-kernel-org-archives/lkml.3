Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaDVBfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 21:35:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48065 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaDVBe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 21:34:59 -0400
Date: Tue, 22 Apr 2014 02:34:56 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Theodore Ts'o" <tytso@mit.edu>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the vfs tree with Linus' and te ext4
 trees
Message-ID: <20140422013456.GT18016@ZenIV.linux.org.uk>
References: <20140422110459.ab3af554dd61297c61a568c2@canb.auug.org.au>
 <20140422011918.GA9441@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422011918.GA9441@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 09:19:19PM -0400, Theodore Ts'o wrote:
> On Tue, Apr 22, 2014 at 11:04:59AM +1000, Stephen Rothwell wrote:
> > 
> > Today's linux-next merge of the vfs tree got a conflict in
> > fs/ext4/extents.c between rebased versions of commits from Linus' and the
> > ext4 trees and the same commits from the vfs tree.
> > 
> > I fixed it up (I just used the version from Linus' and the ext4 trees)
> > and can carry the fix as necessary (no action is required).
> > 
> > Al, this is why I asked you about checking with Ted about his tree being
> > rebased after you merged it into yours ...
> 
> Sorry, Al, I hadn't been aware you wanted to carrying some of these
> changes.  I had mentioned that I was planning on carrying them in the
> ext4 tree and including them for 3.15 because some of them were fixing
> bugs that had been introduced in the merge window.  Since no one
> objected, I thought everyone was on the same page about that plan.

*rechecks*
I have Cc'd you on this:

<quote>
Subject: Re: linus-next stats (Re: Linux 3.15-rc1 out, merge window closed)
Message-ID: <20140417203412.GB18016@ZenIV.linux.org.uk>
[snip]
one non-trivial in ext4 that I've dealt with by merging a piece of ext4
branch up to the relevant point.  As long as ext4.git#dev isn't rebased,
everything should remain fine, when/if it does I'll just redo that merge.
BTW, ext4 side of that thing is *still* not quite right - playing with
rlimit allows one to smuggle an unaligned write past that check...
</quote>

I'll rebase that thing...
