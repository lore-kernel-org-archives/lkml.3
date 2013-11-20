Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab3KTPr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 10:47:57 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41515 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984Ab3KTPrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 10:47:52 -0500
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
        <gregkh@linuxfoundation.org>, Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH 0/2] Introduce AEMIF driver for Davinci/Keystone archs
Date: Wed, 20 Nov 2013 17:46:54 +0200
Message-ID: <1384962416-14862-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches introduce Async External Memory Interface (EMIF16/AEMIF)
controller driver for Davinci/Keystone archs.

V1:
https://lkml.org/lkml/2013/11/11/352

Ivan Khoronzhuk (2):
  memory: ti-aemif: introduce AEMIF driver
  memory: ti-aemif: add bindings for AEMIF driver

 .../bindings/memory-controllers/ti-aemif.txt       |  198 ++++++++++
 drivers/memory/Kconfig                             |   11 +
 drivers/memory/Makefile                            |    1 +
 drivers/memory/ti-aemif.c                          |  415 ++++++++++++++++++++
 4 files changed, 625 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/ti-aemif.txt
 create mode 100644 drivers/memory/ti-aemif.c

-- 
1.7.9.5

