Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab3JKX3x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 19:29:53 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:33896 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab3JKX3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 19:29:50 -0400
Message-ID: <525889EA.10109@artisandeveloppeur.fr>
Date: Sat, 12 Oct 2013 01:29:46 +0200
From: Maxime Jayat <maxime@artisandeveloppeur.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][TRIVIAL] treewide: Fix common typo in "identify"
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct common misspelling of "identify" as "indentify" throughout
the kernel

Signed-off-by: Maxime Jayat <maxime@artisandeveloppeur.fr>
---
 arch/mips/include/asm/octeon/cvmx-pip.h   |    4 ++--
 arch/x86/kernel/cpu/intel_cacheinfo.c     |    2 +-
 arch/x86/kernel/cpu/scattered.c           |    2 +-
 drivers/media/rc/keymaps/rc-dib0700-nec.c |    2 +-
 drivers/media/rc/keymaps/rc-dib0700-rc5.c |    2 +-
 drivers/net/irda/ali-ircc.c               |    2 +-
 drivers/net/irda/nsc-ircc.c               |    2 +-
 drivers/s390/scsi/zfcp_dbf.c              |    6 +++---
 drivers/scsi/bnx2i/bnx2i_hwi.c            |   16 ++++++++--------
 drivers/scsi/bnx2i/bnx2i_iscsi.c          |   14 +++++++-------
 drivers/scsi/ncr53c8xx.c                  |    2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.h       |    2 +-
 drivers/staging/iio/adc/ad7606.h          |    2 +-
 include/linux/amba/serial.h               |    2 +-
 include/linux/mfd/si476x-core.h           |    2 +-
 include/linux/netdevice.h                 |    2 +-
 include/net/bluetooth/l2cap.h             |    2 +-
 net/can/af_can.c                          |    2 +-
 net/netfilter/xt_set.c                    |    4 ++--
 19 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/arch/mips/include/asm/octeon/cvmx-pip.h b/arch/mips/include/asm/octeon/cvmx-pip.h
