Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbaHGXFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 19:05:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53627 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbaHGXFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 19:05:11 -0400
Date: Thu, 07 Aug 2014 16:05:10 -0700 (PDT)
Message-Id: <20140807.160510.734997025610406474.davem@davemloft.net>
To: julia.lawall@lip6.fr
Cc: chas@cmf.nrl.navy.mil, kernel-janitors@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] drivers/atm/atmtcp.c: fix error return code
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.10.1408071530230.2337@hadrien>
References: <1407415749-19978-3-git-send-email-Julia.Lawall@lip6.fr>
	<20140807091012.793ef5c7@thirdoffive.cmf.nrl.navy.mil>
	<alpine.DEB.2.10.1408071530230.2337@hadrien>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Aug 2014 16:05:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia.lawall@lip6.fr>
Date: Thu, 7 Aug 2014 15:31:05 +0200 (CEST)

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Convert a zero return value on error to a negative one, as returned
> elsewhere in the function.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
> v2; changed error code to -EUNATCH

Applied.
