Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763187Ab3IDRSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 13:18:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40894 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763158Ab3IDRSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 13:18:40 -0400
Date: Wed, 04 Sep 2013 13:18:37 -0400 (EDT)
Message-Id: <20130904.131837.936191711263259013.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: mcuos.com@gmail.com, kernel-janitors@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers:net: delete premature free_irq
From: David Miller <davem@davemloft.net>
In-Reply-To: <1378115661-5371-3-git-send-email-Julia.Lawall@lip6.fr>
References: <1378115661-5371-1-git-send-email-Julia.Lawall@lip6.fr>
	<1378115661-5371-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 04 Sep 2013 10:18:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Mon,  2 Sep 2013 11:54:21 +0200

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Free_irq is not needed if there has been no request_irq.  Free_irq is
> removed from both the probe and remove functions.  The correct request_irq
> and free_irq are found in the open and close functions.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied, thank you.
