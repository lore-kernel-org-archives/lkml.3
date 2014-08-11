Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbaHKTUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 15:20:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58309 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbaHKTUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 15:20:36 -0400
Date: Mon, 11 Aug 2014 12:20:35 -0700 (PDT)
Message-Id: <20140811.122035.470900770848969335.davem@davemloft.net>
To: himangi774@gmail.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH] airo_cs: Remove typedef local_info_t
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140809164623.GA21522@himangi-Dell>
References: <20140809164623.GA21522@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 Aug 2014 12:20:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Sat, 9 Aug 2014 22:16:23 +0530

> The Linux kernel coding style guidelines suggest not using typedefs
> for structure types. This patch gets rid of the typedef for
> local_info_t. Also, the name of the struct is changed to drop the _t,
> to make the name look less typedef-like.
> 
> The following Coccinelle semantic patch detects the case:
 ...
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Applied.
