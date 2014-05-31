Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161034AbaEaAtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 20:49:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60957 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161016AbaEaAty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 20:49:54 -0400
Date: Fri, 30 May 2014 17:49:53 -0700 (PDT)
Message-Id: <20140530.174953.1755997377617855664.davem@davemloft.net>
To: himangi774@gmail.com
Cc: chien.yen@oracle.com, rds-devel@oss.oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] RDS/RDMA: Replace comma with semicolon
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140530154605.GA4049@himangi-Dell>
References: <20140530154605.GA4049@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 May 2014 17:49:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Fri, 30 May 2014 21:16:05 +0530

> This patch replaces a comma between expression statements by a semicolon.
> 
> A simplified version of the semantic patch that performs this
> transformation is as follows:
 ...
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Applied.
