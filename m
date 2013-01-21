Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab3AUSNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 13:13:18 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40592 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab3AUSNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 13:13:17 -0500
Date: Mon, 21 Jan 2013 13:13:14 -0500 (EST)
Message-Id: <20130121.131314.1276887267486833907.davem@davemloft.net>
To: thierry.reding@avionic-design.de
Cc: mugunthanvnm@ti.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: davinci: Fix build breakage
From: David Miller <davem@davemloft.net>
In-Reply-To: <1358761119-25846-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358761119-25846-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <thierry.reding@avionic-design.de>
Date: Mon, 21 Jan 2013 10:38:39 +0100

> The correct name of the transmit DMA channel field in struct emac_priv
> is txchan, not txch.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Nothing is more irritating than someone not saying what tree their
patch is targetted for.  My time is not well used by playing a
guessing game about where a patch is supposed to go.

After some futzing around I was able to determine that this patch
is needed for net-next only, but please make a specific mention of
this next time.

Applied, thanks.
