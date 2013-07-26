Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183Ab3GZU6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:58:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37058 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760067Ab3GZU6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:58:22 -0400
Date: Fri, 26 Jul 2013 13:58:21 -0700 (PDT)
Message-Id: <20130726.135821.1562114212326650459.davem@davemloft.net>
To: maxime.ripard@free-electrons.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] drivers: net: sun4i-emac: select MDIO_SUN4I
From: David Miller <davem@davemloft.net>
In-Reply-To: <1374649928-26007-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1374649928-26007-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 26 Jul 2013 13:58:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Ripard <maxime.ripard@free-electrons.com>
Date: Wed, 24 Jul 2013 09:12:08 +0200

> The EMAC driver can't work without its associated PHY driver. Reflect
> this in the Kconfig options by selecting it.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Applied.
