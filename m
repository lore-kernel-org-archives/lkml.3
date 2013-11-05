Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab3KEBE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 20:04:26 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:55858 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab3KEBEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 20:04:24 -0500
Date: Mon, 04 Nov 2013 20:04:22 -0500 (EST)
Message-Id: <20131104.200422.1529242936573745110.davem@davemloft.net>
To: jasowang@redhat.com
Cc: edumazet@google.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rusty@rustcorp.com.au, mst@redhat.com, mwdalton@google.com,
        virtualization@lists.linux-foundation.org, kmindg@gmail.com
Subject: Re: [PATCH net-next V3 1/2] net: introduce skb_coalesce_rx_frag()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1383286068-10421-1-git-send-email-jasowang@redhat.com>
References: <1383286068-10421-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 04 Nov 2013 17:04:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Fri,  1 Nov 2013 14:07:47 +0800

> Sometimes we need to coalesce the rx frags to avoid frag list. One example is
> virtio-net driver which tries to use small frags for both MTU sized packet and
> GSO packet. So this patch introduce skb_coalesce_rx_frag() to do this.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Michael Dalton <mwdalton@google.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> Changes from V2:
> - remove the skb_frag_unref() and let the called to put the page reference
> Changes from V1:
> - remove the useless off parameter.

Applied.
