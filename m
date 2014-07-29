Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbaG2Wcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 18:32:31 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49821 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbaG2Wc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 18:32:29 -0400
Date: Tue, 29 Jul 2014 15:32:27 -0700 (PDT)
Message-Id: <20140729.153227.910850620944303115.davem@davemloft.net>
To: himangi774@gmail.com
Cc: pshelar@nicira.com, dev@openvswitch.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] openvswitch: Use IS_ERR_OR_NULL
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140727070746.GA4825@himangi-Dell>
References: <20140727070746.GA4825@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Jul 2014 15:32:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Sun, 27 Jul 2014 12:37:46 +0530

> This patch introduces the use of the macro IS_ERR_OR_NULL in place of
> tests for NULL and IS_ERR.
> 
> The following Coccinelle semantic patch was used for making the change:
> 
> @@
> expression e;
> @@
> 
> - e == NULL || IS_ERR(e)
> + IS_ERR_OR_NULL(e)
>  || ...
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Applied.
