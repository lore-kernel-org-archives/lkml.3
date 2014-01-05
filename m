Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaAEXnM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 18:43:12 -0500
Received: from imap.thunk.org ([74.207.234.97]:46133 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbaAEXnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 18:43:11 -0500
Date: Sun, 5 Jan 2014 18:43:07 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: bulk88 <bulk88@hotmail.com>
Cc: Antti Heikkinen <antti.heikkinen.4@gmail.com>,
        linux-kernel@vger.kernel.org, advocacy@perl.org, beginners@perl.org
Subject: Re: Propose for LINUX kernel and PERL
Message-ID: <20140105234307.GA16071@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	bulk88 <bulk88@hotmail.com>,
	Antti Heikkinen <antti.heikkinen.4@gmail.com>,
	linux-kernel@vger.kernel.org, advocacy@perl.org, beginners@perl.org
References: <CAM__s2Bk=Hgzm3-f7N=A032PxUV6N87=42qZ=7kt7u8d_Ny5gg@mail.gmail.com>
 <BLU0-SMTP270AA353C093297F94C7B85DFB40@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BLU0-SMTP270AA353C093297F94C7B85DFB40@phx.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 05, 2014 at 03:12:17AM -0500, bulk88 wrote:
> I agree, Linux kernel is hacks on hacks with no top to bottom
> architecture. Linux had the BKL longer than its competitors. Linux
> was never whiteboarded before the project began. FreeBSD is more
> organized and uniform. There is also NT Kernel whose API was speced
> out before the kernel was written.

For the record, Linux had the BKL longer because it has had SMP longer
than its competitors.  Linux got rid of the last of the BKL in
mid-2012.  As of 2013, FreeBSD, NetBSD, and OpenBSD still has the
giant lock (BSD's equivalent of the BKL) in some of their subsystems.
And of course, in general Linux has had much better scalability than
the *BSD's for much of the past couple of years, with SGI using Linux
on systems with hundreds of processors, and with people using Linux on
32 and 64 processors systems for the past decade.  In contrast,
FreeBSD was boasting in 2013 of improving its 16 processor
scalability...

> Since Perl is Turing complete you can run the Linux kernel inside
> Perl. Although Perl doesn't run in kernel mode ATM, I don't see why
> I can't be ported to be a LKM, maybe with RPC to glibc. You could
> also have Perl running as user mode driver or some kind daemon with
> calls from a kernel driver to the user space daemon Perl. You can
> use Perl version 5 or 6.

My favorite suggestion, going back several decades to the early 90's,
was those who suggested porting BSD 4.3 to Emacs LISP, so that you
could run your entire system under GNU Emacs.  :-)

      	       	      	     	       	       - Ted
