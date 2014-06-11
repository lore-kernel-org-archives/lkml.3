Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbaFKWRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 18:17:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47559 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaFKWRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 18:17:51 -0400
Date: Wed, 11 Jun 2014 15:17:50 -0700 (PDT)
Message-Id: <20140611.151750.163707451871716166.davem@davemloft.net>
To: neidhard.kim@lge.com
Cc: netdev@vger.kernel.org, r58129@freescale.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: realtek: register/unregister multiple
 drivers properly
From: David Miller <davem@davemloft.net>
In-Reply-To: <1402372212-19553-1-git-send-email-neidhard.kim@lge.com>
References: <1402372212-19553-1-git-send-email-neidhard.kim@lge.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Jun 2014 15:17:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jongsung Kim <neidhard.kim@lge.com>
Date: Tue, 10 Jun 2014 12:50:12 +0900

> Using phy_drivers_register/_unregister functions is proper way to
> handle multiple PHY drivers registration. For Realtek PHY drivers
> module, it fixes incomplete current error-handlings up and adds
> missed unregistration for the RTL8201CP driver.
> 
> Signed-off-by: Jongsung Kim <neidhard.kim@lge.com>

Applied, thank you.
