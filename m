Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaHVT3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 15:29:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53560 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaHVT3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 15:29:01 -0400
Date: Fri, 22 Aug 2014 12:29:00 -0700 (PDT)
Message-Id: <20140822.122900.1156200990745708330.davem@davemloft.net>
To: himangi774@gmail.com
Cc: linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] af_decnet: Use time_after_eq
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140820175440.GA4556@himangi-Dell>
References: <20140820175440.GA4556@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 Aug 2014 12:29:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Wed, 20 Aug 2014 23:24:40 +0530

> The functions time_before, time_before_eq, time_after, and time_after_eq
> are more robust for comparing jiffies against other values.
> 
> A simplified version of the Coccinelle semantic patch making this change
> is as follows:
> 
> @change@
> expression E1,E2,E3;
> @@
> - jiffies - E1 >= (E2*E3)
> + time_after_eq(jiffies, E1+E2*E3)
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Applied.
