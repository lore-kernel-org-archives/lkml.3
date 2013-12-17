Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab3LQTnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:43:19 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48402 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab3LQTnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:43:15 -0500
Date: Tue, 17 Dec 2013 14:43:13 -0500 (EST)
Message-Id: <20131217.144313.1563516273987934449.davem@davemloft.net>
To: sebastian.hesselbarth@gmail.com
Cc: f.fainelli@gmail.com, mugunthanvnm@ti.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] net: phy: Ethernet PHY powerdown optimization
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386926429-28818-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1386513631-11284-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1386926429-28818-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 17 Dec 2013 11:43:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date: Fri, 13 Dec 2013 10:20:24 +0100

> This is v2 of the ethernet PHY power optimization patches to reduce
> power consumption of network PHYs with link that are either unused or
> the corresponding netdev is down.
> 
> Compared to the last version, this patch set drops a patch to disable
> unused PHYs after late initcall, as it is not compatible with a modular
> mdio bus [1]. I'll investigate different ways to have a modular mdio bus
> driver get notified when driver loading is done.
> 
> Again, a branch with v2 applied to v3.13-rc2 can also be found at
> https://github.com/shesselba/linux-dove.git topic/ethphy-power-v2
> 
> [1] http://www.spinics.net/lists/arm-kernel/msg293028.html

Series applied, thanks.
