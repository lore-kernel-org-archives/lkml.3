Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbaKEUvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:51:43 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48022 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaKEUvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:51:42 -0500
Date: Wed, 05 Nov 2014 15:51:40 -0500 (EST)
Message-Id: <20141105.155140.1110198452648637549.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcrl@kvack.org
Subject: Re: [PATCH 1/4] inet: Add skb_copy_datagram_iter
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141105041231.GP7996@ZenIV.linux.org.uk>
References: <20141104.222727.275422581392488793.davem@davemloft.net>
	<20141105035536.GO7996@ZenIV.linux.org.uk>
	<20141105041231.GP7996@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Nov 2014 12:51:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Wed, 5 Nov 2014 04:12:32 +0000

> On Wed, Nov 05, 2014 at 03:55:36AM +0000, Al Viro wrote:
>> What do you think of the trick with user_msghdr, BTW?
> 
> 	PS: where do you prefer the branches to be based off?
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net#master, mainline,
> something else?  I can certainly do that as patches over email, the
> question is what's best used as base...  FWIW, the analysis I've posted
> was in 3.18-rc3 and it looks like it ought to be valid in net#master
> as well.

Let's work against net-next, ie:

git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next#master

I can integrate, your, mine, and Herbert's changes all into the same
place.

Thanks.
