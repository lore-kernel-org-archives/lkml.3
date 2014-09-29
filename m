Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbaI2J4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:56:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51398 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbaI2J4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:56:00 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH v2 0/5] ARCNET: add support for EAE multi interfac card
Date: Mon, 29 Sep 2014 11:55:33 +0200
Message-Id: <1411984538-953-1-git-send-email-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.1.0
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this series adds support for the PLX Bridge based multi interface
pci cards and adds support to change device address on com200xx chips
during runtime.

This series is based on v3.17-rc7.
It is fixed for build against com20020_cs.

Thanks,
Michael


Michael Grzeschik (5):
  ARCNET: return IRQ_NONE if the interface isn't running
  ARCNET: add com20020_set_hwddr to change address
  ARCNET: add com20020 PCI IDs with metadata
  ARCNET: add support for multi interfaces on com20020
  ARCNET: enable eae arcnet card support

 drivers/net/arcnet/arcnet.c       |   2 +-
 drivers/net/arcnet/com20020-pci.c | 369 +++++++++++++++++++++++++++++---------
 drivers/net/arcnet/com20020.c     |  14 ++
 drivers/net/arcnet/com20020_cs.c  |   4 -
 include/linux/com20020.h          |  29 +++
 5 files changed, 330 insertions(+), 88 deletions(-)

-- 
2.1.0

