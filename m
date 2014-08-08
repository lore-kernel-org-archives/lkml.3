Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaHHR3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 13:29:01 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60348 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaHHR27 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 13:28:59 -0400
Date: Fri, 08 Aug 2014 10:28:58 -0700 (PDT)
Message-Id: <20140808.102858.2296909606267579093.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: michal.simek@xilinx.com, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, u.kleine-koenig@pengutronix.de
Subject: Re: [PATCH 12/14] ll_temac: delete unneeded test before of_node_put
From: David Miller <davem@davemloft.net>
In-Reply-To: <1407492475-26283-12-git-send-email-Julia.Lawall@lip6.fr>
References: <1407492475-26283-12-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 08 Aug 2014 10:28:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Fri,  8 Aug 2014 12:07:53 +0200

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
