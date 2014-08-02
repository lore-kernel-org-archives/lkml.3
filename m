Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaHBXlP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 19:41:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50085 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaHBXlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 19:41:12 -0400
Date: Sat, 02 Aug 2014 16:41:10 -0700 (PDT)
Message-Id: <20140802.164110.991385652436936022.davem@davemloft.net>
To: himangi774@gmail.com
Cc: jg1.han@samsung.com, michael.opdenacker@free-electrons.com,
        arend@broadcom.com, joe@perches.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] net: ks8851-ml: Use devm_ioremap_resource
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140801152913.GA11494@himangi-Dell>
References: <20140801152913.GA11494@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 02 Aug 2014 16:41:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Fri, 1 Aug 2014 20:59:13 +0530

> This patch introduces the use of devm_ioremap_resource, devm_kmalloc and
> does away with the functions to free the allocated memory in the probe
> and remove functions. Also, some labels are done away with. A bug is
> fixed as two regions are allocated in the probe function, but only one
> is freed in the remove function.
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Applied.
