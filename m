Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933826AbaEFDVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:21:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35996 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933739AbaEFDVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:21:07 -0400
Date: Mon, 05 May 2014 23:21:05 -0400 (EDT)
Message-Id: <20140505.232105.633722669086565626.davem@davemloft.net>
To: andi@firstfloor.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com, ak@linux.intel.com,
        robert.olsson@its.uu.se
Subject: Re: [PATCH 22/24] net, diet: Support simpler routing table
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140506030833.GL2382@two.firstfloor.org>
References: <1399328773-6531-23-git-send-email-andi@firstfloor.org>
	<20140505.230259.1803147080660592366.davem@davemloft.net>
	<20140506030833.GL2382@two.firstfloor.org>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 May 2014 20:21:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Tue, 6 May 2014 05:08:33 +0200

> FWIW it seems to me the trie code is very stable, there doesn't
> seem to be any big changes in a long time.

But it was BUGGY AS HELL in the corner cases because it wasn't
the default while it sat next to fib_hash.

It only got totally fixed when it was the ONLY option.

That's exactly my point, parts of it never got tested and were never
verified because debugging resources for it was split with another
implementation.
