Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbaD2M4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 08:56:07 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:17727 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754486AbaD2M4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 08:56:05 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19fyaxsQ9dJmlSmGzKfie1npjVRlcYXZ9o=
X-DKIM: OpenDKIM Filter v2.0.1 titan D7828567125
Date: Tue, 29 Apr 2014 08:55:54 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] irqchip: mvebu: fixes for v3.15
Message-ID: <20140429125554.GH28159@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Here's a small round of fixes that we need in a stable topic branch as a
part of a larger fix to the mvebu pcie/mbus driver.  These have been in
-next for a week or so.

Please pull.

thx,

Jason.


The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-mvebu.git tags/mvebu-irqchip-fixes-3.15

for you to fetch changes up to ff3c664505bf8a8334bca5045e87b85cfe4d2277:

  irqchip: armada-370-xp: Fix releasing of MSIs (2014-04-20 19:14:34 +0000)

----------------------------------------------------------------
mvebu irqchip ifxes for v3.15

 - armada-370-xp

    - fix invalid cast (signed to unsigned)
    - add ->check_device() msi_chip op
    - fix releasing of MSIs

----------------------------------------------------------------
Neil Greatorex (1):
      irqchip: armada-370-xp: Fix releasing of MSIs

Thomas Petazzoni (2):
      irqchip: armada-370-xp: fix invalid cast of signed value into unsigned variable
      irqchip: armada-370-xp: implement the ->check_device() msi_chip operation

 drivers/irqchip/irq-armada-370-xp.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)
