Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333AbaF1Es5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 00:48:57 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:62261 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbaF1Es4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 00:48:56 -0400
X-Greylist: delayed 12073 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jun 2014 00:48:56 EDT
From: Guillaume Morin <guillaume@morinfr.org>
To: Lidza Louina <lidza.louina@gmail.com>, Mark Hounschell <markh@compro.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guillaume Morin <guillaume@morinfr.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: dgnc_driver.c: code style fixes
Date: Sat, 28 Jun 2014 06:48:48 +0200
Message-Id: <20010f834ddc542235b3bcac65caed31c62f7cbb.1403930174.git.guillaume@morinfr.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guillaume Morin <guillaume@morinfr.org>

Simple code style fixes

Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
---
 drivers/staging/dgnc/dgnc_driver.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_driver.c b/drivers/staging/dgnc/dgnc_driver.c
index d52a9e8..68460af 100644
--- a/drivers/staging/dgnc/dgnc_driver.c
+++ b/drivers/staging/dgnc/dgnc_driver.c
@@ -88,8 +88,7 @@ module_exit(dgnc_cleanup_module);
 /*
  * File operations permitted on Control/Management major.
  */
-static const struct file_operations dgnc_BoardFops =
-{
+static const struct file_operations dgnc_BoardFops = {
 	.owner		=	THIS_MODULE,
 	.unlocked_ioctl =  	dgnc_mgmt_ioctl,
 	.open		=	dgnc_mgmt_open,
@@ -407,7 +406,7 @@ static void dgnc_cleanup_board(struct dgnc_board *brd)
 {
 	int i = 0;
 
-	if(!brd || brd->magic != DGNC_BOARD_MAGIC)
+	if (!brd || brd->magic != DGNC_BOARD_MAGIC)
 		return;
 
 	switch (brd->device) {
@@ -480,7 +479,7 @@ static int dgnc_found_board(struct pci_dev *pdev, int id)
 	/* get the board structure and prep it */
 	brd = dgnc_Board[dgnc_NumBoards] =
 		kzalloc(sizeof(*brd), GFP_KERNEL);
-	if (!brd) 
+	if (!brd)
 		return -ENOMEM;
 
 	/* make a temporary message buffer for the boot messages */
@@ -523,7 +522,7 @@ static int dgnc_found_board(struct pci_dev *pdev, int id)
 	brd->irq = pci_irq;
 
 
-	switch(brd->device) {
+	switch (brd->device) {
 
 	case PCI_DEVICE_CLASSIC_4_DID:
 	case PCI_DEVICE_CLASSIC_8_DID:
@@ -887,7 +886,7 @@ int dgnc_ms_sleep(ulong ms)
  */
 char *dgnc_ioctl_name(int cmd)
 {
-	switch(cmd) {
+	switch (cmd) {
 
 	case TCGETA:		return "TCGETA";
 	case TCGETS:		return "TCGETS";
-- 
1.7.10.4

