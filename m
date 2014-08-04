Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaHDTi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:38:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45164 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbaHDTi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:38:56 -0400
Date: Mon, 04 Aug 2014 12:38:53 -0700 (PDT)
Message-Id: <20140804.123853.791933051871769418.davem@davemloft.net>
To: himangi774@gmail.com
Cc: luka@openwrt.org, rmk+kernel@arm.linux.org.uk, david.daney@cavium.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH] netdev: octeon_mgmt: Use devm_ioremap_resource
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140731070653.GA3759@himangi-Dell>
References: <20140731070653.GA3759@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 Aug 2014 12:38:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Thu, 31 Jul 2014 12:36:53 +0530

> This patch introduces the use of devm_ioremap_resource instead of
> devm_request_mem_region and devm_ioremap. The error handling on the
> platform_get_resource is done way with. The size and start fields in the
> octeon_mgmt are no longer needed. So they are removed and there
> initialization skipped. Also, error handling is added on the values
> returned by devm_ioremap_resource.
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
> Not compile tested.

David Daney provided you with a mechanism by which you could
compile test this change, and then I see no response at all
from you after that.

I'm not applying this until it is at least compile tested.
