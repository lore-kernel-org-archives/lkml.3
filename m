Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966715Ab3DQPNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 11:13:05 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:41533 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966493Ab3DQPND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 11:13:03 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial]treewide: Fix typo in printk and comments
Date: Thu, 18 Apr 2013 00:12:55 +0900
Message-Id: <1366211575-16776-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.2.1.422.gdcd8c09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix typo in printk and comments within various drivers.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>

# Please enter the commit message for your changes. Lines starting
# with '#' will be kept; you may remove them yourself if you want to.
# An empty message aborts the commit.
# On branch treewide-typo-fix0417
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#	modified:   arch/arm/kvm/arm.c
#	modified:   drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c
#	modified:   drivers/remoteproc/remoteproc_core.c
#	modified:   drivers/scsi/be2iscsi/be_iscsi.c
#	modified:   drivers/scsi/be2iscsi/be_mgmt.c
#	modified:   drivers/scsi/bnx2i/bnx2i.h
#	modified:   drivers/scsi/csiostor/csio_mb.c
#	modified:   drivers/usb/misc/uss720.c
#	modified:   include/sound/pcm.h
#
---
 arch/arm/kvm/arm.c                              |  2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c |  4 ++--
 drivers/remoteproc/remoteproc_core.c            |  2 +-
 drivers/scsi/be2iscsi/be_iscsi.c                |  2 +-
 drivers/scsi/be2iscsi/be_mgmt.c                 |  2 +-
 drivers/scsi/bnx2i/bnx2i.h                      | 12 ++++++------
 drivers/scsi/csiostor/csio_mb.c                 | 12 ++++++------
 drivers/usb/misc/uss720.c                       |  2 +-
 include/sound/pcm.h                             |  2 +-
 9 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 5a93698..15d37af 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -613,7 +613,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 
 		if (hsr_ec >= ARRAY_SIZE(arm_exit_handlers)
 		    || !arm_exit_handlers[hsr_ec]) {
-			kvm_err("Unkown exception class: %#08lx, "
+			kvm_err("Unknown exception class: %#08lx, "
 				"hsr: %#08x\n", hsr_ec,
 				(unsigned int)vcpu->arch.hsr);
 			BUG();
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c
index 5682054..c633402 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c
@@ -591,7 +591,7 @@ static int bnx2x_dcbx_read_shmem_remote_mib(struct bnx2x *bp)
 				 DCBX_READ_REMOTE_MIB);
 
 	if (rc) {
-		BNX2X_ERR("Faild to read remote mib from FW\n");
+		BNX2X_ERR("Failed to read remote mib from FW\n");
 		return rc;
 	}
 
@@ -619,7 +619,7 @@ static int bnx2x_dcbx_read_shmem_neg_results(struct bnx2x *bp)
 				 DCBX_READ_LOCAL_MIB);
 
 	if (rc) {
-		BNX2X_ERR("Faild to read local mib from FW\n");
+		BNX2X_ERR("Failed to read local mib from FW\n");
 		return rc;
 	}
 
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 2bfa08a..1747058 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -59,7 +59,7 @@ static const char *rproc_crash_to_string(enum rproc_crash_type type)
 {
 	if (type < ARRAY_SIZE(rproc_crash_names))
 		return rproc_crash_names[type];
-	return "unkown";
+	return "unknown";
 }
 
 /*
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 214d691..9014690 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -369,7 +369,7 @@ beiscsi_set_vlan_tag(struct Scsi_Host *shost,
 		break;
 	default:
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-			    "BS_%d : Unkown Param Type : %d\n",
+			    "BS_%d : Unknown Param Type : %d\n",
 			    iface_param->param);
 		return -ENOSYS;
 	}
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index a6c2fe4..55cc990 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1292,7 +1292,7 @@ beiscsi_adap_family_disp(struct device *dev, struct device_attribute *attr,
 		break;
 	default:
 		return snprintf(buf, PAGE_SIZE,
-				"Unkown Adapter Family: 0x%x\n", dev_id);
+				"Unknown Adapter Family: 0x%x\n", dev_id);
 		break;
 	}
 }
diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index b44d04e..f109e3b 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -580,8 +580,8 @@ struct bnx2i_5771x_dbell {
  * @sq_mem_size:        SQ size
  * @sq_prod_qe:         SQ producer entry pointer
  * @sq_cons_qe:         SQ consumer entry pointer
- * @sq_first_qe:        virtaul address of first entry in SQ
- * @sq_last_qe:         virtaul address of last entry in SQ
+ * @sq_first_qe:        virtual address of first entry in SQ
+ * @sq_last_qe:         virtual address of last entry in SQ
  * @sq_prod_idx:        SQ producer index
  * @sq_cons_idx:        SQ consumer index
  * @sqe_left:           number sq entry left
@@ -593,8 +593,8 @@ struct bnx2i_5771x_dbell {
  * @cq_mem_size:        CQ size
  * @cq_prod_qe:         CQ producer entry pointer
  * @cq_cons_qe:         CQ consumer entry pointer
- * @cq_first_qe:        virtaul address of first entry in CQ
- * @cq_last_qe:         virtaul address of last entry in CQ
+ * @cq_first_qe:        virtual address of first entry in CQ
+ * @cq_last_qe:         virtual address of last entry in CQ
  * @cq_prod_idx:        CQ producer index
  * @cq_cons_idx:        CQ consumer index
  * @cqe_left:           number cq entry left
@@ -608,8 +608,8 @@ struct bnx2i_5771x_dbell {
  * @rq_mem_size:        RQ size
  * @rq_prod_qe:         RQ producer entry pointer
  * @rq_cons_qe:         RQ consumer entry pointer
- * @rq_first_qe:        virtaul address of first entry in RQ
- * @rq_last_qe:         virtaul address of last entry in RQ
+ * @rq_first_qe:        virtual address of first entry in RQ
+ * @rq_last_qe:         virtual address of last entry in RQ
  * @rq_prod_idx:        RQ producer index
  * @rq_cons_idx:        RQ consumer index
  * @rqe_left:           number rq entry left
diff --git a/drivers/scsi/csiostor/csio_mb.c b/drivers/scsi/csiostor/csio_mb.c
index 5b27c48..f5d9ee1 100644
--- a/drivers/scsi/csiostor/csio_mb.c
+++ b/drivers/scsi/csiostor/csio_mb.c
@@ -182,7 +182,7 @@ csio_mb_reset(struct csio_hw *hw, struct csio_mb *mbp, uint32_t tmo,
  * @tmo: Command timeout.
  * @pf: PF number.
  * @vf: VF number.
- * @nparams: Number of paramters
+ * @nparams: Number of parameters
  * @params: Parameter mnemonic array.
  * @val: Parameter value array.
  * @wr: Write/Read PARAMS.
@@ -721,7 +721,7 @@ csio_mb_iq_free(struct csio_hw *hw, struct csio_mb *mbp, void *priv,
  * @mbp: Mailbox structure to initialize
  * @priv: Private data
  * @mb_tmo: Mailbox time-out period (in ms).
- * @eq_ofld_params: (Offload) Egress queue paramters.
+ * @eq_ofld_params: (Offload) Egress queue parameters.
  * @cbfn: The call-back function
  *
  *
@@ -752,7 +752,7 @@ csio_mb_eq_ofld_alloc(struct csio_hw *hw, struct csio_mb *mbp, void *priv,
  * @priv: Private data
  * @mb_tmo: Mailbox time-out period (in ms).
  * @cascaded_req: TRUE - if this request is cascased with Eq-alloc request.
- * @eq_ofld_params: (Offload) Egress queue paramters.
+ * @eq_ofld_params: (Offload) Egress queue parameters.
  * @cbfn: The call-back function
  *
  *
@@ -817,7 +817,7 @@ csio_mb_eq_ofld_write(struct csio_hw *hw, struct csio_mb *mbp, void *priv,
  * @mbp: Mailbox structure to initialize
  * @priv: Private data.
  * @mb_tmo: Mailbox time-out period (in ms).
- * @eq_ofld_params: (Offload) Egress queue paramters.
+ * @eq_ofld_params: (Offload) Egress queue parameters.
  * @cbfn: The call-back function
  *
  *
@@ -840,7 +840,7 @@ csio_mb_eq_ofld_alloc_write(struct csio_hw *hw, struct csio_mb *mbp,
  * @hw: The HW structure.
  * @mbp: Mailbox structure to initialize.
  * @retval: Firmware return value.
- * @eq_ofld_params: (Offload) Egress queue paramters.
+ * @eq_ofld_params: (Offload) Egress queue parameters.
  *
  */
 void
