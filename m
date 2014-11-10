Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbaKJQTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:19:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42347 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbaKJQS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:18:56 -0500
Date: Mon, 10 Nov 2014 11:18:50 -0500 (EST)
Message-Id: <20141110.111850.103241671429881179.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcrl@kvack.org, mst@redhat.com
Subject: Re: [PATCH 1/4] inet: Add skb_copy_datagram_iter
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141110090955.GH7996@ZenIV.linux.org.uk>
References: <20141110065817.GG7996@ZenIV.linux.org.uk>
	<20141110.023000.1275181784917275552.davem@davemloft.net>
	<20141110090955.GH7996@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Nov 2014 08:18:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Mon, 10 Nov 2014 09:09:55 +0000

> BTW, what's the usual regression suite used for net/* stuff?

There's a regression suite? :-)
