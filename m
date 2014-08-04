Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaHDTzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:55:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45453 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaHDTzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:55:45 -0400
Date: Mon, 04 Aug 2014 12:55:43 -0700 (PDT)
Message-Id: <20140804.125543.174590535265021164.davem@davemloft.net>
To: himangi774@gmail.com
Cc: f.fainelli@gmail.com, paul.gortmaker@windriver.com, p.zabel@pengutronix.de,
        jg1.han@samsung.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH v2] net: phy: spi_ks8995: Introduce the use of
 devm_kzalloc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140803080943.GA4323@himangi-Dell>
References: <20140803080943.GA4323@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 Aug 2014 12:55:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Sun, 3 Aug 2014 13:39:43 +0530

> This patch introduces the use of devm_kzalloc and does away with the
> kfrees in the probe and remove functions. Also, a label is removed.
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Applied, thank you.
