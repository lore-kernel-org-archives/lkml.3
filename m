Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaHDLsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:48:17 -0400
Received: from imap.thunk.org ([74.207.234.97]:43129 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbaHDLsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:48:15 -0400
Date: Mon, 4 Aug 2014 07:48:11 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Airlie <airlied@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Nicholas Krause <xerofoify@gmail.com>,
        udovdh@xs4all.nl,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] v4l2: Change call of function in videobuf2-core.c
Message-ID: <20140804114811.GZ24826@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dave Airlie <airlied@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>,
	Nicholas Krause <xerofoify@gmail.com>, udovdh@xs4all.nl,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1407122751-30689-1-git-send-email-xerofoify@gmail.com>
 <53DF1412.9010506@xs4all.nl>
 <CAPM=9tx-pkadgGJ98BuBHpkj=bvo+8ks76ro7UE5d=xWB4EN0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9tx-pkadgGJ98BuBHpkj=bvo+8ks76ro7UE5d=xWB4EN0A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 03:38:20PM +1000, Dave Airlie wrote:
> 
> Nick has decided he wants to be a kernel developer, a laudable goal.
> 
> He however has decided not to take any advice given to me by a number of other
> kernel developers on how to work on the kernel. So instead he sends random
> broken patches to random subsystems in the hope that one will slip past a sleepy
> maintainer and end up in the kernel.

So far, he has tried to do this with the ext4, btrfs, scsi, and usb
subsystems.  I'm probably missing a few.  I suspect he's jumping
around to different subsystems hoping to find one where his reputation
hasn't been blackened yet by his refusal to deeply understand kernel
code (or to test to see if it compiles, never mind trying to boot a
kernel with that patch and exercise the modified code) before starting
to try to "help".

Other theories besides the one that Dave has advocated that he's
trying to write a University Thesis on trolling the kernel development
process (either by seeing if an obviously broken patch could be snuck
past the peer review system, or to see if he can try to get someone to
lose their temper much like Linus is supposed to do all the time ---
not realizing that this only happens to people who really should know
better, not to clueless newbies), are that he's a badly written AI
chatbot, or just a clueless high school student with more tenacity
than one usually expects at that age.  Or maybe he's trying to win a
bet, or is trying to get extra credit or to complete some course
assignment by getting a patch into the kernel.  Or maybe this is just
the universe trying to demonstrate exactly how true the
Dunning-Krueger effect really is....

> He isn't willing to spend his own time learning anything, he is
> expecting that kernel
> developers want to spoon feed someone who sends them broken patches.
> 
> We've asked him to stop, he keeps doing it, then when caught out apologizes
> with something along the lines, of I'm trying to learn, "idiot
> mistake", despite having
> been told to take a step back and try and learn how the kernel works.
> 
> Now we have to waste more maintainer time making sure nobody accidentally
> merges anything he sends.

Indeed; if you see any patches from Nick on other mailing lists which
you follow, it's a good idea to check and see if said patch is garbage
--- to date, his track record has been remarkably consistent.

But please do it in the nicest way possible, just in case he's a
reddit troll or some "journalist" trying to get headline bait by
getting a kernel developer to flame him to a crisp.

							- Ted
