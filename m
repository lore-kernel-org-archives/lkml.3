Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbaHGXHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 19:07:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53675 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbaHGXHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 19:07:00 -0400
Date: Thu, 07 Aug 2014 16:06:59 -0700 (PDT)
Message-Id: <20140807.160659.413581430334650996.davem@davemloft.net>
To: himangi774@gmail.com
Cc: tedheadster@gmail.com, paul.gortmaker@windriver.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH] drivers/net: Remove typedef axnet_dev_t
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140807204133.GA21448@himangi-Dell>
References: <20140807204133.GA21448@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Aug 2014 16:07:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Fri, 8 Aug 2014 02:11:33 +0530

> The Linux kernel coding style guidelines suggest not using typedefs
> for structure types. This patch gets rid of the typedef for axnet_dev_t.
> Also, the name of the struct is changed to drop the _t, to make the
> name look less typedef-like.
> 
> The following Coccinelle semantic patch detects the case:
 ...
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Applied.
