Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbaJJTgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 15:36:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56425 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbaJJTgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 15:36:07 -0400
Date: Fri, 10 Oct 2014 15:36:05 -0400 (EDT)
Message-Id: <20141010.153605.275901680055082156.davem@davemloft.net>
To: s.hauer@pengutronix.de
Cc: f.fainelli@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH v2] net/phy: micrel: Add clock support for
 KSZ8021/KSZ8031
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412927285-6809-1-git-send-email-s.hauer@pengutronix.de>
References: <1412927285-6809-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Oct 2014 12:36:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>
Date: Fri, 10 Oct 2014 09:48:05 +0200

> The KSZ8021 and KSZ8031 support RMII reference input clocks of 25MHz
> and 50MHz. Both PHYs differ in the default frequency they expect
> after reset. If this differs from the actual input clock, then
> register 0x1f bit 7 must be changed.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

Applied, thanks.
