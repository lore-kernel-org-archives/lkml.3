Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab3GKCrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 22:47:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48619 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab3GKCrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 22:47:31 -0400
Date: Wed, 10 Jul 2013 19:47:31 -0700 (PDT)
Message-Id: <20130710.194731.99871775347094227.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] sh_eth: SH_ETH should depend on HAS_DMA
From: David Miller <davem@davemloft.net>
In-Reply-To: <1373490216-12437-1-git-send-email-geert@linux-m68k.org>
References: <1373490216-12437-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 10 Jul 2013 23:03:34 +0200

> If NO_DMA=y:
> 
> drivers/built-in.o: In function `sh_eth_free_dma_buffer':
> drivers/net/ethernet/renesas/sh_eth.c:1103: undefined reference to `dma_free_coherent'
> drivers/net/ethernet/renesas/sh_eth.c:1110: undefined reference to `dma_free_coherent'
> drivers/built-in.o: In function `sh_eth_ring_init':
> drivers/net/ethernet/renesas/sh_eth.c:1065: undefined reference to `dma_alloc_coherent'
> drivers/net/ethernet/renesas/sh_eth.c:1086: undefined reference to `dma_free_coherent'
> drivers/built-in.o: In function `sh_eth_ring_format':
> drivers/net/ethernet/renesas/sh_eth.c:988: undefined reference to `dma_map_single'
> drivers/built-in.o: In function `sh_eth_txfree':
> drivers/net/ethernet/renesas/sh_eth.c:1220: undefined reference to `dma_unmap_single'
> drivers/built-in.o: In function `sh_eth_rx':
> drivers/net/ethernet/renesas/sh_eth.c:1323: undefined reference to `dma_map_single'
> drivers/built-in.o: In function `sh_eth_start_xmit':
> drivers/net/ethernet/renesas/sh_eth.c:1954: undefined reference to `dma_map_single'
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied, thanks Geert.
