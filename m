Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbaKGDNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 22:13:19 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33499 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaKGDNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 22:13:15 -0500
Date: Thu, 06 Nov 2014 22:13:13 -0500 (EST)
Message-Id: <20141106.221313.1375322315446025123.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: viro@ZenIV.linux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcrl@kvack.org
Subject: Re: [PATCH 1/4] inet: Add skb_copy_datagram_iter
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141107015944.GB9101@gondor.apana.org.au>
References: <20141106082338.GA29800@gondor.apana.org.au>
	<20141106.122500.4643339498907490.davem@davemloft.net>
	<20141107015944.GB9101@gondor.apana.org.au>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Nov 2014 19:13:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 7 Nov 2014 09:59:44 +0800

> In that case it might be best to wait until those fixes hit net-next
> first before applying these patches as otherwise Stephen will get
> hit with some nasty merge conflicts.

I just merged net into net-next, so this barrier should no longer
be present.

Thanks.
