Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab3JELTQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 07:19:16 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:44437 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab3JELTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 07:19:07 -0400
From: Andreas Fenkart <afenkart@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@secretlab.ca>,
        Felipe Balbi <balbi@ti.com>, Venkatraman S <svenkatr@ti.com>,
        Balaji T K <balajitk@ti.com>, zonque@gmail.com,
        devicetree-discuss@lists.ozlabs.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-omap@vger.kernel.org, Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH v3 0/4] mmc: omap_hsmmc: SDIO irq
Date: Sat,  5 Oct 2013 13:17:06 +0200
Message-Id: <1380971830-21492-1-git-send-email-afenkart@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes:
- split the subject patch into normal handling and
  workaround for am335x
- rebase

Andreas Fenkart (3):
  mmc: omap_hsmmc: Enable SDIO IRQ.
  mmc: omap_hsmmc: Remux pins to support SDIO interrupt on AM335x
  mmc: omap_hsmmc: debugfs for SDIO IRQ and GPIO remux

Tony Lindgren (1):
  mmc: omap_hsmmc: Fix context save and restore for DT

 .../devicetree/bindings/mmc/ti-omap-hsmmc.txt      |   42 +++
 drivers/mmc/host/omap_hsmmc.c                      |  363 +++++++++++++++++---
 include/linux/platform_data/mmc-omap.h             |    4 +
 3 files changed, 357 insertions(+), 52 deletions(-)

-- 
1.7.10.4

