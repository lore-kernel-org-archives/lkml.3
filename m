Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab3HOIjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 04:39:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37870 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab3HOIjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 04:39:09 -0400
Date: Thu, 15 Aug 2013 01:39:07 -0700 (PDT)
Message-Id: <20130815.013907.319502653692029822.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: romieu@fr.zoreil.com, roszenrami@gmail.com, dshwatrz@gmail.com,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com
Subject: Re: [PATCH] drivers/net/ethernet/via/via-velocity.c: update napi
 implementation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1376490413-12067-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376490413-12067-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 15 Aug 2013 01:39:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Wed, 14 Aug 2013 16:26:53 +0200

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Drivers supporting NAPI should use a NAPI-specific function for receiving
> packets.  Hence netif_rx is changed to netif_receive_skb.
> 
> Furthermore netif_napi_del should be used in the probe and remove function
> to clean up the NAPI resource information.
> 
> Thanks to Francois Romieu, David Shwatrz and Rami Rosen for their help on
> this patch.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied, thanks.
