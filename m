Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401AbaGBHHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 03:07:14 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:42606 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaGBHHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 03:07:12 -0400
Date: Wed, 2 Jul 2014 16:06:04 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] staging: dgap: fixed "foo* bar should be foo * bar" in
 dgap.c
Message-ID: <20140702070604.GA11300@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clean up checkpatch.pl error:
ERROR: "foo* bar" should be "foo *bar"

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index d4f80af..0036f35 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -202,7 +202,7 @@ static int dgap_test_bios(struct board_t *brd);
 static int dgap_test_fep(struct board_t *brd);
 static int dgap_tty_register_ports(struct board_t *brd);
 static int dgap_firmware_load(struct pci_dev *pdev, int card_type,
-			      struct board_t* brd);
+			      struct board_t *brd);
 
 static void dgap_cleanup_module(void);
 
@@ -574,7 +574,7 @@ static int dgap_init_pci(void)
 static int dgap_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int rc;
-	struct board_t* brd;
+	struct board_t *brd;
 
 	if (dgap_numboards >= MAXBOARDS)
 		return -EPERM;
@@ -872,7 +872,7 @@ static void dgap_free_irq(struct board_t *brd)
 }
 
 static int dgap_firmware_load(struct pci_dev *pdev, int card_type,
-			      struct board_t* brd)
+			      struct board_t *brd)
 {
 	const struct firmware *fw;
 	char *tmp_ptr;
-- 
1.7.1

