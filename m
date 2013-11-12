Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab3KLXDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 18:03:01 -0500
Received: from imap.thunk.org ([74.207.234.97]:57182 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755191Ab3KLXCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 18:02:54 -0500
Date: Tue, 12 Nov 2013 18:02:42 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: linux-next: manual merge of the random tree with the net-next
 tree
Message-ID: <20131112230242.GA1643@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Daniel Borkmann <dborkman@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	David Miller <davem@davemloft.net>, netdev@vger.kernel.org
References: <20131112155549.c160273993147244ed6bc81d@canb.auug.org.au>
 <5281ED01.5020204@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5281ED01.5020204@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 09:55:29AM +0100, Daniel Borkmann wrote:
> 
> As per Hannes' suggestion, the result should look like (see cover
> letter in [1]):
> 
> if (r->entropy_total > 128) {
> 	r->initialized = 1;
> 	r->entropy_total = 0;
> 	if (r == &nonblocking_pool) {
> 		prandom_reseed_late();
> 		pr_notice("random: %s pool is initialized\n",
> 			  r->name);
> 	}
> }

Agreed.  What's the schedule for pushing net-dev to Linus?  I'm
currently at Korea Linux Forum, and I was originally planning on
pushing random.git to Linus sometime today, but I'm also willing to
wait for net-dev to go first.  Either way, we should make sure Linus
is aware of the agreed-upon resolution of the merge conflict.

Cheers,

						- Ted
