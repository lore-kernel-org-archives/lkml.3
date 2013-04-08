Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965171Ab3DHU5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:57:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52853 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964971Ab3DHU45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:56:57 -0400
Date: Mon, 08 Apr 2013 16:56:55 -0400 (EDT)
Message-Id: <20130408.165655.1503589676064125796.davem@davemloft.net>
To: sebastian.hesselbarth@gmail.com
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, florian@openwrt.org,
        devicetree-discuss@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: of_mdio: scan mdiobus for PHYs without reg
 property
From: David Miller <davem@davemloft.net>
In-Reply-To: <1365332988-9053-2-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1365332988-9053-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1365332988-9053-2-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 08 Apr 2013 13:56:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date: Sun,  7 Apr 2013 13:09:48 +0200

> Using DT for mdiobus and ethernet-phy requires to know the PHY address, which
> is hard to guess if you don't know it. This patch extends of_mdiobus_register
> to scan mdiobus for PHYs if reg property of the corresponding node is not set.
> This also allows to have phy nodes in SoC DT files where the reg property can
> be overwritten in the board file later. To encourage people to finally set the
> actual phy address, the mdiobus scan is noisier than required.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Applied.
