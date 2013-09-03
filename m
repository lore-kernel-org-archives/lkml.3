Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760856Ab3ICUqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 16:46:00 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60173 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760426Ab3ICUp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 16:45:59 -0400
Message-ID: <1378241158.7347.26.camel@joe-AO722>
Subject: [trivial PATCH] treewide: Convert retrun typos to return
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 03 Sep 2013 13:45:58 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tyops should be fixed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c | 2 +-
 drivers/scsi/bfa/bfad_im.c                  | 2 +-
 drivers/scsi/hpsa.c                         | 2 +-
 drivers/scsi/lpfc/lpfc_bsg.c                | 2 +-
 drivers/scsi/qla2xxx/qla_bsg.c              | 2 +-
 drivers/tty/serial/kgdboc.c                 | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
index 47875ba..f700f7a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
@@ -416,7 +416,7 @@ static void rtl92d_dm_dig(struct ieee80211_hw *hw)
 
 	/* because we will send data pkt when scanning
 	 * this will cause some ap like gear-3700 wep TP
-	 * lower if we retrun here, this is the diff of
+	 * lower if we return here, this is the diff of
 	 * mac80211 driver vs ieee80211 driver */
 	/* if (rtlpriv->mac80211.act_scanning)
 	 *      return; */
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 9796284..9967f9c 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -206,7 +206,7 @@ bfad_im_abort_handler(struct scsi_cmnd *cmnd)
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	hal_io = (struct bfa_ioim_s *) cmnd->host_scribble;
 	if (!hal_io) {
-		/* IO has been completed, retrun success */
+		/* IO has been completed, return success */
 		rc = SUCCESS;
 		goto out;
 	}
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b766f5a..fac8cf5 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1054,7 +1054,7 @@ free_and_out:
 }
 
 /*
- * Lookup bus/target/lun and retrun corresponding struct hpsa_scsi_dev_t *
+ * Lookup bus/target/lun and return corresponding struct hpsa_scsi_dev_t *
  * Assume's h->devlock is held.
  */
 static struct hpsa_scsi_dev_t *lookup_hpsa_scsi_dev(struct ctlr_info *h,
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index bc27063..79c13c3 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -2628,7 +2628,7 @@ err_get_xri_exit:
  * @phba: Pointer to HBA context object
  *
  * This function allocates BSG_MBOX_SIZE (4KB) page size dma buffer and.
- * retruns the pointer to the buffer.
+ * returns the pointer to the buffer.
  **/
 static struct lpfc_dmabuf *
 lpfc_bsg_dma_page_alloc(struct lpfc_hba *phba)
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index b989add..aa57bf0 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1895,7 +1895,7 @@ done:
 	bsg_job->reply->reply_payload_rcv_len = 0;
 	bsg_job->reply->result = (DID_OK) << 16;
 	bsg_job->job_done(bsg_job);
-	/* Always retrun success, vendor rsp carries correct status */
+	/* Always return success, vendor rsp carries correct status */
 	return 0;
 }
 
diff --git a/drivers/tty/serial/kgdboc.c b/drivers/tty/serial/kgdboc.c
index 1002054..a260cde 100644
--- a/drivers/tty/serial/kgdboc.c
+++ b/drivers/tty/serial/kgdboc.c
@@ -45,7 +45,7 @@ static int kgdboc_reset_connect(struct input_handler *handler,
 {
 	input_reset_device(dev);
 
-	/* Retrun an error - we do not want to bind, just to reset */
+	/* Return an error - we do not want to bind, just to reset */
 	return -ENODEV;
 }
 


