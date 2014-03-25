Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbaCYEbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 00:31:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47386 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaCYEbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 00:31:47 -0400
Date: Tue, 25 Mar 2014 00:31:46 -0400 (EDT)
Message-Id: <20140325.003146.1533027544821884786.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, roy.qing.li@gmail.com,
        ebiederm@xmission.com
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140325130447.e38f4242c03090fd48eae340@canb.auug.org.au>
References: <20140325130447.e38f4242c03090fd48eae340@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Mar 2014 21:31:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 25 Mar 2014 13:04:47 +1100

> Today's linux-next merge of the net-next tree got a conflict in
> net/core/netpoll.c between commit c27f0872a344 ("netpoll: fix the skb
> check in pkt_is_ns") from the net tree and commit 9c62a68d1311 ("netpoll:
> Remove dead packet receive code (CONFIG_NETPOLL_TRAP)") from the net-next
> tree.
> 
> I fixed it up (the latter removes the code fixed by the former, so I did
> that) and can carry the fix as necessary (no action is required).

That's a perfect resolution, thanks.
