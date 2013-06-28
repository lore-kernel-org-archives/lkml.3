Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab3F1J1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 05:27:44 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:54869 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab3F1J1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 05:27:41 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH TRIVIAL] Spelling: relase -> release
Date: Fri, 28 Jun 2013 11:27:31 +0200
Message-Id: <1372411651-26885-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 Makefile                                   |    2 +-
 drivers/input/misc/da9055_onkey.c          |    2 +-
 drivers/media/dvb-frontends/stv0367.c      |    2 +-
 drivers/net/ethernet/intel/igb/e1000_phy.c |    2 +-
 drivers/s390/char/vmur.c                   |    2 +-
 drivers/scsi/libfc/fc_fcp.c                |    2 +-
 mm/mmu_notifier.c                          |    2 +-
 sound/pci/hda/hda_codec.c                  |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index 0142c93..c593304 100644
--- a/Makefile
+++ b/Makefile
@@ -794,7 +794,7 @@ PHONY += $(vmlinux-dirs)
 $(vmlinux-dirs): prepare scripts
 	$(Q)$(MAKE) $(build)=$@
 
-# Store (new) KERNELRELASE string in include/config/kernel.release
+# Store (new) KERNELRELEASE string in include/config/kernel.release
 include/config/kernel.release: include/config/auto.conf FORCE
 	$(Q)rm -f $@
 	$(Q)echo "$(KERNELVERSION)$$($(CONFIG_SHELL) $(srctree)/scripts/setlocalversion $(srctree))" > $@
diff --git a/drivers/input/misc/da9055_onkey.c b/drivers/input/misc/da9055_onkey.c
index ee6ae3a..a0af8b2 100644
--- a/drivers/input/misc/da9055_onkey.c
+++ b/drivers/input/misc/da9055_onkey.c
@@ -36,7 +36,7 @@ static void da9055_onkey_query(struct da9055_onkey *onkey)
 	} else {
 		key_stat &= DA9055_NOKEY_STS;
 		/*
-		 * Onkey status bit is cleared when onkey button is relased.
+		 * Onkey status bit is cleared when onkey button is released.
 		 */
 		if (!key_stat) {
 			input_report_key(onkey->input, KEY_POWER, 0);
diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index 0c8e459..7b6dba3 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -2919,7 +2919,7 @@ enum stv0367_cab_signal_type stv0367cab_algo(struct stv0367_state *state,
 	if (tuner_lock == 0)
 		return FE_367CAB_NOTUNER;
 #endif
-	/* Relase the TRL to start demodulator acquisition */
+	/* Release the TRL to start demodulator acquisition */
 	/* Wait for QAM lock */
 	LockTime = 0;
 	stv0367_writereg(state, R367CAB_CTRL_1, 0x00);
diff --git a/drivers/net/ethernet/intel/igb/e1000_phy.c b/drivers/net/ethernet/intel/igb/e1000_phy.c
index 115b0da..9979ebc 100644
--- a/drivers/net/ethernet/intel/igb/e1000_phy.c
+++ b/drivers/net/ethernet/intel/igb/e1000_phy.c
@@ -2014,7 +2014,7 @@ out:
  *  Verify the reset block is not blocking us from resetting.  Acquire
  *  semaphore (if necessary) and read/set/write the device control reset
  *  bit in the PHY.  Wait the appropriate delay time for the device to
- *  reset and relase the semaphore (if necessary).
+ *  reset and release the semaphore (if necessary).
  **/
 s32 igb_phy_hw_reset(struct e1000_hw *hw)
 {
diff --git a/drivers/s390/char/vmur.c b/drivers/s390/char/vmur.c
index c180e31..64c4679 100644
--- a/drivers/s390/char/vmur.c
+++ b/drivers/s390/char/vmur.c
@@ -89,7 +89,7 @@ static DEFINE_MUTEX(vmur_mutex);
  * urd references:
  * - ur_probe gets a urd reference, ur_remove drops the reference
  *   dev_get_drvdata(&cdev->dev)
- * - ur_open gets a urd reference, ur_relase drops the reference
+ * - ur_open gets a urd reference, ur_release drops the reference
  *   (urf->urd)
  *
  * cdev references:
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 09c81b2..5fd0f1f 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2043,7 +2043,7 @@ int fc_eh_abort(struct scsi_cmnd *sc_cmd)
 		spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
 		return SUCCESS;
 	}
-	/* grab a ref so the fsp and sc_cmd cannot be relased from under us */
+	/* grab a ref so the fsp and sc_cmd cannot be released from under us */
 	fc_fcp_pkt_hold(fsp);
 	spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
 
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 6725ff1..93e6089 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -315,7 +315,7 @@ void mmu_notifier_unregister(struct mmu_notifier *mn, struct mm_struct *mm)
 
 	/*
 	 * Wait for any running method to finish, of course including
-	 * ->release if it was run by mmu_notifier_relase instead of us.
+	 * ->release if it was run by mmu_notifier_release instead of us.
 	 */
 	synchronize_srcu(&srcu);
 
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 55108b5..a9676ce 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2523,7 +2523,7 @@ int snd_hda_codec_reset(struct hda_codec *codec)
 	flush_workqueue(bus->workq);
 #endif
 	snd_hda_ctls_clear(codec);
-	/* relase PCMs */
+	/* release PCMs */
 	for (i = 0; i < codec->num_pcms; i++) {
 		if (codec->pcm_info[i].pcm) {
 			snd_device_free(card, codec->pcm_info[i].pcm);
-- 
1.7.9.5

