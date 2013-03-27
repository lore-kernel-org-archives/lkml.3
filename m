Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab3C0RHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:07:48 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57971 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab3C0RHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:07:46 -0400
Date: Wed, 27 Mar 2013 13:07:43 -0400 (EDT)
Message-Id: <20130327.130743.2174768360702998855.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: jasowang@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, edumazet@google.com
Subject: Re: [PATCH net-next 2/3] net: core: introduce
 skb_probe_transport_header()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1364395550.15753.6.camel@edumazet-glaptop>
References: <1364375482-7439-1-git-send-email-jasowang@redhat.com>
	<1364375482-7439-2-git-send-email-jasowang@redhat.com>
	<1364395550.15753.6.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 27 Mar 2013 10:07:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 27 Mar 2013 07:45:50 -0700

> On Wed, 2013-03-27 at 17:11 +0800, Jason Wang wrote:
>> Sometimes, we need probe and set the transport header for packets (e.g from
>> untrusted source). This patch introduces a new helper
>> skb_probe_transport_header() which tries to probe and set the l4 header through
>> skb_flow_dissect(), if not just set the transport header to the hint passed by
>> caller.
>> 
>> Cc: Eric Dumazet <edumazet@google.com>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>  include/linux/skbuff.h |   14 ++++++++++++++
>>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> Acked-by: Eric Dumazet <edumazet@google.com>

Applied.
