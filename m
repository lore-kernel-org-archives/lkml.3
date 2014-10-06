Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaJFEqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 00:46:52 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57805 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaJFEqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 00:46:48 -0400
Date: Mon, 06 Oct 2014 00:46:46 -0400 (EDT)
Message-Id: <20141006.004646.685997864382345892.davem@davemloft.net>
To: gang.chen.5i5j@gmail.com
Cc: f.fainelli@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        richard@nod.at
Subject: Re: [PATCH] drivers/net/phy/Kconfig: Let MDIO_BCM_UNIMAC depend on
 HAS_IOMEM
From: David Miller <davem@davemloft.net>
In-Reply-To: <542FC3D9.4080607@gmail.com>
References: <542FC3D9.4080607@gmail.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Oct 2014 21:46:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen Gang <gang.chen.5i5j@gmail.com>
Date: Sat, 04 Oct 2014 17:54:33 +0800

> MDIO_BCM_UNIMAC needs HAS_IOMEM, so depend on it, the related error (
> with allmodconfig under um):
> 
>     MODPOST 1205 modules
>   ERROR: "devm_ioremap" [drivers/net/phy/mdio-bcm-unimac.ko] undefined!
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Applied, thanks.
