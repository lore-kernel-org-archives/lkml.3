Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbaHKTUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 15:20:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58301 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbaHKTUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 15:20:17 -0400
Date: Mon, 11 Aug 2014 12:20:16 -0700 (PDT)
Message-Id: <20140811.122016.420002190905067268.davem@davemloft.net>
To: himangi774@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] com20020_cs: Remove typedef com20020_dev_t
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140809160718.GA15251@himangi-Dell>
References: <20140809160718.GA15251@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 Aug 2014 12:20:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Sat, 9 Aug 2014 21:37:18 +0530

> The Linux kernel coding style guidelines suggest not using typedefs
> for structure types. This patch gets rid of the typedef for
> com20020_dev_t. Also, the name of the struct is changed to drop the
> _t, to make the name look less typedef-like.
> 
> The following Coccinelle semantic patch detects the case:
 ...
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Applied.
