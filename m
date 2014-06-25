Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbaFYWhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:37:18 -0400
Received: from imap.thunk.org ([74.207.234.97]:58433 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbaFYWhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:37:12 -0400
Date: Wed, 25 Jun 2014 18:37:03 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        T Makphaibulchoke <tmac@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [GIT PULL] ext4 changes for 3.15
Message-ID: <20140625223703.GC10397@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>,
	"Maciej W. Rozycki" <macro@linux-mips.org>,
	T Makphaibulchoke <tmac@hp.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
References: <20140403191558.GA8745@thunk.org>
 <alpine.LFD.2.11.1406242251230.23403@eddie.linux-mips.org>
 <53A9FE04.2000306@hp.com>
 <CA+55aFzbC9QgO46m2H47NbUMWssDm-t4YQ8bJggGrZj2h-_9EQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzbC9QgO46m2H47NbUMWssDm-t4YQ8bJggGrZj2h-_9EQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 10:08:02AM -0700, Linus Torvalds wrote:
> Ted,
>  going through pending issues, and wondering if I'm expected to pick
> this up directly? The original came through your tree (commit
> 1f3e55fe02d1: "fs/mbcache.c: doucple the locking of local from global
> data") and is in 3.15 too, so the patch should be marked for stable as
> well.
> 
> It's hopefully limited to just very bad gcc versions for odd
> architectures, so it's not exactly high-impact, but still..

Yes, I'll get something to you soon.  Sorry, I was on travel to NYC
earlier this week, so I'm a bit behind on the bug fix patches that I
needed to send to you now that the merge window is closed.

       	       	      	       	   	 	- Ted
