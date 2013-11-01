Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab3KAJpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 05:45:43 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:48681 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab3KAJpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 05:45:42 -0400
Message-ID: <1383299139.19864.2.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net-next V3 1/2] net: introduce skb_coalesce_rx_frag()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, edumazet@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rusty@rustcorp.com.au, mst@redhat.com,
        mwdalton@google.com, virtualization@lists.linux-foundation.org,
        kmindg@gmail.com
Date: Fri, 01 Nov 2013 02:45:39 -0700
In-Reply-To: <1383286068-10421-1-git-send-email-jasowang@redhat.com>
References: <1383286068-10421-1-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-01 at 14:07 +0800, Jason Wang wrote:
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
> ---

Acked-by: Eric Dumazet <edumazet@google.com>



