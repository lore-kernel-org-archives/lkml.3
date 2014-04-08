Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbaDHNrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 09:47:53 -0400
Received: from imap.thunk.org ([74.207.234.97]:51616 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756976AbaDHNrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 09:47:48 -0400
Date: Tue, 8 Apr 2014 09:47:40 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [GIT PULL] ext4 changes for 3.15
Message-ID: <20140408134740.GB28822@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
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
 <20140404234358.GE10275@thunk.org>
 <CAJfpegv_Ng1cXbpCqicG4e3UdGK3uiDtVB4KzfRQOhDq_uhZOw@mail.gmail.com>
 <20140407140745.GA8855@thunk.org>
 <CAMuHMdVHyAJwJv5nh+nQUOQJk6=2+Rr+pEqAZPgJUsA7A9A3hQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVHyAJwJv5nh+nQUOQJk6=2+Rr+pEqAZPgJUsA7A9A3hQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 10:25:30PM +0200, Geert Uytterhoeven wrote:
> > maintainers would have no idea that a new syscall has been added.
> 
> If i386 has the new syscall, scripts/checksyscalls.sh will catch it and
> inform us about it during our next kernel build.
> 
> If you add it to x86_64 only, bad luck for anyone else ;-)

Maybe we should change scripts/checksyscalls.sh to check the x86_64
list of syscalls, and not i386?

It's been a long time since "all the world's an i386" --- these days,
it's "all the world's an x86_64".  :-)

						- Ted

"Thou shalt foreswear, renounce, and abjure the vile heresy which
claimeth that ``All the world's a VAX'', and have no commerce with the
benighted heathens who cling to this barbarous belief, that the days
of thy program may be long even though the days of thy current machine
be short."  -- The Ten Commandments for C Programmers

- http://www.lysator.liu.se/c/ten-commandments.html
