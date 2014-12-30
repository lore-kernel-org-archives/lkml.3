Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaL3Xxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 18:53:55 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36786 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaL3Xxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 18:53:53 -0500
Date: Tue, 30 Dec 2014 18:53:50 -0500 (EST)
Message-Id: <20141230.185350.1886821773938320675.davem@davemloft.net>
To: jasowang@redhat.com
Cc: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next V2] virtio-net: don't do header check for
 dodgy gso packets
From: David Miller <davem@davemloft.net>
In-Reply-To: <1419390232-14906-1-git-send-email-jasowang@redhat.com>
References: <1419390232-14906-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Dec 2014 15:53:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Wed, 24 Dec 2014 11:03:52 +0800

> There's no need to do header check for virtio-net since:
> 
> - Host sets dodgy for all gso packets from guest and check the header.
> - Host should be prepared for all kinds of evil packets from guest, since
>   malicious guest can send any kinds of packet.
> 
> So this patch sets NETIF_F_GSO_ROBUST for virtio-net to skip the check.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> Changes from V1:
> - typo fixes

Applied.
