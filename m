Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbaDDNod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 09:44:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbaDDNob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 09:44:31 -0400
Date: Fri, 4 Apr 2014 15:44:29 +0200
From: Jan Kara <jack@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [GIT PULL] ext4 changes for 3.15
Message-ID: <20140404134429.GB26806@quack.suse.cz>
References: <20140403191558.GA8745@thunk.org>
 <CA+55aFxoA-iDdmbbgmJiYVvskrtca5aGgUAW=3CR47rM9NEMLA@mail.gmail.com>
 <20140404035308.GC2525@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140404035308.GC2525@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 03-04-14 23:53:08, Ted Tso wrote:
> On Thu, Apr 03, 2014 at 12:39:42PM -0700, Linus Torvalds wrote:
> > Btw, since I'm planning on getting to the filesystem pulls later today
> > (or perhaps tomorrow), I wanted to check: are you ok with the ext4
> > parts of the cross-rename patches from Miklos?
> > 
> > They are currently at
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git cross-rename
> > 
> > in case you want to refresh your memory.
> 
> I've pulled in the cross-rename branch to my test branch and run a set
> of tests, and it passes.  Unfortunately I don't believe Miklos
> contributed tests for renameat(2) to xfstests, so we don't have any
> on-point testing of renameat() and cross-rename, but it's at least not
> triggering any failures on the existing tests.
  Actually Miklos has contributed xfstests tests. I'm not sure if they were
merged but I've seen them flying by.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
