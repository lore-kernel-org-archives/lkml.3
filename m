Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbaKFRZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:25:06 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56476 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaKFRZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:25:03 -0500
Date: Thu, 06 Nov 2014 12:25:00 -0500 (EST)
Message-Id: <20141106.122500.4643339498907490.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: viro@ZenIV.linux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcrl@kvack.org
Subject: Re: [PATCH 1/4] inet: Add skb_copy_datagram_iter
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141106082338.GA29800@gondor.apana.org.au>
References: <E1XlZWY-0003HZ-Ef@gondolin.me.apana.org.au>
	<20141105.152410.1775725940252546246.davem@davemloft.net>
	<20141106082338.GA29800@gondor.apana.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Nov 2014 09:25:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Thu, 6 Nov 2014 16:23:38 +0800

> On Wed, Nov 05, 2014 at 03:24:10PM -0500, David Miller wrote:
>> 
>> Herbert, please provide a cover letter for this series, and the most recent
>> version of patch #2 gets various rejects when I try to apply it to net-next.
> 
> Sure, I'll regenerate them.  However, while doing so I noticed that
> a number of my patches on tun/macvtap that you have previously set
> as accepted are missing from net-next.  Could this be why you got
> the rejects?

Those were bug fixes so went into plain 'net', they will show up next
time I do a merge and I will deal with the conflicts, if any.
