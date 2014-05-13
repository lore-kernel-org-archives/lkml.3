Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbaEMWDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:03:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45693 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbaEMWDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:03:14 -0400
Date: Tue, 13 May 2014 18:03:12 -0400 (EDT)
Message-Id: <20140513.180312.1821582378137845014.davem@davemloft.net>
To: b.galvani@gmail.com
Cc: Alexey.Brodkin@synopsys.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] arc_emac: promiscuous/multicast mode and netpoll
 support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1399824708-2497-1-git-send-email-b.galvani@gmail.com>
References: <1399824708-2497-1-git-send-email-b.galvani@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 13 May 2014 15:03:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Beniamino Galvani <b.galvani@gmail.com>
Date: Sun, 11 May 2014 18:11:46 +0200

> These patches add support for promiscuous mode, multicast filtering
> and netpoll to the ARC EMAC driver.
> 
> They were both tested on a Radxa Rock board which uses a ARC EMAC IP
> core integrated in the Rockchip RK3188 SoC.

Series applied to net-next, thanks.
