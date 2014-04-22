Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbaDVBT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 21:19:26 -0400
Received: from imap.thunk.org ([74.207.234.97]:52674 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbaDVBTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 21:19:22 -0400
Date: Mon, 21 Apr 2014 21:19:19 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the vfs tree with Linus' and te ext4
 trees
Message-ID: <20140422011918.GA9441@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Al Viro <viro@ZenIV.linux.org.uk>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20140422110459.ab3af554dd61297c61a568c2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422110459.ab3af554dd61297c61a568c2@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 11:04:59AM +1000, Stephen Rothwell wrote:
> 
> Today's linux-next merge of the vfs tree got a conflict in
> fs/ext4/extents.c between rebased versions of commits from Linus' and the
> ext4 trees and the same commits from the vfs tree.
> 
> I fixed it up (I just used the version from Linus' and the ext4 trees)
> and can carry the fix as necessary (no action is required).
> 
> Al, this is why I asked you about checking with Ted about his tree being
> rebased after you merged it into yours ...

Sorry, Al, I hadn't been aware you wanted to carrying some of these
changes.  I had mentioned that I was planning on carrying them in the
ext4 tree and including them for 3.15 because some of them were fixing
bugs that had been introduced in the merge window.  Since no one
objected, I thought everyone was on the same page about that plan.

	    	    	     	    - Ted
