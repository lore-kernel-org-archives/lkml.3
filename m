Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab3LLAyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 19:54:21 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60785 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3LLAyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 19:54:19 -0500
Date: Wed, 11 Dec 2013 19:54:17 -0500 (EST)
Message-Id: <20131211.195417.709076824951663618.davem@davemloft.net>
To: olof@lixom.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/2] net: eth: davinci_cpdma: 64-bit phys/dma_addr_t
 cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386805882-25360-1-git-send-email-olof@lixom.net>
References: <1386805882-25360-1-git-send-email-olof@lixom.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 11 Dec 2013 16:54:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olof Johansson <olof@lixom.net>
Date: Wed, 11 Dec 2013 15:51:20 -0800

> Silences the below warnings when building with ARM_LPAE enabled, which
> gives longer dma_addr_t by default:
> 
> drivers/net/ethernet/ti/davinci_cpdma.c: In function 'cpdma_desc_pool_create':
> drivers/net/ethernet/ti/davinci_cpdma.c:182:3: warning: passing argument 3 of 'dma_alloc_attrs' from incompatible pointer type [enabled by default]
> drivers/net/ethernet/ti/davinci_cpdma.c: In function 'desc_phys':
> drivers/net/ethernet/ti/davinci_cpdma.c:222:25: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
> drivers/net/ethernet/ti/davinci_cpdma.c:223:8: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>

Applied.
