Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbaEOU6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:58:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36123 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbaEOU6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:58:23 -0400
Date: Thu, 15 May 2014 16:58:20 -0400 (EDT)
Message-Id: <20140515.165820.1971129599767939900.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: steffen.klassert@secunet.com, kernel-janitors@vger.kernel.org,
        herbert@gondor.apana.org.au, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] vti6: delete unneeded call to netdev_priv
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400125401-15512-4-git-send-email-Julia.Lawall@lip6.fr>
References: <1400125401-15512-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 May 2014 13:58:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Thu, 15 May 2014 05:43:21 +0200

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Netdev_priv is an accessor function, and has no purpose if its result is
> not used.
> 
> A simplified version of the semantic match that fixes this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@ local idexpression x; @@
> -x = netdev_priv(...);
> ... when != x
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied.
