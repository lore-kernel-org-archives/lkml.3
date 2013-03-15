Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3COMxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 08:53:10 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46965 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab3COMxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 08:53:08 -0400
Date: Fri, 15 Mar 2013 08:53:21 -0400 (EDT)
Message-Id: <20130315.085321.1047694772636447477.davem@davemloft.net>
To: florian@openwrt.org
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        jason@lakedaemon.net, andrew@lunn.ch, linux@arm.linux.org.uk,
        benh@kernel.crashing.org, paulus@samba.org, buytenh@wantstofly.org,
        thomas.petazzoni@free-electrons.com, gregkh@linuxfoundation.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] mv643xx_eth: use mvmdio MDIO bus driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1363284515-9865-1-git-send-email-florian@openwrt.org>
References: <1359473048-26551-1-git-send-email-florian@openwrt.org>
	<1363284515-9865-1-git-send-email-florian@openwrt.org>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 15 Mar 2013 05:53:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Fainelli <florian@openwrt.org>
Date: Thu, 14 Mar 2013 19:08:31 +0100

> This patch converts the mv643xx_eth driver to use the mvmdio MDIO bus driver
> instead of rolling its own implementation. As a result, all users of this
> mv643xx_eth driver are converted to register an "orion-mdio" platform_device.
> The mvmdio driver is also updated to support an interrupt line which reports
> SMI error/completion, and to allow traditionnal platform device registration
> instead of just device tree.
> 
> David, I think it makes sense for you to merge all of this, since we do
> not want the architecture files to be desynchronized from the mv643xx_eth to
> avoid runtime breakage. The potential for merge conflicts should be very small.

All applied to net-next, thanks.
