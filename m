Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab3FTFTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 01:19:30 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49399 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab3FTFT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 01:19:28 -0400
Date: Wed, 19 Jun 2013 22:19:28 -0700 (PDT)
Message-Id: <20130619.221928.858650471566973618.davem@davemloft.net>
To: lkundrak@v3.sk
Cc: buytenh@wantstofly.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mv643xx_eth: Allocate receive queue initialized to zero
From: David Miller <davem@davemloft.net>
In-Reply-To: <1371576759-21782-1-git-send-email-lkundrak@v3.sk>
References: <1371576759-21782-1-git-send-email-lkundrak@v3.sk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lubomir Rintel <lkundrak@v3.sk>
Date: Tue, 18 Jun 2013 19:32:38 +0200

> Zero pointer in rx_skb is how respective rxq_deinit() finds out out that a skb
> slot is unallocated. If rxq_refill() fails (e.g. on OOM condition), subsequent
> teardown would result in an attempt to kfree() invalid pointers.
> 
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>

Applied.
