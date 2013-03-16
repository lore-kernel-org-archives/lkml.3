Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab3CPLxO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 07:53:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64369 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab3CPLxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 07:53:12 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial]treewide: Fix typos in printk and comment
Date: Sat, 16 Mar 2013 20:53:05 +0900
Message-Id: <1363434785-3801-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typos

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/arc/plat-arcfpga/Kconfig           |  2 +-
 arch/blackfin/include/asm/bfin_sport3.h |  2 +-
 arch/s390/kernel/irq.c                  |  2 +-
 arch/s390/kvm/trace.h                   |  2 +-
 drivers/crypto/caam/ctrl.c              |  2 +-
 drivers/gpu/drm/radeon/radeon_irq_kms.c |  2 +-
 drivers/i2c/busses/i2c-puv3.c           |  2 +-
 drivers/scsi/qla4xxx/ql4_nx.c           |  2 +-
 drivers/usb/misc/uss720.c               |  2 +-
 include/trace/events/timer.h            | 10 +++++-----
 sound/pci/mixart/mixart.c               |  2 +-
 11 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/arc/plat-arcfpga/Kconfig b/arch/arc/plat-arcfpga/Kconfig
index b41e786..295cefe 100644
--- a/arch/arc/plat-arcfpga/Kconfig
+++ b/arch/arc/plat-arcfpga/Kconfig
@@ -53,7 +53,7 @@ menuconfig ARC_HAS_BVCI_LAT_UNIT
 	bool "BVCI Bus Latency Unit"
 	depends on ARC_BOARD_ML509 || ARC_BOARD_ANGEL4
 	help
-	  IP to add artifical latency to BVCI Bus Based FPGA builds.
+	  IP to add artificial latency to BVCI Bus Based FPGA builds.
 	  The default latency (even worst case) for FPGA is non-realistic
 	  (~10 SDRAM, ~5 SSRAM).
 
diff --git a/arch/blackfin/include/asm/bfin_sport3.h b/arch/blackfin/include/asm/bfin_sport3.h
index 03c0022..d82f5fa 100644
--- a/arch/blackfin/include/asm/bfin_sport3.h
+++ b/arch/blackfin/include/asm/bfin_sport3.h
@@ -41,7 +41,7 @@
 #define SPORT_CTL_LAFS                0x00020000    /* Late Transmit frame select */
 #define SPORT_CTL_RJUST               0x00040000    /* Right Justified mode select */
 #define SPORT_CTL_FSED                0x00080000    /* External frame sync edge select */
-#define SPORT_CTL_TFIEN               0x00100000    /* Transmit finish interrrupt enable select */
+#define SPORT_CTL_TFIEN               0x00100000    /* Transmit finish interrupt enable select */
 #define SPORT_CTL_GCLKEN              0x00200000    /* Gated clock mode select */
 #define SPORT_CTL_SPENSEC             0x01000000    /* Enable secondary channel */
 #define SPORT_CTL_SPTRAN              0x02000000    /* Data direction control */
diff --git a/arch/s390/kernel/irq.c b/arch/s390/kernel/irq.c
index 1630f43..4f5ef62 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -33,7 +33,7 @@ struct irq_class {
 };
 
 /*
- * The list of "main" irq classes on s390. This is the list of interrrupts
+ * The list of "main" irq classes on s390. This is the list of interrupts
  * that appear both in /proc/stat ("intr" line) and /proc/interrupts.
  * Historically only external and I/O interrupts have been part of /proc/stat.
  * We can't add the split external and I/O sub classes since the first field
diff --git a/arch/s390/kvm/trace.h b/arch/s390/kvm/trace.h
index 2b29e62..7478988 100644
--- a/arch/s390/kvm/trace.h
+++ b/arch/s390/kvm/trace.h
@@ -67,7 +67,7 @@ TRACE_EVENT(kvm_s390_sie_fault,
 #define sie_intercept_code				\
 	{0x04, "Instruction"},				\
 	{0x08, "Program interruption"},			\
-	{0x0C, "Instruction and program interuption"},	\
+	{0x0C, "Instruction and program interruption"},	\
 	{0x10, "External request"},			\
 	{0x14, "External interruption"},		\
 	{0x18, "I/O request"},				\
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 1c56f63..8acf004 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -66,7 +66,7 @@ static void build_instantiation_desc(u32 *desc)
 
 	/*
 	 * load 1 to clear written reg:
-	 * resets the done interrrupt and returns the RNG to idle.
+	 * resets the done interrupt and returns the RNG to idle.
 	 */
 	append_load_imm_u32(desc, 1, LDST_SRCDST_WORD_CLRW);
 
