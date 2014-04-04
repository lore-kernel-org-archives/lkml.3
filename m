Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbaDDDxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 23:53:20 -0400
Received: from imap.thunk.org ([74.207.234.97]:49764 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbaDDDxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 23:53:13 -0400
Date: Thu, 3 Apr 2014 23:53:08 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [GIT PULL] ext4 changes for 3.15
Message-ID: <20140404035308.GC2525@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <20140403191558.GA8745@thunk.org>
 <CA+55aFxoA-iDdmbbgmJiYVvskrtca5aGgUAW=3CR47rM9NEMLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxoA-iDdmbbgmJiYVvskrtca5aGgUAW=3CR47rM9NEMLA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 12:39:42PM -0700, Linus Torvalds wrote:
> Btw, since I'm planning on getting to the filesystem pulls later today
> (or perhaps tomorrow), I wanted to check: are you ok with the ext4
> parts of the cross-rename patches from Miklos?
> 
> They are currently at
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git cross-rename
> 
> in case you want to refresh your memory.

I've pulled in the cross-rename branch to my test branch and run a set
of tests, and it passes.  Unfortunately I don't believe Miklos
contributed tests for renameat(2) to xfstests, so we don't have any
on-point testing of renameat() and cross-rename, but it's at least not
triggering any failures on the existing tests.

I've also reviewed the patches again, so:

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
