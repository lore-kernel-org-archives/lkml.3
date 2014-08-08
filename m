Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaHHR3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 13:29:10 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60353 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaHHR3H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 13:29:07 -0400
Date: Fri, 08 Aug 2014 10:29:06 -0700 (PDT)
Message-Id: <20140808.102906.1434751133512128265.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: anirudh@xilinx.com, kernel-janitors@vger.kernel.org, John.Linn@xilinx.com,
        michal.simek@xilinx.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        u.kleine-koenig@pengutronix.de
Subject: Re: [PATCH 2/14] net: axienet: delete unneeded test before
 of_node_put
From: David Miller <davem@davemloft.net>
In-Reply-To: <1407492475-26283-2-git-send-email-Julia.Lawall@lip6.fr>
References: <1407492475-26283-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 08 Aug 2014 10:29:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Fri,  8 Aug 2014 12:07:43 +0200

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Of_node_put supports NULL as its argument, so the initial test is not
> necessary.
> 
> Suggested by Uwe Kleine-König.
> 
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied.
