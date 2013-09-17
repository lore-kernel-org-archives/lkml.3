Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab3IQN4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 09:56:31 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59837 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab3IQN4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 09:56:30 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: dan.j.williams@intel.com
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: [[PATCH] 0/3] imx-dma: fixes
Date: Tue, 17 Sep 2013 15:56:05 +0200
Message-Id: <1379426168-31989-1-git-send-email-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 1.8.4.rc3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this series is solving some lockdep issues in the imx-dma code.
There are some list_head and deadlock issues in the code,
that is running the implementation into unsafe situations.

Regards,
Michael

Michael Grzeschik (3):
  dma: imx-dma: fix slow path issue in prep_dma_cyclic
  dma: imx-dma: fix lockdep issue between irqhandler and tasklet
  dma: imx-dma: fix callback path in tasklet

 drivers/dma/imx-dma.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

-- 
1.8.4.rc3

