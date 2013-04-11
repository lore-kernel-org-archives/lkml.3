Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab3DKUWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:22:52 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38971 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab3DKUWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:22:50 -0400
Date: Thu, 11 Apr 2013 16:22:45 -0400 (EDT)
Message-Id: <20130411.162245.954727103094202894.davem@davemloft.net>
To: sebastian.hesselbarth@gmail.com
Cc: smoch@web.de, buytenh@wantstofly.org, andrew@lunn.ch, jason@lakedaemon.net,
        florian@openwrt.org, benh@kernel.crashing.org, paulus@samba.org,
        dale@farnsworth.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mv643xx_eth: Add GRO support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1365684023-9967-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1365684023-9967-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 11 Apr 2013 13:22:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date: Thu, 11 Apr 2013 14:40:23 +0200

> This patch adds GRO support to mv643xx_eth by making it invoke
> napi_gro_receive instead of netif_receive_skb.
> 
> Signed-off-by: Soeren Moch <smoch@web.de>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Applied.
