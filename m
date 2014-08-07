Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbaHGXGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 19:06:47 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53663 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbaHGXGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 19:06:43 -0400
Date: Thu, 07 Aug 2014 16:06:42 -0700 (PDT)
Message-Id: <20140807.160642.1780454276654586342.davem@davemloft.net>
To: himangi774@gmail.com
Cc: paul.gortmaker@windriver.com, w-lkml@lebenslange-mailadresse.de,
        balbi@ti.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH] drivers/net: ethernet: Remove typedef for struct and
 enum
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140807203915.GA21337@himangi-Dell>
References: <20140807203915.GA21337@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Aug 2014 16:06:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Fri, 8 Aug 2014 02:09:16 +0530

> The Linux kernel coding style guidelines suggest not using typedefs
> for structure and enum types. This patch gets rid of the typedef for
> cardtype_t and local_info_t. Also, the names of the struct and enum
> are changed to drop the _t, to make the name look less typedef-like.
> 
> The following Coccinelle semantic patch detects the case for struct type:
...
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Applied.