index a76fe5a..df69bfd 100644
--- a/arch/mips/include/asm/octeon/cvmx-pip.h
+++ b/arch/mips/include/asm/octeon/cvmx-pip.h
@@ -192,13 +192,13 @@ typedef struct {
 	/* Number of packets processed by PIP */
 	uint32_t packets;
 	/*
-	 * Number of indentified L2 multicast packets.	Does not
+	 * Number of identified L2 multicast packets.	Does not
 	 * include broadcast packets.  Only includes packets whose
 	 * parse mode is SKIP_TO_L2
 	 */
 	uint32_t multicast_packets;
 	/*
-	 * Number of indentified L2 broadcast packets.	Does not
+	 * Number of identified L2 broadcast packets.	Does not
 	 * include multicast packets.  Only includes packets whose
 	 * parse mode is SKIP_TO_L2
 	 */
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 1414c90..0641113 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -1,5 +1,5 @@
 /*
- *	Routines to indentify caches on Intel CPU.
+ *	Routines to identify caches on Intel CPU.
  *
  *	Changes:
  *	Venkatesh Pallipadi	: Adding cache identification through cpuid(4)
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index f2cc63e..b6f794a 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -1,5 +1,5 @@
 /*
- *	Routines to indentify additional cpu features that are scattered in
+ *	Routines to identify additional cpu features that are scattered in
  *	cpuid space.
  */
 #include <linux/cpu.h>
diff --git a/drivers/media/rc/keymaps/rc-dib0700-nec.c b/drivers/media/rc/keymaps/rc-dib0700-nec.c
index 4d13a7f..492a05a 100644
--- a/drivers/media/rc/keymaps/rc-dib0700-nec.c
+++ b/drivers/media/rc/keymaps/rc-dib0700-nec.c
@@ -5,7 +5,7 @@
  * TODO: This table is a real mess, as it merges RC codes from several
  * devices into a big table. It also has both RC-5 and NEC codes inside.
  * It should be broken into small tables, and the protocols should properly
- * be indentificated.
+ * be identificated.
  *
  * The table were imported from dib0700_devices.c.
  *
diff --git a/drivers/media/rc/keymaps/rc-dib0700-rc5.c b/drivers/media/rc/keymaps/rc-dib0700-rc5.c
index ba81d96..454ea59 100644
--- a/drivers/media/rc/keymaps/rc-dib0700-rc5.c
+++ b/drivers/media/rc/keymaps/rc-dib0700-rc5.c
@@ -5,7 +5,7 @@
  * TODO: This table is a real mess, as it merges RC codes from several
  * devices into a big table. It also has both RC-5 and NEC codes inside.
  * It should be broken into small tables, and the protocols should properly
- * be indentificated.
+ * be identificated.
  *
  * The table were imported from dib0700_devices.c.
  *
diff --git a/drivers/net/irda/ali-ircc.c b/drivers/net/irda/ali-ircc.c
index 7bbd318..befa45f 100644
--- a/drivers/net/irda/ali-ircc.c
+++ b/drivers/net/irda/ali-ircc.c
@@ -627,7 +627,7 @@ static int ali_ircc_setup(chipio_t *info)
 /*
  * Function ali_ircc_read_dongle_id (int index, info)
  *
- * Try to read dongle indentification. This procedure needs to be executed
+ * Try to read dongle identification. This procedure needs to be executed
  * once after power-on/reset. It also needs to be used whenever you suspect
  * that the user may have plugged/unplugged the IrDA Dongle.
  */
diff --git a/drivers/net/irda/nsc-ircc.c b/drivers/net/irda/nsc-ircc.c
index ceeb537..66bc03b 100644
--- a/drivers/net/irda/nsc-ircc.c
+++ b/drivers/net/irda/nsc-ircc.c
@@ -1035,7 +1035,7 @@ static int nsc_ircc_setup(chipio_t *info)
 /*
  * Function nsc_ircc_read_dongle_id (void)
  *
- * Try to read dongle indentification. This procedure needs to be executed
+ * Try to read dongle identification. This procedure needs to be executed
  * once after power-on/reset. It also needs to be used whenever you suspect
  * that the user may have plugged/unplugged the IrDA Dongle.
  */
diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index 132a905..0ca6448 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -344,7 +344,7 @@ void zfcp_dbf_san(char *tag, struct zfcp_dbf *dbf, void *data, u8 id, u16 len,
 
 /**
  * zfcp_dbf_san_req - trace event for issued SAN request
- * @tag: indentifier for event
+ * @tag: identifier for event
  * @fsf_req: request containing issued CT data
  * d_id: destination ID
  */
@@ -361,7 +361,7 @@ void zfcp_dbf_san_req(char *tag, struct zfcp_fsf_req *fsf, u32 d_id)
 
 /**
  * zfcp_dbf_san_res - trace event for received SAN request
- * @tag: indentifier for event
+ * @tag: identifier for event
  * @fsf_req: request containing issued CT data
  */
 void zfcp_dbf_san_res(char *tag, struct zfcp_fsf_req *fsf)
@@ -377,7 +377,7 @@ void zfcp_dbf_san_res(char *tag, struct zfcp_fsf_req *fsf)
 
 /**
  * zfcp_dbf_san_in_els - trace event for incoming ELS
- * @tag: indentifier for event
+ * @tag: identifier for event
  * @fsf_req: request containing issued CT data
  */
 void zfcp_dbf_san_in_els(char *tag, struct zfcp_fsf_req *fsf)
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 5be718c..e4cf23d 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -126,7 +126,7 @@ static void bnx2i_iscsi_license_error(struct bnx2i_hba *hba, u32 error_code)
 
 /**
  * bnx2i_arm_cq_event_coalescing - arms CQ to enable EQ notification
- * @ep:		endpoint (transport indentifier) structure
+ * @ep:		endpoint (transport identifier) structure
  * @action:	action, ARM or DISARM. For now only ARM_CQE is used
  *
  * Arm'ing CQ will enable chip to generate global EQ events inorder to interrupt
@@ -756,7 +756,7 @@ void bnx2i_send_cmd_cleanup_req(struct bnx2i_hba *hba, struct bnx2i_cmd *cmd)
 /**
  * bnx2i_send_conn_destroy - initiates iscsi connection teardown process
  * @hba:	adapter structure pointer
- * @ep:		endpoint (transport indentifier) structure
+ * @ep:		endpoint (transport identifier) structure
  *
  * this routine prepares and posts CONN_OFLD_REQ1/2 KWQE to initiate
  * 	iscsi connection context clean-up process
@@ -791,7 +791,7 @@ int bnx2i_send_conn_destroy(struct bnx2i_hba *hba, struct bnx2i_endpoint *ep)
 /**
  * bnx2i_570x_send_conn_ofld_req - initiates iscsi conn context setup process
  * @hba: 		adapter structure pointer
- * @ep: 		endpoint (transport indentifier) structure
+ * @ep: 		endpoint (transport identifier) structure
  *
  * 5706/5708/5709 specific - prepares and posts CONN_OFLD_REQ1/2 KWQE
  */
@@ -851,7 +851,7 @@ static int bnx2i_570x_send_conn_ofld_req(struct bnx2i_hba *hba,
 /**
  * bnx2i_5771x_send_conn_ofld_req - initiates iscsi connection context creation
  * @hba: 		adapter structure pointer
- * @ep: 		endpoint (transport indentifier) structure
+ * @ep: 		endpoint (transport identifier) structure
  *
  * 57710 specific - prepares and posts CONN_OFLD_REQ1/2 KWQE
  */
@@ -920,7 +920,7 @@ static int bnx2i_5771x_send_conn_ofld_req(struct bnx2i_hba *hba,
  * bnx2i_send_conn_ofld_req - initiates iscsi connection context setup process
  *
  * @hba: 		adapter structure pointer
- * @ep: 		endpoint (transport indentifier) structure
+ * @ep: 		endpoint (transport identifier) structure
  *
  * this routine prepares and posts CONN_OFLD_REQ1/2 KWQE
  */
@@ -939,7 +939,7 @@ int bnx2i_send_conn_ofld_req(struct bnx2i_hba *hba, struct bnx2i_endpoint *ep)
 
 /**
  * setup_qp_page_tables - iscsi QP page table setup function
- * @ep:		endpoint (transport indentifier) structure
+ * @ep:		endpoint (transport identifier) structure
  *
  * Sets up page tables for SQ/RQ/CQ, 1G/sec (5706/5708/5709) devices requires
  * 	64-bit address in big endian format. Whereas 10G/sec (57710) requires
@@ -1046,7 +1046,7 @@ static void setup_qp_page_tables(struct bnx2i_endpoint *ep)
 /**
  * bnx2i_alloc_qp_resc - allocates required resources for QP.
  * @hba:	adapter structure pointer
- * @ep:		endpoint (transport indentifier) structure
+ * @ep:		endpoint (transport identifier) structure
  *
  * Allocate QP (transport layer for iSCSI connection) resources, DMA'able
  *	memory for SQ/RQ/CQ and page tables. EP structure elements such
@@ -1191,7 +1191,7 @@ mem_alloc_err:
 /**
  * bnx2i_free_qp_resc - free memory resources held by QP
  * @hba:	adapter structure pointer
- * @ep:	endpoint (transport indentifier) structure
+ * @ep:	endpoint (transport identifier) structure
  *
  * Free QP resources - SQ/RQ/CQ memory and page tables.
  */
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index fabeb88..854dad7 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -596,7 +596,7 @@ void bnx2i_drop_session(struct iscsi_cls_session *cls_session)
 /**
  * bnx2i_ep_destroy_list_add - add an entry to EP destroy list
  * @hba:	pointer to adapter instance
- * @ep:		pointer to endpoint (transport indentifier) structure
+ * @ep:		pointer to endpoint (transport identifier) structure
  *
  * EP destroy queue manager
  */
@@ -613,7 +613,7 @@ static int bnx2i_ep_destroy_list_add(struct bnx2i_hba *hba,
  * bnx2i_ep_destroy_list_del - add an entry to EP destroy list
  *
  * @hba: 		pointer to adapter instance
- * @ep: 		pointer to endpoint (transport indentifier) structure
+ * @ep: 		pointer to endpoint (transport identifier) structure
  *
  * EP destroy queue manager
  */
@@ -630,7 +630,7 @@ static int bnx2i_ep_destroy_list_del(struct bnx2i_hba *hba,
 /**
  * bnx2i_ep_ofld_list_add - add an entry to ep offload pending list
  * @hba:	pointer to adapter instance
- * @ep:		pointer to endpoint (transport indentifier) structure
+ * @ep:		pointer to endpoint (transport identifier) structure
  *
  * pending conn offload completion queue manager
  */
@@ -646,7 +646,7 @@ static int bnx2i_ep_ofld_list_add(struct bnx2i_hba *hba,
 /**
  * bnx2i_ep_ofld_list_del - add an entry to ep offload pending list
  * @hba: 		pointer to adapter instance
- * @ep: 		pointer to endpoint (transport indentifier) structure
+ * @ep: 		pointer to endpoint (transport identifier) structure
  *
  * pending conn offload completion queue manager
  */
@@ -721,7 +721,7 @@ bnx2i_find_ep_in_destroy_list(struct bnx2i_hba *hba, u32 iscsi_cid)
 /**
  * bnx2i_ep_active_list_add - add an entry to ep active list
  * @hba:	pointer to adapter instance
- * @ep:		pointer to endpoint (transport indentifier) structure
+ * @ep:		pointer to endpoint (transport identifier) structure
  *
  * current active conn queue manager
  */
@@ -737,7 +737,7 @@ static void bnx2i_ep_active_list_add(struct bnx2i_hba *hba,
 /**
  * bnx2i_ep_active_list_del - deletes an entry to ep active list
  * @hba:	pointer to adapter instance
- * @ep:		pointer to endpoint (transport indentifier) structure
+ * @ep:		pointer to endpoint (transport identifier) structure
  *
  * current active conn queue manager
  */
@@ -1695,7 +1695,7 @@ no_nx2_route:
 /**
  * bnx2i_tear_down_conn - tear down iscsi/tcp connection and free resources
  * @hba:	pointer to adapter instance
- * @ep:		endpoint (transport indentifier) structure
+ * @ep:		endpoint (transport identifier) structure
  *
  * destroys cm_sock structure and on chip iscsi context
  */
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 5982a58..7d014b1 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -1615,7 +1615,7 @@ struct ncb {
 	spinlock_t	smp_lock;	/* Lock for SMP threading       */
 
 	/*----------------------------------------------------------------
-	**	Chip and controller indentification.
+	**	Chip and controller identification.
 	**----------------------------------------------------------------
 	*/
 	int		unit;		/* Unit number			*/
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.h b/drivers/scsi/sym53c8xx_2/sym_glue.h
index b80bf70..8053695 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.h
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.h
@@ -174,7 +174,7 @@ struct sym_slcb {
  */
 struct sym_shcb {
 	/*
-	 *  Chip and controller indentification.
+	 *  Chip and controller identification.
 	 */
 	int		unit;
 	char		inst_name[16];
diff --git a/drivers/staging/iio/adc/ad7606.h b/drivers/staging/iio/adc/ad7606.h
index 9221a74..93c7299 100644
--- a/drivers/staging/iio/adc/ad7606.h
+++ b/drivers/staging/iio/adc/ad7606.h
@@ -42,7 +42,7 @@ struct ad7606_platform_data {
 
 /**
  * struct ad7606_chip_info - chip specifc information
- * @name:		indentification string for chip
+ * @name:		identification string for chip
  * @int_vref_mv:	the internal reference voltage
  * @channels:		channel specification
  * @num_channels:	number of channels
diff --git a/include/linux/amba/serial.h b/include/linux/amba/serial.h
index 62d9303..0ddb5c0 100644
--- a/include/linux/amba/serial.h
+++ b/include/linux/amba/serial.h
@@ -40,7 +40,7 @@
 #define UART010_LCRL		0x10	/* Line control register, low byte. */
 #define UART010_CR		0x14	/* Control register. */
 #define UART01x_FR		0x18	/* Flag register (Read only). */
-#define UART010_IIR		0x1C	/* Interrupt indentification register (Read). */
+#define UART010_IIR		0x1C	/* Interrupt identification register (Read). */
 #define UART010_ICR		0x1C	/* Interrupt clear register (Write). */
 #define ST_UART011_LCRH_RX	0x1C    /* Rx line control register. */
 #define UART01x_ILPR		0x20	/* IrDA low power counter register. */
diff --git a/include/linux/mfd/si476x-core.h b/include/linux/mfd/si476x-core.h
index ba89b94..674b45d 100644
--- a/include/linux/mfd/si476x-core.h
+++ b/include/linux/mfd/si476x-core.h
@@ -316,7 +316,7 @@ enum si476x_smoothmetrics {
  * response to 'FM_RD_STATUS' command
  * @rdstpptyint: Traffic program flag(TP) and/or program type(PTY)
  * code has changed.
- * @rdspiint: Program indentifiaction(PI) code has changed.
+ * @rdspiint: Program identification(PI) code has changed.
  * @rdssyncint: RDS synchronization has changed.
  * @rdsfifoint: RDS was received and the RDS FIFO has at least
  * 'FM_RDS_INTERRUPT_FIFO_COUNT' elements in it.
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3de49ac..a329ae5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1546,7 +1546,7 @@ static inline void *netdev_priv(const struct net_device *dev)
 #define SET_NETDEV_DEV(net, pdev)	((net)->dev.parent = (pdev))
 
 /* Set the sysfs device type for the network logical device to allow
- * fin grained indentification of different network device types. For
+ * fine-grained identification of different network device types. For
  * example Ethernet, Wirelss LAN, Bluetooth, WiMAX etc.
  */
 #define SET_NETDEV_DEVTYPE(net, devtype)	((net)->dev.type = (devtype))
diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index 1a966af..7170b4b 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -238,7 +238,7 @@ struct l2cap_conn_rsp {
 #define L2CAP_PSM_SDP		0x0001
 #define L2CAP_PSM_RFCOMM	0x0003
 
-/* channel indentifier */
+/* channel identifier */
 #define L2CAP_CID_SIGNALING	0x0001
 #define L2CAP_CID_CONN_LESS	0x0002
 #define L2CAP_CID_A2MP		0x0003
diff --git a/net/can/af_can.c b/net/can/af_can.c
index 3ab8dd2..d249874 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -420,7 +420,7 @@ static struct hlist_head *find_rcv_list(canid_t *can_id, canid_t *mask,
  * @mask: CAN mask (see description)
  * @func: callback function on filter match
  * @data: returned parameter for callback function
- * @ident: string for calling module indentification
+ * @ident: string for calling module identification
  *
  * Description:
  *  Invokes the callback function with the received sk_buff and the given
diff --git a/net/netfilter/xt_set.c b/net/netfilter/xt_set.c
index 31790e7..4b9d6b4 100644
--- a/net/netfilter/xt_set.c
+++ b/net/netfilter/xt_set.c
@@ -84,7 +84,7 @@ set_match_v0_checkentry(const struct xt_mtchk_param *par)
 	index = ip_set_nfnl_get_byindex(info->match_set.index);
 
 	if (index == IPSET_INVALID_ID) {
-		pr_warning("Cannot find set indentified by id %u to match\n",
+		pr_warning("Cannot find set identified by id %u to match\n",
 			   info->match_set.index);
 		return -ENOENT;
 	}
@@ -205,7 +205,7 @@ set_match_v1_checkentry(const struct xt_mtchk_param *par)
 	index = ip_set_nfnl_get_byindex(info->match_set.index);
 
 	if (index == IPSET_INVALID_ID) {
-		pr_warning("Cannot find set indentified by id %u to match\n",
+		pr_warning("Cannot find set identified by id %u to match\n",
 			   info->match_set.index);
 		return -ENOENT;
 	}
-- 
1.7.9.5

