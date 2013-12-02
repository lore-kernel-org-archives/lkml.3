Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab3LBWRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 17:17:15 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54952 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab3LBWRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 17:17:10 -0500
Date: Mon, 02 Dec 2013 17:17:08 -0500 (EST)
Message-Id: <20131202.171708.287579418417500322.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: David.Laight@ACULAB.COM, puzman@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, cascardo@linux.vnet.ibm.com,
        anirudh@xilinx.com
Subject: Re: [PATCH] net: do not pretend FRAGLIST support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386003073.5352.58.camel@edumazet-glaptop2.roam.corp.google.com>
References: <20131202.111600.1622488165507147936.davem@davemloft.net>
	<1386001999.5352.51.camel@edumazet-glaptop2.roam.corp.google.com>
	<1386003073.5352.58.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 02 Dec 2013 14:17:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 02 Dec 2013 08:51:13 -0800

> From: Eric Dumazet <edumazet@google.com>
> 
> Few network drivers really supports frag_list : virtual drivers.
> 
> Some drivers wrongly advertise NETIF_F_FRAGLIST feature.
> 
> If skb with a frag_list is given to them, packet on the wire will be
> corrupt.
> 
> Remove this flag, as core networking stack will make sure to
> provide packets that can be sent without corruption.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Good catch, applied and queued up for -stable.
