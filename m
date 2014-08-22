Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaHVT2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 15:28:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53549 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaHVT2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 15:28:51 -0400
Date: Fri, 22 Aug 2014 12:28:50 -0700 (PDT)
Message-Id: <20140822.122850.930825136664297515.davem@davemloft.net>
To: himangi774@gmail.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH] ipconfig: Use time_before
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140820174410.GA4225@himangi-Dell>
References: <20140820174410.GA4225@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 Aug 2014 12:28:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Wed, 20 Aug 2014 23:14:10 +0530

> The functions time_before, time_before_eq, time_after, and time_after_eq
> are more robust for comparing jiffies against other values.
> 
> A simplified version of the Coccinelle semantic patch making this change
> is as follows:
> 
> @change@
> expression E1,E2;
> @@
> - jiffies - E1 < E2
> + time_before(jiffies, E1+E2)
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Applied.
