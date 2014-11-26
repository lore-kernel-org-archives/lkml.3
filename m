Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaKZQ2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:28:21 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64393 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaKZQ2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:28:19 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Fu8R5FHUmd3N1FpSh+dn5eHmrDR28ZB0=
X-DKIM: OpenDKIM Filter v2.0.1 titan C6C1B6248C2
Date: Wed, 26 Nov 2014 11:28:17 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL V2] irqchip: Core changes for v3.19 (round 4)
Message-ID: <20141126162817.GI22670@titan.lakedaemon.net>
References: <20141126083928.GG22670@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126083928.GG22670@titan.lakedaemon.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

As requested, here is a new request for just the dw changes in
irqchip/core.  These changes are pretty small and isolated, so it should
be fine to pull them now.  Or, you can wait for tonight and tommorrow's
-next results.

This is an incremental pull request from tags/irqchip-core-3.19-3 up to
tags/irqchip-core-3.19-4 on the irqchip/core branch.

Please pull.

thx,

Jason.


The following changes since commit 377df64a1676fe069be9d9555edd862459d6090b:

  Merge branch 'irqchip/atmel' into irqchip/core (2014-11-26 07:02:27 +0000)

are available in the git repository at:

  git://git.infradead.org/users/jcooper/linux.git tags/irqchip-core-3.19-4

for you to fetch changes up to 1655b0530d9502e69686220491ffb15ba0738c58:

  irqchip: dw-apb-ictl: Add PM support (2014-11-26 16:08:03 +0000)

----------------------------------------------------------------
irqchip core changes for v3.19 (round 4)

 - dw-apb-ictl
     - Small changes and PM support

----------------------------------------------------------------
Jisheng Zhang (3):
      irqchip: dw-apb-ictl: Always use use {readl|writel}_relaxed
      irqchip: dw-apb-ictl: Enable IRQ_GC_MASK_CACHE_PER_TYPE
      irqchip: dw-apb-ictl: Add PM support

 drivers/irqchip/irq-dw-apb-ictl.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)
