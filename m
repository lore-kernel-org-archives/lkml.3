Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab3HTHy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:54:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39731 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab3HTHyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:54:55 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-mtd@lists.infradead.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH v2] m25p80 / fast read
Date: Tue, 20 Aug 2013 09:54:38 +0200
Message-Id: <1376985281-16293-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.8.4.rc3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changes since v1:

- rebase on git.infradead.org/l2-mtd.git
- improve description for patch 2/3

Sascha

----------------------------------------------------------------
Markus Niebel (1):
      mtd: m25p80: add support for mr25h10

Sascha Hauer (2):
      mtd: m25p80: Pass flags through CAT25_INFO macro
      mtd: m25p80: make CONFIG_M25PXX_USE_FAST_READ safe to enable

 drivers/mtd/devices/m25p80.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)
