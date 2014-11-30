Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaK3E7m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 23:59:42 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54862 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbaK3E7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 23:59:41 -0500
Date: Sat, 29 Nov 2014 21:03:50 -0800 (PST)
Message-Id: <20141129.210350.1994537005887744173.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next V3] tun/macvtap: use consume_skb() instead of
 kfree_skb() when needed
From: David Miller <davem@davemloft.net>
In-Reply-To: <1417070166-7026-1-git-send-email-jasowang@redhat.com>
References: <1417070166-7026-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Nov 2014 20:59:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Thu, 27 Nov 2014 14:36:06 +0800

> To be more friendly with drop monitor, we should only call kfree_skb() when
> the packets were dropped and use consume_skb() in other cases.
> 
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> Changes from V2:
> - use unlikely() when necessary
> Changes from V1:
> - check the return value of tun/macvtap_put_user()

This does not apply cleanly to net-next and will thus need to
be respun, thanks.
