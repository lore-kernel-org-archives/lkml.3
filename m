Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbaDDUXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 16:23:37 -0400
Received: from imap.thunk.org ([74.207.234.97]:50137 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbaDDUXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 16:23:35 -0400
Date: Fri, 4 Apr 2014 16:23:23 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [GIT PULL] ext4 changes for 3.15
Message-ID: <20140404202323.GB10275@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <20140403191558.GA8745@thunk.org>
 <CA+55aFxoA-iDdmbbgmJiYVvskrtca5aGgUAW=3CR47rM9NEMLA@mail.gmail.com>
 <20140404035308.GC2525@thunk.org>
 <20140404134429.GB26806@quack.suse.cz>
 <CAJfpegsJd9d8NTmwozJ+u_ZS-SnUwAQFwAne6P1KqG=VZeZSTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegsJd9d8NTmwozJ+u_ZS-SnUwAQFwAne6P1KqG=VZeZSTA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah yes, I had forgotten that you had sent those patches, thanks.

It looks like that since you worded it as "just RFC for now since they
aren't in 3.15 yet", the xfstests folks never actually accepted your
changes into xfstests, and so I never picked it up.

For future reference, the tests for COLLAPSE_RANGE and ZERO_RANGE were
accepted into xfstests well before the merge window opened, and that
was awfully convenience since we could pull the latest from the
xfstests.git tree and do automated testing while those patches were in
the ext4 and xfs trees.

So feel free to be a bit more insistent about asking for your xfstests
to be merged upstream; you don't have to wait until the changes reach
mainline.  If it's clear that the patches are going to be accepted,
and they are in the subsystem trees, that's a fine time to push to get
the changes into xfstests.

Cheers,

						- Ted
