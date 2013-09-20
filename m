Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab3ITSm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 14:42:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39336 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab3ITSmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 14:42:54 -0400
Date: Fri, 20 Sep 2013 14:42:53 -0400 (EDT)
Message-Id: <20130920.144253.977721727117411814.davem@davemloft.net>
To: nicolas.ferre@atmel.com
Cc: netdev@vger.kernel.org, b.brezillon@overkiz.com, f.fainelli@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patrice.vilchez@atmel.com, david.choi@micrel.com
Subject: Re: [PATCH] phy/micrel: Add suspend/resume support to Micrel PHYs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1379612448-20805-1-git-send-email-nicolas.ferre@atmel.com>
References: <1379612448-20805-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 20 Sep 2013 11:42:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Thu, 19 Sep 2013 19:40:48 +0200

> From: Patrice Vilchez <patrice.vilchez@atmel.com>
> 
> All supported Micrel PHYs implement the standard "power down" bit 11 of BMCR,
> so this patch adds support using the generic genphy_{suspend,resume} functions.
> 
> Signed-off-by: Patrice Vilchez <patrice.vilchez@atmel.com>
> [b.brezillon@overkiz.com: adapt to newer kernel and generalize to other phys]
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> [nicolas.ferre@atmel.com: commit message modification]
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: David J. Choi <david.choi@micrel.com>

Applied to net-next
