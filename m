Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaGUENt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 00:13:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53102 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaGUENr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 00:13:47 -0400
Date: Sun, 20 Jul 2014 21:13:37 -0700 (PDT)
Message-Id: <20140720.211337.211665722122921773.davem@davemloft.net>
To: cyrille.pitchen@atmel.com
Cc: nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, soren.brinkmann@xilinx.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] net/macb: add scatter-gather hw feature
From: David Miller <davem@davemloft.net>
In-Reply-To: <fda3a504240e1f6863107ef6bf1e78586671a030.1405689937.git.cyrille.pitchen@atmel.com>
References: <cover.1405689937.git.cyrille.pitchen@atmel.com>
	<fda3a504240e1f6863107ef6bf1e78586671a030.1405689937.git.cyrille.pitchen@atmel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 20 Jul 2014 21:13:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Date: Fri, 18 Jul 2014 16:21:14 +0200

> +		if (tx_skb->mapped_as_page) {
> +			dma_unmap_page(&bp->pdev->dev, tx_skb->mapping,
> +				       tx_skb->size, DMA_TO_DEVICE);
> +		} else {
> +			dma_unmap_single(&bp->pdev->dev, tx_skb->mapping,
> +					 tx_skb->size, DMA_TO_DEVICE);
> +		}

Please do not use curly braces for basic block composed of a single statement.
