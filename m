Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964898Ab3FTFTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 01:19:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49401 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab3FTFTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 01:19:36 -0400
Date: Wed, 19 Jun 2013 22:19:36 -0700 (PDT)
Message-Id: <20130619.221936.645815291796203336.davem@davemloft.net>
To: lkundrak@v3.sk
Cc: konszert@marvell.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] pxa168_eth: Allocate receive queue initialized to
 zero
From: David Miller <davem@davemloft.net>
In-Reply-To: <1371576648-21632-1-git-send-email-lkundrak@v3.sk>
References: <1371576648-21632-1-git-send-email-lkundrak@v3.sk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lubomir Rintel <lkundrak@v3.sk>
Date: Tue, 18 Jun 2013 19:30:48 +0200

> Zero pointer in rx_skb or tx_skb is how respective *_deinit() functions find
> out that a skb slot is unallocated. If *_init() functions unsuccessfully return
> after the allocation (e.g. when subsequent dma_alloc_coherent() is not
> successful), this would result in attempt to kfree() invalid pointers.
> 
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>

Applied.
