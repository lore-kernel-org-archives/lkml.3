Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab3EHUOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 16:14:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41738 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab3EHUOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 16:14:49 -0400
Date: Wed, 08 May 2013 13:14:48 -0700 (PDT)
Message-Id: <20130508.131448.594837732354914619.davem@davemloft.net>
To: sebastian.hesselbarth@gmail.com
Cc: grant.likely@linaro.org, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: of_mdio: fix behavior on missing phy device
From: David Miller <davem@davemloft.net>
In-Reply-To: <1367920171-20264-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1367920171-20264-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 08 May 2013 13:14:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date: Tue,  7 May 2013 11:49:31 +0200

> of_mdiobus_register creates a phy_device even if get_phy_device failed
> to create it previously. This causes indefinite polling on non-existent
> PHYs. This fix makes of_mdio_register rely on get_phy_device to
> properly create the device or fail otherwise.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Applied.
