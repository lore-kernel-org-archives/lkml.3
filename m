Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965003Ab3DKRf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:35:29 -0400
Received: from mail-ia0-f176.google.com ([209.85.210.176]:54633 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964855Ab3DKRf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:35:28 -0400
Message-ID: <1365701725.3887.177.camel@edumazet-glaptop>
Subject: Re: [PATCH] net: mv643xx_eth: Add GRO support
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: sebastian.hesselbarth@gmail.com, w@1wt.eu, andrew@lunn.ch,
        jason@lakedaemon.net, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, florian@openwrt.org, smoch@web.de,
        paulus@samba.org, buytenh@wantstofly.org, dale@farnsworth.org,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Date: Thu, 11 Apr 2013 10:35:25 -0700
In-Reply-To: <20130411.133119.913809939413807690.davem@davemloft.net>
References: <CABJ1b_TQDabT1J7ffo5cb1Th=71bcSduifMJaDpfVRiiHvtWDw@mail.gmail.com>
	 <20130411150326.GA19978@1wt.eu>
	 <CABJ1b_TRxm97DKJLP_h0VwMJvcYmSpjoJvtg1KvBNGah=VzqMQ@mail.gmail.com>
	 <20130411.133119.913809939413807690.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-11 at 13:31 -0400, David Miller wrote:

> I think, as per other drivers, LRO should be eliminated completely from
> all drivers, including this one, and GRO used exclusively instead.

This would be awesome.

AFAIK current LRO users are :

drivers/infiniband/hw/nes/nes_hw.c
drivers/net/ethernet/marvell/mv643xx_eth.c
drivers/net/ethernet/pasemi/pasemi_mac.c



