Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaKLUIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 15:08:15 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46114 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbaKLUIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 15:08:13 -0500
Date: Wed, 12 Nov 2014 15:08:10 -0500 (EST)
Message-Id: <20141112.150810.806933062338696000.davem@davemloft.net>
To: jszhang@marvell.com
Cc: antoine.tenart@free-electrons.com, arnd@arndb.de,
        sebastian.hesselbarth@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: pxa168_eth: move SET_NETDEV_DEV a bit earlier
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415790527-6494-1-git-send-email-jszhang@marvell.com>
References: <1415790527-6494-1-git-send-email-jszhang@marvell.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Nov 2014 12:08:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jisheng Zhang <jszhang@marvell.com>
Date: Wed, 12 Nov 2014 19:08:47 +0800

> This is to ensure the net_device's dev.parent is set before we used it
> in dma_zalloc_coherent() from init_hash_table().
> 
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>

Please always be explicit about what tree you generated this patch against
and therefore expect it to be applied to by saying "[PATCH net-next]" or
similar in your Subject line.

Because this only applies cleanly to net-next, that's where I installed
it.

Thanks.
