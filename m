Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab3HUGWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 02:22:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52081 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab3HUGWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 02:22:41 -0400
Date: Tue, 20 Aug 2013 23:22:40 -0700 (PDT)
Message-Id: <20130820.232240.98227185752652907.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] bcm63xx_enet: replace devm_request_and_ioremap by
 devm_ioremap_resource
From: David Miller <davem@davemloft.net>
In-Reply-To: <1376911241-27720-6-git-send-email-Julia.Lawall@lip6.fr>
References: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr>
	<1376911241-27720-6-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 20 Aug 2013 23:22:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Mon, 19 Aug 2013 13:20:39 +0200

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Use devm_ioremap_resource instead of devm_request_and_ioremap.
> 
> This was done using the semantic patch
> scripts/coccinelle/api/devm_ioremap_resource.cocci
> 
> The relevant call to platform_get_resource was manually moved down to the
> call to devm_ioremap_resource.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied to net-next, thanks.
