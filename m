Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933733AbaHZA0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 20:26:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39812 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933658AbaHZA0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 20:26:11 -0400
Date: Mon, 25 Aug 2014 17:26:10 -0700 (PDT)
Message-Id: <20140825.172610.496537032439062803.davem@davemloft.net>
To: jonas.jensen@gmail.com
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, f.fainelli@gmail.com,
        eric.dumazet@gmail.com, mirqus@gmail.com
Subject: Re: [PATCH v6 3/4] net: moxa: synchronize DMA memory
From: David Miller <davem@davemloft.net>
In-Reply-To: <1408976552-15659-1-git-send-email-jonas.jensen@gmail.com>
References: <1408976552-15659-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 Aug 2014 17:26:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Jensen <jonas.jensen@gmail.com>
Date: Mon, 25 Aug 2014 16:22:32 +0200

> DMA memory should be synchronized before data is passed
> to/from controller.
> 
> Add dma_sync_single_for_cpu(.., DMA_FROM_DEVICE) to RX path
> and dma_sync_single_for_device(.., DMA_TO_DEVICE) to TX path.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>

Applied.
