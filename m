Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619AbaI3Uhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:37:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49589 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaI3Uhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:37:39 -0400
Date: Tue, 30 Sep 2014 16:37:35 -0400 (EDT)
Message-Id: <20140930.163735.2099691931550261883.davem@davemloft.net>
To: antoine.tenart@free-electrons.com
Cc: sebastian.hesselbarth@gmail.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 00/10] ARM: Berlin: Ethernet support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412087296-18475-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1412087296-18475-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Sep 2014 13:37:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antoine Tenart <antoine.tenart@free-electrons.com>
Date: Tue, 30 Sep 2014 16:28:06 +0200

> This series introduce support for the Ethernet controller on Berlin SoCs,
> using the existing pxa168 Ethernet driver. In order to do this, DT
> support is added to the driver alongside some other modifications and
> fixes.
> 
> This has been tested on a Berlin BG2Q DMP board.

Applied to net-next, thanks.
