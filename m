Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297Ab3GLEjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 00:39:51 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49659 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab3GLEju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 00:39:50 -0400
X-IronPort-AV: E=Sophos;i="4.89,650,1367996400"; 
   d="scan'208";a="62296129"
X-IronPort-AV: E=Sophos;i="4.89,650,1367996400"; 
   d="scan'208";a="567036546"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <ath10k@lists.infradead.org>
Subject: Re: [PATCH 3/3] ath10k: ATH10K should depend on HAS_DMA
References: <1373490216-12437-1-git-send-email-geert@linux-m68k.org>
	<1373490216-12437-3-git-send-email-geert@linux-m68k.org>
Date: Fri, 12 Jul 2013 07:39:39 +0300
In-Reply-To: <1373490216-12437-3-git-send-email-geert@linux-m68k.org> (Geert
	Uytterhoeven's message of "Wed, 10 Jul 2013 23:03:36 +0200")
Message-ID: <87txk04cj8.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> If NO_DMA=y:
>
> drivers/built-in.o: In function `ath10k_skb_unmap':
> drivers/net/wireless/ath/ath10k/core.h:98: undefined reference to `dma_unmap_single'
> drivers/built-in.o: In function `ath10k_skb_map':
> drivers/net/wireless/ath/ath10k/core.h:83: undefined reference to `dma_map_single'
> drivers/net/wireless/ath/ath10k/core.h:86: undefined reference to `dma_mapping_error'
> drivers/built-in.o: In function `ath10k_htt_rx_ring_free':
> drivers/net/wireless/ath/ath10k/htt_rx.c:113: undefined reference to `dma_unmap_single'
> drivers/built-in.o: In function `ath10k_htt_rx_amsdu_pop':
> drivers/net/wireless/ath/ath10k/htt_rx.c:296: undefined reference to `dma_unmap_single'
> drivers/net/wireless/ath/ath10k/htt_rx.c:389: undefined reference to `dma_unmap_single'
> drivers/built-in.o: In function `__ath10k_htt_rx_ring_fill_n':
> drivers/net/wireless/ath/ath10k/htt_rx.c:146: undefined reference to `dma_map_single'
> drivers/net/wireless/ath/ath10k/htt_rx.c:150: undefined reference to `dma_mapping_error'
> drivers/built-in.o: In function `ath10k_htt_rx_attach':
> drivers/net/wireless/ath/ath10k/htt_rx.c:474: undefined reference to `dma_alloc_coherent'
> drivers/net/wireless/ath/ath10k/htt_rx.c:509: undefined reference to `dma_free_coherent'
> drivers/net/wireless/ath/ath10k/htt_rx.c:514: undefined reference to `dma_free_coherent'
> drivers/built-in.o: In function `ath10k_htt_rx_detach':
> drivers/net/wireless/ath/ath10k/htt_rx.c:220: undefined reference to `dma_unmap_single'
> drivers/net/wireless/ath/ath10k/htt_rx.c:228: undefined reference to `dma_free_coherent'
> drivers/built-in.o: In function `ath10k_skb_map':
> drivers/net/wireless/ath/ath10k/core.h:83: undefined reference to `dma_map_single'
> drivers/net/wireless/ath/ath10k/core.h:86: undefined reference to `dma_mapping_error'
> drivers/built-in.o: In function `ath10k_skb_unmap':
> drivers/net/wireless/ath/ath10k/core.h:98: undefined reference to `dma_unmap_single'
> drivers/built-in.o: In function `ath10k_skb_map':
> drivers/net/wireless/ath/ath10k/core.h:83: undefined reference to `dma_map_single'
> drivers/net/wireless/ath/ath10k/core.h:86: undefined reference to `dma_mapping_error'
> drivers/net/wireless/ath/ath10k/core.h:83: undefined reference to `dma_map_single'
> drivers/net/wireless/ath/ath10k/core.h:86: undefined reference to `dma_mapping_error'
> drivers/built-in.o: In function `ath10k_skb_unmap':
> drivers/net/wireless/ath/ath10k/core.h:98: undefined reference to `dma_unmap_single'
> drivers/net/wireless/ath/ath10k/core.h:98: undefined reference to `dma_unmap_single'
> drivers/net/wireless/ath/ath10k/core.h:98: undefined reference to `dma_unmap_single'
> drivers/net/wireless/ath/ath10k/core.h:98: undefined reference to `dma_unmap_single'
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: linux-wireless@vger.kernel.org

Thanks, I'll take this and send forward.

-- 
Kalle Valo
