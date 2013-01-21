Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab3AUUpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:45:45 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42793 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab3AUUpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:45:44 -0500
Date: Mon, 21 Jan 2013 15:45:42 -0500 (EST)
Message-Id: <20130121.154542.567604471930324706.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: linux-net-drivers@solarflare.com, kernel-janitors@vger.kernel.org,
        bhutchings@solarflare.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/15] drivers/net/ethernet/sfc/ptp.c: adjust duplicate
 test
From: David Miller <davem@davemloft.net>
In-Reply-To: <1358773378-4700-5-git-send-email-Julia.Lawall@lip6.fr>
References: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr>
	<1358773378-4700-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Mon, 21 Jan 2013 14:02:48 +0100

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Delete successive tests to the same location.  rc was previously tested and
> not subsequently updated.  efx_phc_adjtime can return an error code, so the
> call is updated so that is tested instead.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied to net-next, thanks.