diff --git a/drivers/gpu/drm/radeon/radeon_irq_kms.c b/drivers/gpu/drm/radeon/radeon_irq_kms.c
index 90374dd..8c8a7f0 100644
--- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
@@ -270,7 +270,7 @@ int radeon_irq_kms_init(struct radeon_device *rdev)
 }
 
 /**
- * radeon_irq_kms_fini - tear down driver interrrupt info
+ * radeon_irq_kms_fini - tear down driver interrupt info
  *
  * @rdev: radeon device pointer
  *
diff --git a/drivers/i2c/busses/i2c-puv3.c b/drivers/i2c/busses/i2c-puv3.c
index 261d7db..8acef65 100644
--- a/drivers/i2c/busses/i2c-puv3.c
+++ b/drivers/i2c/busses/i2c-puv3.c
@@ -199,7 +199,7 @@ static int puv3_i2c_probe(struct platform_device *pdev)
 
 	adapter = kzalloc(sizeof(struct i2c_adapter), GFP_KERNEL);
 	if (adapter == NULL) {
-		dev_err(&pdev->dev, "can't allocate inteface!\n");
+		dev_err(&pdev->dev, "can't allocate interface!\n");
 		rc = -ENOMEM;
 		goto fail_nomem;
 	}
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 71d3d23..9299400 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -2089,7 +2089,7 @@ static int qla4_8xxx_minidump_process_rdmem(struct scsi_qla_host *ha,
 
 	if (r_addr & 0xf) {
 		DEBUG2(ql4_printk(KERN_INFO, ha,
-				  "[%s]: Read addr 0x%x not 16 bytes alligned\n",
+				  "[%s]: Read addr 0x%x not 16 bytes aligned\n",
 				  __func__, r_addr));
 		return QLA_ERROR;
 	}
diff --git a/drivers/usb/misc/uss720.c b/drivers/usb/misc/uss720.c
index 29cad9e..e129cf6 100644
--- a/drivers/usb/misc/uss720.c
+++ b/drivers/usb/misc/uss720.c
@@ -705,7 +705,7 @@ static int uss720_probe(struct usb_interface *intf,
 		return -ENODEV;
 	}
 	i = usb_set_interface(usbdev, intf->altsetting->desc.bInterfaceNumber, 2);
-	dev_dbg(&intf->dev, "set inteface result %d\n", i);
+	dev_dbg(&intf->dev, "set interface result %d\n", i);
 
 	interface = intf->cur_altsetting;
 
diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index 425bcfe..8d21947 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -123,7 +123,7 @@ DEFINE_EVENT(timer_class, timer_cancel,
 
 /**
  * hrtimer_init - called when the hrtimer is initialized
- * @timer:	pointer to struct hrtimer
+ * @hrtimer:	pointer to struct hrtimer
  * @clockid:	the hrtimers clock
  * @mode:	the hrtimers mode
  */
@@ -155,7 +155,7 @@ TRACE_EVENT(hrtimer_init,
 
 /**
  * hrtimer_start - called when the hrtimer is started
- * @timer: pointer to struct hrtimer
+ * @hrtimer: pointer to struct hrtimer
  */
 TRACE_EVENT(hrtimer_start,
 
@@ -186,8 +186,8 @@ TRACE_EVENT(hrtimer_start,
 );
 
 /**
- * htimmer_expire_entry - called immediately before the hrtimer callback
- * @timer:	pointer to struct hrtimer
+ * hrtimer_expire_entry - called immediately before the hrtimer callback
+ * @hrtimer:	pointer to struct hrtimer
  * @now:	pointer to variable which contains current time of the
  *		timers base.
  *
@@ -234,7 +234,7 @@ DECLARE_EVENT_CLASS(hrtimer_class,
 
 /**
  * hrtimer_expire_exit - called immediately after the hrtimer callback returns
- * @timer:	pointer to struct hrtimer
+ * @hrtimer:	pointer to struct hrtimer
  *
  * When used in combination with the hrtimer_expire_entry tracepoint we can
  * determine the runtime of the callback function.
diff --git a/sound/pci/mixart/mixart.c b/sound/pci/mixart/mixart.c
index 01f7f37..934dec9 100644
--- a/sound/pci/mixart/mixart.c
+++ b/sound/pci/mixart/mixart.c
@@ -1175,7 +1175,7 @@ static void snd_mixart_proc_read(struct snd_info_entry *entry,
 
 			snd_iprintf(buffer, "\tstreaming          : %d\n", streaming);
 			snd_iprintf(buffer, "\tmailbox            : %d\n", mailbox);
-			snd_iprintf(buffer, "\tinterrups handling : %d\n\n", interr);
+			snd_iprintf(buffer, "\tinterrupts handling : %d\n\n", interr);
 		}
 	} /* endif elf loaded */
 }
-- 
1.8.2

