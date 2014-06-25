Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934AbaFYXcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 19:32:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39178 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbaFYXcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 19:32:03 -0400
Date: Wed, 25 Jun 2014 16:32:00 -0700 (PDT)
Message-Id: <20140625.163200.509097762043557956.davem@davemloft.net>
To: maxime.ripard@free-electrons.com
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] net: allwinner: emac: Add missing free_irq
From: David Miller <davem@davemloft.net>
In-Reply-To: <1403556580-21818-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1403556580-21818-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Jun 2014 16:32:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Ripard <maxime.ripard@free-electrons.com>
Date: Mon, 23 Jun 2014 22:49:40 +0200

> If the mdio probe function fails in emac_open, the interrupt we just requested
> isn't freed. If emac_open is called again, for example because we try to set up
> the interface again, the kernel will oops because the interrupt wasn't properly
> released.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Cc: <stable@vger.kernel.org> # 3.11+

Applied, thank you.