@@ -870,7 +870,7 @@ csio_mb_eq_ofld_alloc_write_rsp(struct csio_hw *hw,
  * @mbp: Mailbox structure to initialize
  * @priv: Private data area.
  * @mb_tmo: Mailbox time-out period (in ms).
- * @eq_ofld_params: (Offload) Egress queue paramters, that is to be freed.
+ * @eq_ofld_params: (Offload) Egress queue parameters, that is to be freed.
  * @cbfn: The call-back function
  *
  *
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
 
diff --git a/include/sound/pcm.h b/include/sound/pcm.h
index 45c1981..5ec42db 100644
--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -867,7 +867,7 @@ int snd_pcm_format_physical_width(snd_pcm_format_t format);		/* in bits */
 ssize_t snd_pcm_format_size(snd_pcm_format_t format, size_t samples);
 const unsigned char *snd_pcm_format_silence_64(snd_pcm_format_t format);
 int snd_pcm_format_set_silence(snd_pcm_format_t format, void *buf, unsigned int frames);
-snd_pcm_format_t snd_pcm_build_linear_format(int width, int unsignd, int big_endian);
+snd_pcm_format_t snd_pcm_build_linear_format(int width, int unsigned, int big_endian);
 
 void snd_pcm_set_ops(struct snd_pcm * pcm, int direction, struct snd_pcm_ops *ops);
 void snd_pcm_set_sync(struct snd_pcm_substream *substream);
-- 
1.8.2.1.422.gdcd8c09

