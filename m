Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab3C0Opy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:45:54 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:64190 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3C0Opx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:45:53 -0400
Message-ID: <1364395550.15753.6.camel@edumazet-glaptop>
Subject: Re: [PATCH net-next 2/3] net: core: introduce
 skb_probe_transport_header()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, Eric Dumazet <edumazet@google.com>
Date: Wed, 27 Mar 2013 07:45:50 -0700
In-Reply-To: <1364375482-7439-2-git-send-email-jasowang@redhat.com>
References: <1364375482-7439-1-git-send-email-jasowang@redhat.com>
	 <1364375482-7439-2-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-27 at 17:11 +0800, Jason Wang wrote:
> Sometimes, we need probe and set the transport header for packets (e.g from
> untrusted source). This patch introduces a new helper
> skb_probe_transport_header() which tries to probe and set the l4 header through
> skb_flow_dissect(), if not just set the transport header to the hint passed by
> caller.
> 
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  include/linux/skbuff.h |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)

Acked-by: Eric Dumazet <edumazet@google.com>


