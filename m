Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbaDCUO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 16:14:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46640 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbaDCUOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 16:14:23 -0400
Date: Thu, 03 Apr 2014 16:15:51 -0400 (EDT)
Message-Id: <20140403.161551.122482244018928134.davem@davemloft.net>
To: p.zabel@pengutronix.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, frdrc66@gmail.com,
        kernel@pengutronix.de
Subject: Re: [PATCH v2] net: Micrel KSZ8864RMN 4-port managed switch support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1396517290-4123-1-git-send-email-p.zabel@pengutronix.de>
References: <1396517290-4123-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 03 Apr 2014 13:14:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philipp Zabel <p.zabel@pengutronix.de>
Date: Thu,  3 Apr 2014 11:28:10 +0200

> This patch adds support for the Micrel KSZ8864RMN switch to the spi_ks8995
> driver. The KSZ8864RMN switch has a wider 256-byte register space.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Applied, thanks.
