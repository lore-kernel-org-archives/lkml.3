Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaLFFlN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 00:41:13 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60386 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaLFFlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 00:41:12 -0500
Date: Fri, 05 Dec 2014 21:45:41 -0800 (PST)
Message-Id: <20141205.214541.1925832989861326040.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        eric.dumazet@gmail.com
Subject: Re: [PATCH V4 net-next] tun/macvtap: use consume_skb() instead of
 kfree_skb() when needed
From: David Miller <davem@davemloft.net>
In-Reply-To: <1417423995-4765-1-git-send-email-jasowang@redhat.com>
References: <1417423995-4765-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Dec 2014 21:41:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Mon,  1 Dec 2014 16:53:15 +0800

> To be more friendly with drop monitor, we should only call kfree_skb() when
> the packets were dropped and use consume_skb() in other cases.
> 
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied, thanks.
