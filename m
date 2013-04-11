Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965229Ab3DKR7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:59:20 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:46546 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964989Ab3DKR7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:59:18 -0400
Message-ID: <1365703155.3887.184.camel@edumazet-glaptop>
Subject: Re: [PATCH] net: mv643xx_eth: Add GRO support
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: David Miller <davem@davemloft.net>, sebastian.hesselbarth@gmail.com,
        andrew@lunn.ch, jason@lakedaemon.net, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, florian@openwrt.org, smoch@web.de,
        paulus@samba.org, buytenh@wantstofly.org, dale@farnsworth.org,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Date: Thu, 11 Apr 2013 10:59:15 -0700
In-Reply-To: <20130411175147.GN1910@1wt.eu>
References: <CABJ1b_TQDabT1J7ffo5cb1Th=71bcSduifMJaDpfVRiiHvtWDw@mail.gmail.com>
	 <20130411150326.GA19978@1wt.eu>
	 <CABJ1b_TRxm97DKJLP_h0VwMJvcYmSpjoJvtg1KvBNGah=VzqMQ@mail.gmail.com>
	 <20130411.133119.913809939413807690.davem@davemloft.net>
	 <20130411175147.GN1910@1wt.eu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-11 at 19:51 +0200, Willy Tarreau wrote:

> Eric provided me with one such experimental patch in the past for this
> driver. It worked for me but we never tried to clean it up to propose
> it for inclusion.
> 
> If anyone is interested, I might still have it in experimental shape.

We are interested a lot ;)

Thanks !


