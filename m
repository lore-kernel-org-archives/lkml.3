Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbaEVU6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 16:58:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42775 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbaEVU6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 16:58:37 -0400
Date: Thu, 22 May 2014 16:58:33 -0400 (EDT)
Message-Id: <20140522.165833.414855217799383878.davem@davemloft.net>
To: jim_baxter@mentor.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kamal@canonical.com, bhutchings@solarflare.com,
        edumazet@google.com, mszeredi@suse.cz, fw@strlen.de
Subject: Re: skbuff truesize incorrect.
From: David Miller <davem@davemloft.net>
In-Reply-To: <537E5C63.7080607@mentor.com>
References: <537E4AFD.20304@mentor.com>
	<20140522.152146.2116142050088142989.davem@davemloft.net>
	<537E5C63.7080607@mentor.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 May 2014 13:58:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Baxter <jim_baxter@mentor.com>
Date: Thu, 22 May 2014 21:21:55 +0100

> If there are multiple clones for an skb all pointing at the same data,
> will that distort the memory used when they all have the same truesize?

What is distorted about it?

Each clone references exactly that much backing memory.
