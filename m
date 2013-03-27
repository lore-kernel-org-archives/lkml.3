Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab3C0RHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:07:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57974 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3C0RHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:07:49 -0400
Date: Wed, 27 Mar 2013 13:07:47 -0400 (EDT)
Message-Id: <20130327.130747.1475185250925727761.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: jasowang@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, edumazet@google.com
Subject: Re: [PATCH net-next 3/3] net: switch to use
 skb_probe_transport_header()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1364395602.15753.7.camel@edumazet-glaptop>
References: <1364375482-7439-1-git-send-email-jasowang@redhat.com>
	<1364375482-7439-3-git-send-email-jasowang@redhat.com>
	<1364395602.15753.7.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 27 Mar 2013 10:07:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 27 Mar 2013 07:46:42 -0700

> On Wed, 2013-03-27 at 17:11 +0800, Jason Wang wrote:
>> Switch to use the new help skb_probe_transport_header() to do the l4 header
>> probing for untrusted sources. For packets with partial csum, the header should
>> already been set by skb_partial_csum_set().
>> 
>> Cc: Eric Dumazet <edumazet@google.com>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>  drivers/net/macvtap.c             |    9 +--------
>>  drivers/net/tun.c                 |   10 +---------
>>  drivers/net/xen-netback/netback.c |   10 +---------
>>  net/packet/af_packet.c            |   22 +++-------------------
>>  4 files changed, 6 insertions(+), 45 deletions(-)
> 
> Acked-by: Eric Dumazet <edumazet@google.com>

Applied.
