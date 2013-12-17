Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab3LQOza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 09:55:30 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:23508 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab3LQOz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 09:55:28 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19ruteO26b+v2F7gpuyEe/TNaKS4dnAOto=
X-DKIM: OpenDKIM Filter v2.0.1 titan F12204F4D56
Date: Tue, 17 Dec 2013 09:55:18 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] irqchip: mvebu: fixes for v3.13
Message-ID: <20131217145518.GK2609@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Here's a couple of small fixes for the armada-370-xp driver.  These have
been in -next for 3 days now.

thx,

Jason.


The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.infradead.org/linux-mvebu.git tags/mvebu-irqchip-fixes-3.13

for you to fetch changes up to c7f7bd4a136e4b02dd2a66bf95aec545bd93e8db:

  irqchip: armada-370-xp: fix MSI race condition (2013-12-13 16:34:40 +0000)

----------------------------------------------------------------
mvebu irqchip fixes for v3.13

 - armada-370-xp
    - fix races is MSI and IPI

----------------------------------------------------------------
Lior Amsalem (2):
      irqchip: armada-370-xp: fix IPI race condition
      irqchip: armada-370-xp: fix MSI race condition

 drivers/irqchip/irq-armada-370-xp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
