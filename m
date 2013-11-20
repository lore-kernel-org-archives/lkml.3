Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab3KTPZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 10:25:12 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42624 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab3KTPXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 10:23:45 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH 0/7] Davinci nand driver fixes and updates
Date: Wed, 20 Nov 2013 17:22:18 +0200
Message-ID: <1384960945-14528-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series contains fixes and updates of Davinci nand driver, in
order to prepare it to be reused for Keystone platform.

V1:
https://lkml.org/lkml/2013/11/11/352

Ivan Khoronzhuk (7):
  mtd: nand: davinci: fix driver registration
  mtd: nand: davinci: return ENOMEM if memory allocation is failed
  mtd: nand: davinci: check required ti,davinci-chipselect property
  mtd: nand: davinci: simplify error handling
  mtd: nand: davinci: move bindings under mtd
  mtd: nand: davinci: extend description of bindings
  mtd: nand: davinci: adjust DT properties to MTD generic

 .../devicetree/bindings/arm/davinci/nand.txt       |   46 ----------
 .../devicetree/bindings/mtd/davinci-nand.txt       |   92 ++++++++++++++++++++
 drivers/mtd/nand/davinci_nand.c                    |   68 +++++++--------
 3 files changed, 126 insertions(+), 80 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/arm/davinci/nand.txt
 create mode 100644 Documentation/devicetree/bindings/mtd/davinci-nand.txt

-- 
1.7.9.5

