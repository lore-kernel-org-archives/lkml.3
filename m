Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbaJJEvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 00:51:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45613 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaJJEvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 00:51:48 -0400
Date: Fri, 10 Oct 2014 00:51:46 -0400 (EDT)
Message-Id: <20141010.005146.105821454500503183.davem@davemloft.net>
To: christophe.leroy@c-s.fr
Cc: pantelis.antoniou@gmail.com, vbordug@ru.mvista.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: fs_enet: error: 'SCCE_ENET_TXF' undeclared
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141009145443.74AD61AB275@localhost.localdomain>
References: <20141009145443.74AD61AB275@localhost.localdomain>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Oct 2014 21:51:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>
Date: Thu,  9 Oct 2014 16:54:43 +0200 (CEST)

> [linux-devel:devel-hourly-2014100909 3763/3915] drivers/net/ethernet/freescale/fs_enet/mac-scc.c:119:32: error: 'SCCE_ENET_TXF' undeclared
> 
> Due to patch d43a396 net: fs_enet: Add NAPI TX, it appears that some target
> compilations are broken.
> This is due to the fact that unlike the FEC, the SCC and FCC don't have a TXF
> event (complete Frame transmitted) but only TXB (buffer transmitted).
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

Applied, thanks.
