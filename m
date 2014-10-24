Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbaJXTum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 15:50:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52609 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409AbaJXTui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 15:50:38 -0400
Date: Fri, 24 Oct 2014 15:50:31 -0400 (EDT)
Message-Id: <20141024.155031.1468501419050363586.davem@davemloft.net>
To: sebastian.hesselbarth@gmail.com
Cc: antoine.tenart@free-electrons.com, f.fainelli@gmail.com,
        eric.y.miao@gmail.com, haojian.zhuang@gmail.com,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] Marvell PXA168 libphy handling and Berlin
 Ethernet
From: David Miller <davem@davemloft.net>
In-Reply-To: <1414002412-13615-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1414002412-13615-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Oct 2014 12:50:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date: Wed, 22 Oct 2014 20:26:43 +0200

> This patch series deals with a removing a IP feature that can be found
> on all currently supported Marvell Ethernet IP (pxa168_eth, mv643xx_eth,
> mvneta). The MAC IP allows to automatically perform PHY auto-negotiation
> without software interaction.
> 
> However, this feature (a) fundamentally clashes with the way libphy works
> and (b) is unable to deal with quirky PHYs that require special treatment.
> In this series, pxa168_eth driver is rewritten to completely disable that
> feature and properly deal with libphy provided PHYs.
> 
> As usual, a branch on top of v3.18-rc1 can be found at
> 
> git://git.infradead.org/users/hesselba/linux-berlin.git devel/bg2-bg2cd-eth-v2
> 
> Patches 1-5 should go through David's net tree, I'll pick up the DT patches
> 6-9.

Patches 1-5 applied to net-next, thanks.
