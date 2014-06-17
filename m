Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967667AbaFQWbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:31:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57294 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966369AbaFQWbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 18:31:15 -0400
Date: Tue, 17 Jun 2014 15:31:14 -0700 (PDT)
Message-Id: <20140617.153114.745988923921147057.davem@davemloft.net>
To: himangi774@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH v2] net/nxp/lpc_eth: use devm_ functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140613180356.GA8582@himangi-Dell>
References: <20140613180356.GA8582@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Jun 2014 15:31:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Fri, 13 Jun 2014 23:33:56 +0530

> The various devm_ functions allocate memory that is released when a
> driver detaches. This patch uses dmam_alloc_coherent, devm_ioremap
> devm_clk_get etc. for data that is allocated in the probe function of
> platform device and is only freed in the remove function. The
> corresponding free functions are removed and many labels are done
> away with.
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
> v2: undo use of devm_request_irq
> Not compile tested

This doesn't apply cleanly to any of my trees.
