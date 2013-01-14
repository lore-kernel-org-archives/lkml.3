Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651Ab3ANUMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 15:12:19 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33198 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282Ab3ANUMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 15:12:18 -0500
Date: Mon, 14 Jan 2013 15:12:14 -0500 (EST)
Message-Id: <20130114.151214.1296751187134652417.davem@davemloft.net>
To: florian@openwrt.org
Cc: netdev@vger.kernel.org, konszert@marvell.com, afleming@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: remove flags argument from
 phy_{attach,connect,connect_direct}
From: David Miller <davem@davemloft.net>
In-Reply-To: <1358160772-29631-1-git-send-email-florian@openwrt.org>
References: <1358160772-29631-1-git-send-email-florian@openwrt.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Fainelli <florian@openwrt.org>
Date: Mon, 14 Jan 2013 11:52:52 +0100

> The flags argument of the phy_{attach,connect,connect_direct} functions
> is then used to assign a struct phy_device dev_flags with its value.
> All callers but the tg3 driver pass the flag 0, which results in the
> underlying PHY drivers in drivers/net/phy/ not being able to actually
> use any of the flags they would set in dev_flags. This patch gets rid of
> the flags argument, and passes phydev->dev_flags to the internal PHY
> library call phy_attach_direct() such that drivers which actually modify
> a phy device dev_flags get the value preserved for use by the underlying
> phy driver.
> 
> Acked-by: Kosta Zertsekel <konszert@marvell.com>
> Signed-off-by: Florian Fainelli <florian@openwrt.org>

Applied, thanks.
