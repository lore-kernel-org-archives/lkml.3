Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbaJ1SuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:50:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34022 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaJ1SuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:50:08 -0400
Date: Tue, 28 Oct 2014 14:50:05 -0400 (EDT)
Message-Id: <20141028.145005.360870681646781420.davem@davemloft.net>
To: vndao@altera.com
Cc: f.fainelli@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ngachi86@gmail.com
Subject: Re: [net-next] net: phy: Adding SGMII support for Marvell 88ee1145
 driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1414118877-12837-1-git-send-email-vndao@altera.com>
References: <1414118877-12837-1-git-send-email-vndao@altera.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Oct 2014 11:50:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <vndao@altera.com>
Date: Thu, 23 Oct 2014 19:47:57 -0700

> From: Viet Nga Dao <vndao@altera.com>
> 
> Additional code to m88e1145_config_init function to allow the driver to
> support SGMII mode.
> 
> Signed-off-by: Viet Nga Dao <vndao@altera.com>

Applied.
