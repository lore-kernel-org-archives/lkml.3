Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbaHQDQR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 23:16:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57968 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaHQDQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 23:16:16 -0400
Date: Sat, 16 Aug 2014 20:16:29 -0700 (PDT)
Message-Id: <20140816.201629.1009178063004110712.davem@davemloft.net>
To: gwenhael.goavec-merou@armadeus.com
Cc: linux-kernel@vger.kernel.org, f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: smsc: move smsc_phy_config_init reset
 part in a soft_reset function
From: David Miller <davem@davemloft.net>
In-Reply-To: <1408107638-96143-1-git-send-email-gwenhael.goavec-merou@armadeus.com>
References: <1408107638-96143-1-git-send-email-gwenhael.goavec-merou@armadeus.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Aug 2014 20:16:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gwenhael Goavec-Merou <gwenhael.goavec-merou@armadeus.com>
Date: Fri, 15 Aug 2014 15:00:38 +0200

> On the one hand, phy_device.c provides a generic reset function if the phy
> driver does not provide a soft_reset pointer. This generic reset does not take
> into account the state of the phy, with a potential failure if the phy is in
> powerdown mode. On the other hand, smsc driver provides a function with both
> correct reset behaviour and configuration.
> 
> This patch moves the reset part into a new smsc_phy_reset function and provides
> the soft_reset pointer to have a correct reset behaviour by default.
> 
> Signed-off-by: Gwenhael Goavec-Merou <gwenhael.goavec-merou@armadeus.com>

Applied, thanks.
