Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab3C0Oqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:46:47 -0400
Received: from mail-ia0-f171.google.com ([209.85.210.171]:46338 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab3C0Oqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:46:45 -0400
Message-ID: <1364395602.15753.7.camel@edumazet-glaptop>
Subject: Re: [PATCH net-next 3/3] net: switch to use
 skb_probe_transport_header()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, Eric Dumazet <edumazet@google.com>
Date: Wed, 27 Mar 2013 07:46:42 -0700
In-Reply-To: <1364375482-7439-3-git-send-email-jasowang@redhat.com>
References: <1364375482-7439-1-git-send-email-jasowang@redhat.com>
	 <1364375482-7439-3-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-27 at 17:11 +0800, Jason Wang wrote:
> Switch to use the new help skb_probe_transport_header() to do the l4 header
> probing for untrusted sources. For packets with partial csum, the header should
> already been set by skb_partial_csum_set().
> 
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/net/macvtap.c             |    9 +--------
>  drivers/net/tun.c                 |   10 +---------
>  drivers/net/xen-netback/netback.c |   10 +---------
>  net/packet/af_packet.c            |   22 +++-------------------
>  4 files changed, 6 insertions(+), 45 deletions(-)

Acked-by: Eric Dumazet <edumazet@google.com>


