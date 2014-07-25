Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758992AbaGYGk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 02:40:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58888 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaGYGk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 02:40:27 -0400
Date: Thu, 24 Jul 2014 23:40:26 -0700 (PDT)
Message-Id: <20140724.234026.1408822707562402333.davem@davemloft.net>
To: cyrille.pitchen@atmel.com
Cc: nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, soren.brinkmann@xilinx.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] net/macb: add HW features to macb driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1406192657.git.cyrille.pitchen@atmel.com>
References: <cover.1406192657.git.cyrille.pitchen@atmel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 24 Jul 2014 23:40:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Date: Thu, 24 Jul 2014 13:50:57 +0200

> this series of patches adds new hardware features to macb driver. These
> features can be enabled/disabled at runtime using ethtool. Depending on
> hardware and design configuration, some are enabled by default whereas other
> are disabled.
> 
> For instance, checksum offload features are enabled by default for gem designed
> for packet buffer mode but disabled for fifo mode design or for old macb.
> 
> Besides, the scatter-gather feature is enabled and tested on macb but disabled
> on sama5d3x gem. When testing this feature on sama5d3x gem, TX lockups occured
> frequently.
> 
> Also, the RX checksum offload feature is enabled at GEM level only when both
> IFF_PROMISC bit is clear in dev->flags and NETIF_F_RXCSUM bit is set in
> dev->features.
> 
> These patches were made for net-next.git repository.

Series applied, thanks.
