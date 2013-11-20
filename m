Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3KTQZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:25:58 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:43670 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050Ab3KTQZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:25:54 -0500
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
Subject: [PATCH 0/3] Reuse davinci-nand driver for Keystone arch
Date: Wed, 20 Nov 2013 18:24:56 +0200
Message-ID: <1384964699-15134-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series contains updates of Davinci nand driver, in order to be
reused for Keystone platform.

Depends on:
- Davinci nand driver fixes and updates:
  https://lkml.org/lkml/2013/11/20/271

- Introduce AEMIF driver for Davinci/Keystone archs:
  http://lkml.org/lkml/2013/11/11/352

V1:
https://lkml.org/lkml/2013/11/11/352

Ivan Khoronzhuk (3):
  mtd: nand: davinci: reuse driver for Keystone arch
  mtd: nand: davinci: don't set timings if AEMIF is used
  mtd: nand: davinci: don't request AEMIF address range

 .../devicetree/bindings/mtd/davinci-nand.txt       |    8 +--
 drivers/mtd/nand/Kconfig                           |    6 +--
 drivers/mtd/nand/davinci_nand.c                    |   57 +++++++++++++-------
 3 files changed, 45 insertions(+), 26 deletions(-)

-- 
1.7.9.5

