Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaLZVYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 16:24:09 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40506 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaLZVYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 16:24:06 -0500
Date: Fri, 26 Dec 2014 16:24:03 -0500 (EST)
Message-Id: <20141226.162403.158022430903367528.davem@davemloft.net>
To: johan@kernel.org
Cc: f.fainelli@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bth@kamstrup.dk
Subject: Re: [PATCH] net: phy: micrel: use generic config_init for
 KSZ8021/KSZ8031
From: David Miller <davem@davemloft.net>
In-Reply-To: <1419335957-18020-1-git-send-email-johan@kernel.org>
References: <1419335957-18020-1-git-send-email-johan@kernel.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Dec 2014 13:24:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <johan@kernel.org>
Date: Tue, 23 Dec 2014 12:59:17 +0100

> Use generic config_init callback also for KSZ8021 and KSZ8031.
> 
> This has been avoided this far due to commit b838b4aced99 ("phy/micrel:
> KSZ8031RNL RMII clock reconfiguration bug"), which claims that the PHY
> becomes unresponsive if the broadcast-disable flag is set before
> configuring the clock mode.
> 
> Turns out that the problem seemingly worked-around by the above
> mentioned commit was really due to a hardware-configuration issue, where
> the PHY was in fact strapped to address 3 rather than 0.
> 
> Tested-by: Bruno Thomsen <bth@kamstrup.dk>
> Signed-off-by: Johan Hovold <johan@kernel.org>

Applied, thank you.
