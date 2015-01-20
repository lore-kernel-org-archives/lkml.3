Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbbATOIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:08:34 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:35743 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbbATOId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:08:33 -0500
Date: Tue, 20 Jan 2015 16:08:27 +0200
From: Mohamed Lotfy Hammad <mohamed.lotfy.hammad@gmail.com>
To: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, lidza.louina@gmail.com, markh@compro.net,
        gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org
Subject: [PATCH] staging: dgnc: warning line over 80 characters
Message-ID: <20150120140827.GA8352@lotfy1893-Ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl warning:
fix line over 80 characters 

Signed-off-by: Mohamed Lotfy Hammad <mohamed.lotfy.hammad@gmail.com>
---
 drivers/staging/dgnc/dgnc_driver.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_driver.c b/drivers/staging/dgnc/dgnc_driver.c
index ba98ff3..050061e 100644
--- a/drivers/staging/dgnc/dgnc_driver.c
+++ b/drivers/staging/dgnc/dgnc_driver.c
@@ -54,14 +54,14 @@ MODULE_SUPPORTED_DEVICE("dgnc");
  * protos for this file
  *
  */
-static int		dgnc_start(void);
-static int		dgnc_finalize_board_init(struct dgnc_board *brd);
-static void		dgnc_init_globals(void);
-static int		dgnc_found_board(struct pci_dev *pdev, int id);
-static void		dgnc_cleanup_board(struct dgnc_board *brd);
-static void		dgnc_poll_handler(ulong dummy);
-static int		dgnc_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
-static void		dgnc_do_remap(struct dgnc_board *brd);
+static int dgnc_start(void);
+static int dgnc_finalize_board_init(struct dgnc_board *brd);
+static void dgnc_init_globals(void);
+static int dgnc_found_board(struct pci_dev *pdev, int id);
+static void dgnc_cleanup_board(struct dgnc_board *brd);
+static void dgnc_poll_handler(ulong dummy);
+static int dgnc_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
+static void dgnc_do_remap(struct dgnc_board *brd);
 
 /*
  * File operations permitted on Control/Management major.
-- 
2.1.0

