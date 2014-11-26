Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbaKZGp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 01:45:28 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56031 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbaKZGp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 01:45:27 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18slP8lrOiKbiRjXpb5zTfAs7JXuc64MZc=
X-DKIM: OpenDKIM Filter v2.0.1 titan 4F17862422C
Date: Wed, 26 Nov 2014 01:45:25 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] irqchip: Fixes for v3.18 (round 2)
Message-ID: <20141126064525.GZ22670@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Here's the last couple of fixes.

This is an incremental pull request from tags/irqchip-urgent-3.18 up to
tags/irqchip-urgent-3.18-2 in the irqchip/urgent branch.

Please pull.

thx,

Jason.


The following changes since commit 758e8366754d3fa57da978fef9d2c652f7b55c02:

  irqchip: armada-370-xp: Fix MPIC interrupt handling (2014-11-02 01:31:10 +0000)

are available in the git repository at:

  git://git.infradead.org/users/jcooper/linux.git tags/irqchip-urgent-3.18-2

for you to fetch changes up to d99ba4465a08138966083d6c256b2f66e85a5095:

  irqchip: brcmstb-l2: Fix error handling of irq_of_parse_and_map (2014-11-26 06:28:42 +0000)

----------------------------------------------------------------
irqchip fixes for v3.18 (round 2)

 - atmel-aic
    - Fix irqdomain init

 - bcm{7120,stb}-l2
    - Fix error handling in irq_of_parse_and_map

----------------------------------------------------------------
Boris Brezillon (1):
      irqchip: atmel-aic: Fix irqdomain initialization

Dmitry Torokhov (2):
      irqchip: bcm7120-l2: Fix error handling of irq_of_parse_and_map
      irqchip: brcmstb-l2: Fix error handling of irq_of_parse_and_map

 drivers/irqchip/irq-atmel-aic-common.c | 6 +++---
 drivers/irqchip/irq-bcm7120-l2.c       | 4 ++--
 drivers/irqchip/irq-brcmstb-l2.c       | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)
