Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab3KLXRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 18:17:22 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38079 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786Ab3KLXRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 18:17:20 -0500
Date: Tue, 12 Nov 2013 18:17:17 -0500 (EST)
Message-Id: <20131112.181717.2152470373264166279.davem@davemloft.net>
To: tytso@mit.edu
Cc: dborkman@redhat.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, hannes@stressinduktion.org,
        netdev@vger.kernel.org
Subject: Re: linux-next: manual merge of the random tree with the net-next
 tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131112230242.GA1643@thunk.org>
References: <20131112155549.c160273993147244ed6bc81d@canb.auug.org.au>
	<5281ED01.5020204@redhat.com>
	<20131112230242.GA1643@thunk.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 12 Nov 2013 15:17:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>
Date: Tue, 12 Nov 2013 18:02:42 -0500

> On Tue, Nov 12, 2013 at 09:55:29AM +0100, Daniel Borkmann wrote:
>> 
>> As per Hannes' suggestion, the result should look like (see cover
>> letter in [1]):
>> 
>> if (r->entropy_total > 128) {
>> 	r->initialized = 1;
>> 	r->entropy_total = 0;
>> 	if (r == &nonblocking_pool) {
>> 		prandom_reseed_late();
>> 		pr_notice("random: %s pool is initialized\n",
>> 			  r->name);
>> 	}
>> }
> 
> Agreed.  What's the schedule for pushing net-dev to Linus?  I'm
> currently at Korea Linux Forum, and I was originally planning on
> pushing random.git to Linus sometime today, but I'm also willing to
> wait for net-dev to go first.  Either way, we should make sure Linus
> is aware of the agreed-upon resolution of the merge conflict.

Linus is going to pull it soon, I sent the pull request last night but
he was away from decent internet access at the time.
