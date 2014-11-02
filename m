Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaKBBmC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 21:42:02 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:52657 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaKBBmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 21:42:00 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+J7L5u3SpuSE722YlLNn0wCGJxjKVeeGo=
X-DKIM: OpenDKIM Filter v2.0.1 titan 4E71B60F3EC
Date: Sat, 1 Nov 2014 21:41:58 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] irqchip: Fixes for v3.18
Message-ID: <20141102014158.GO3698@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Here's a couple of fixes for v3.18 that have been in -next longer than
needed :-/

Please pull.

thx,

Jason.


The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.infradead.org/users/jcooper/linux.git tags/irqchip-urgent-3.18

for you to fetch changes up to 758e8366754d3fa57da978fef9d2c652f7b55c02:

  irqchip: armada-370-xp: Fix MPIC interrupt handling (2014-11-02 01:31:10 +0000)

----------------------------------------------------------------
irqchip urgent changes for v3.18

 - armada-370-xp
    - Fix MSI and MPIC interrupt handling.

----------------------------------------------------------------
Grzegorz Jaszczyk (2):
      irqchip: armada-370-xp: Fix MSI interrupt handling
      irqchip: armada-370-xp: Fix MPIC interrupt handling

 drivers/irqchip/irq-armada-370-xp.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)
