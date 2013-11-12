Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab3KLXNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 18:13:41 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:39283 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab3KLXNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 18:13:33 -0500
Date: Wed, 13 Nov 2013 00:13:32 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Daniel Borkmann <dborkman@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: Re: linux-next: manual merge of the random tree with the net-next tree
Message-ID: <20131112231332.GH14929@order.stressinduktion.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Daniel Borkmann <dborkman@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
	netdev@vger.kernel.org
References: <20131112155549.c160273993147244ed6bc81d@canb.auug.org.au> <5281ED01.5020204@redhat.com> <20131112230242.GA1643@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131112230242.GA1643@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 06:02:42PM -0500, Theodore Ts'o wrote:
> On Tue, Nov 12, 2013 at 09:55:29AM +0100, Daniel Borkmann wrote:
> > 
> > As per Hannes' suggestion, the result should look like (see cover
> > letter in [1]):
> > 
> > if (r->entropy_total > 128) {
> > 	r->initialized = 1;
> > 	r->entropy_total = 0;
> > 	if (r == &nonblocking_pool) {
> > 		prandom_reseed_late();
> > 		pr_notice("random: %s pool is initialized\n",
> > 			  r->name);
> > 	}
> > }
> 
> Agreed.  What's the schedule for pushing net-dev to Linus?  I'm
> currently at Korea Linux Forum, and I was originally planning on
> pushing random.git to Linus sometime today, but I'm also willing to
> wait for net-dev to go first.  Either way, we should make sure Linus
> is aware of the agreed-upon resolution of the merge conflict.

net-next is already on its way: http://markmail.org/message/ihccweynhtpdd66u

Greetings,

  Hannes

