Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbaIYLtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 07:49:50 -0400
Received: from gilgamesh.semihalf.com ([213.17.239.106]:31688 "EHLO
	gilgamesh.semihalf.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaIYLtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 07:49:49 -0400
X-Greylist: delayed 1914 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Sep 2014 07:49:47 EDT
From: Grzegorz Jaszczyk <jaz@semihalf.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: tglx@linutronix.de, jason@lakedaemon.net,
        ezequiel.garcia@free-electrons.com, gregory.clement@free-electrons.com,
        thomas.petazzoni@free-electrons.com, alior@marvell.com,
        tawfik@marvell.com, mw@semihalf.com, jaz@semihalf.com
Subject: [PATCH 0/2] Marvell Armada 375/38x MPIC/MSI fixes
Date: Thu, 25 Sep 2014 13:17:17 +0200
Message-Id: <1411643839-64925-1-git-send-email-jaz@semihalf.com>
X-Mailer: git-send-email 2.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains a set of fixes for issues found while doing some test
with different interrupts configuration on Armada 375 and Armada 38x Marvell
SoCs. The patches were tested and apply on v3.17-rc6.

Any feedback is welcome.

Grzegorz Jaszczyk (2):
  irqchip: armada-370-xp: fix MSI interrupt handling
  irqchip: armada-370-xp: fix MPIC interrupt handling

 drivers/irqchip/irq-armada-370-xp.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

-- 
1.8.3.1

