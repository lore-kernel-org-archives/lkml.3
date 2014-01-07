Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbaAGF4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 00:56:11 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37648 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbaAGF4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 00:56:09 -0500
Date: Tue, 07 Jan 2014 00:56:07 -0500 (EST)
Message-Id: <20140107.005607.716747884959539511.davem@davemloft.net>
To: shh.xie@gmail.com
Cc: jg1.han@samsung.com, mugunthanvnm@ti.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shaohui.Xie@freescale.com, afleming@gmail.com
Subject: Re: [PATCH 5/6] [v4] phylib: Support attaching to generic 10g
 driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389060865-7143-1-git-send-email-shh.xie@gmail.com>
References: <1389060865-7143-1-git-send-email-shh.xie@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 06 Jan 2014 21:56:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <shh.xie@gmail.com>
Date: Tue, 7 Jan 2014 10:14:25 +0800

> -static int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
> +int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
>  			     u32 flags, phy_interface_t interface)

Since you are changing where the open parenthesis is, you must reindent
the arguments on the second line so that they start exactly at the
first column after that openning parenthesis.
