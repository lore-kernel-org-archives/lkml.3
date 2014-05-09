Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbaEIUjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 16:39:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39499 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173AbaEIUjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 16:39:35 -0400
Date: Fri, 09 May 2014 16:39:33 -0400 (EDT)
Message-Id: <20140509.163933.1063955800318301161.davem@davemloft.net>
To: arnd@arndb.de
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        grygorii.strashko@ti.com, f.fainelli@gmail.com,
        sergei.shtylyov@cogentembedded.com, prabhakar.csengg@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] mdio_bus: fix devm_mdiobus_alloc_size export
From: David Miller <davem@davemloft.net>
In-Reply-To: <1399560433-1402630-2-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
	<1399560433-1402630-2-git-send-email-arnd@arndb.de>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 09 May 2014 13:39:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Thu,  8 May 2014 16:46:52 +0200

> commit 6d48f44b7b2 "mdio_bus: implement devm_mdiobus_alloc/devm_mdiobus_free"
> introduced a new function devm_mdiobus_alloc_size() but added an export
> for a different function devm_mdiobus_alloc(), which was obviously
> a simple mistake that leads to  build error whenever this function is
> used from a loadable module:
> 
> ERROR: "devm_mdiobus_alloc_size" [drivers/net/ethernet/ti/davinci_mdio.ko] undefined!
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied to net-next, thanks Arnd.
