Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab3JUW6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:58:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44490 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab3JUW6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:58:00 -0400
Date: Mon, 21 Oct 2013 18:57:59 -0400 (EDT)
Message-Id: <20131021.185759.2298688785062999792.davem@davemloft.net>
To: mceier+kernel@gmail.com
Cc: mugunthanvnm@ti.com, prabhakar.csengg@gmail.com, jg1.han@samsung.com,
        jiri@resnulli.us, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] davinci_emac.c: Fix IFF_ALLMULTI setup
From: David Miller <davem@davemloft.net>
In-Reply-To: <1382377504-24688-1-git-send-email-mceier+kernel@gmail.com>
References: <5265640C.4070201@cogentembedded.com>
	<1382377504-24688-1-git-send-email-mceier+kernel@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 21 Oct 2013 15:58:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Ceier <mceier+kernel@gmail.com>
Date: Mon, 21 Oct 2013 19:45:04 +0200

> When IFF_ALLMULTI flag is set on interface and IFF_PROMISC isn't,
> emac_dev_mcast_set should only enable RX of multicasts and reset
> MACHASH registers.
> 
> It does this, but afterwards it either sets up multicast MACs
> filtering or disables RX of multicasts and resets MACHASH registers
> again, rendering IFF_ALLMULTI flag useless.
> 
> This patch fixes emac_dev_mcast_set, so that multicast MACs filtering and
> disabling of RX of multicasts are skipped when IFF_ALLMULTI flag is set.
> 
> Tested with kernel 2.6.37.
> 
> Signed-off-by: Mariusz Ceier <mceier+kernel@gmail.com>

Applied and queued up for -stable, thanks.
