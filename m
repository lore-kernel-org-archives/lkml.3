Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaKJT0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 14:26:24 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47099 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbaKJT0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:26:22 -0500
Date: Mon, 10 Nov 2014 14:26:20 -0500 (EST)
Message-Id: <20141110.142620.1948543767016798203.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: viro@ZenIV.linux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcrl@kvack.org, nakam@linux-ipv6.org,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH 0/2] ipv4: Simplify raw_probe_proto_opt and avoid
 reading user iov twice
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141107132553.GA20190@gondor.apana.org.au>
References: <20141106.162808.1546139916210194279.davem@davemloft.net>
	<20141107020025.GC9101@gondor.apana.org.au>
	<20141107132553.GA20190@gondor.apana.org.au>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Nov 2014 11:26:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 7 Nov 2014 21:25:53 +0800

> This series rewrites the function raw_probe_proto_opt in a more
> readable fasion, and then fixes the long-standing bug where we
> read the probed bytes twice which means that what we're using to
> probe may in fact be invalid.

Series applied to net-next, thanks Herbert.
