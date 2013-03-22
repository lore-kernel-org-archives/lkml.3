Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933698Ab3CVPmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:42:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50926 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933382Ab3CVPmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:42:02 -0400
Date: Fri, 22 Mar 2013 11:41:59 -0400 (EDT)
Message-Id: <20130322.114159.2303026992656610194.davem@davemloft.net>
To: benmcollins13@gmail.com
Cc: afleming@freescale.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: Add support for handling queueing in hardware
From: David Miller <davem@davemloft.net>
In-Reply-To: <9AEAD974-4549-475A-AE15-C92523CD2466@gmail.com>
References: <FE78128C-01DB-4831-ACBE-BA3E3A428BFC@gmail.com>
	<20130322.111759.2108472348146991505.davem@davemloft.net>
	<9AEAD974-4549-475A-AE15-C92523CD2466@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 22 Mar 2013 08:42:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Collins <benmcollins13@gmail.com>
Date: Fri, 22 Mar 2013 11:39:20 -0400

> If your company had hardware going to production, you'd want it
> supported in mainline too, I suspect.

But never against the wishes of the author of the code.

This has firm and strict precedence, for example one of the
implementations block layer encryption was not wanted to be merged by
the author, and Linus reverted it.

So if the person who wrote the code doesn't want it upstream, you can't
bypass them against their wishes, ever.  It's their code not your's.

