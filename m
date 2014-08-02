Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaHBXl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 19:41:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50090 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbaHBXl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 19:41:27 -0400
Date: Sat, 02 Aug 2014 16:41:26 -0700 (PDT)
Message-Id: <20140802.164126.415120903689434848.davem@davemloft.net>
To: himangi774@gmail.com
Cc: paul.gortmaker@windriver.com, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] drivers/net: Use managed interfaces
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140801153003.GA11527@himangi-Dell>
References: <20140801153003.GA11527@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 02 Aug 2014 16:41:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Fri, 1 Aug 2014 21:00:03 +0530

> This patch introduces the use of managed interfaces like
> devm_ioremap_resource and does away with the calls to free the
> allocated memory in the probe and remove functions. Also, some
> labels and variable are done away with. This fixes a bug as there
> was a missing release_mem_region in the remove function.
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

I adjusted the Subject subsystem prefix to "net: dnet:" and applied
this, thanks.
