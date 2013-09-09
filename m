Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab3IIWVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 18:21:49 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:57007 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab3IIWVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 18:21:47 -0400
From: "Nicholas A. Bellinger" <nab@daterainc.com>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: =?UTF-8?q?=5BPATCH=5D=20target=3A=20Update=20copyright=20ownership/year=20information=20to=202013?=
Date: Mon,  9 Sep 2013 22:05:19 +0000
Message-Id: <1378764319-25244-1-git-send-email-nab@daterainc.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Update copyright ownership/year information for target-core,
loopback, iscsi-target, tcm_qla2xx, vhost and iser-target.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c           |    2 +-
 drivers/scsi/qla2xxx/qla_target.c                 |    2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                |    7 ++-----
 drivers/target/iscsi/iscsi_target.c               |    4 +---
 drivers/target/iscsi/iscsi_target_auth.c          |    4 +---
 drivers/target/iscsi/iscsi_target_configfs.c      |    6 ++----
 drivers/target/iscsi/iscsi_target_datain_values.c |    4 +---
 drivers/target/iscsi/iscsi_target_device.c        |    4 +---
 drivers/target/iscsi/iscsi_target_erl0.c          |    4 +---
 drivers/target/iscsi/iscsi_target_erl1.c          |    4 +---
 drivers/target/iscsi/iscsi_target_erl2.c          |    4 +---
 drivers/target/iscsi/iscsi_target_login.c         |    4 +---
 drivers/target/iscsi/iscsi_target_nego.c          |    4 +---
 drivers/target/iscsi/iscsi_target_nodeattrib.c    |    4 +---
 drivers/target/iscsi/iscsi_target_parameters.c    |    4 +---
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c  |    4 +---
 drivers/target/iscsi/iscsi_target_stat.c          |    6 ++----
 drivers/target/iscsi/iscsi_target_tmr.c           |    4 +---
 drivers/target/iscsi/iscsi_target_tpg.c           |    4 +---
 drivers/target/iscsi/iscsi_target_tq.c            |    4 +---
 drivers/target/iscsi/iscsi_target_util.c          |    4 +---
 drivers/target/loopback/tcm_loop.c                |    2 +-
 drivers/target/target_core_alua.c                 |    2 +-
 drivers/target/target_core_configfs.c             |    2 +-
 drivers/target/target_core_device.c               |    2 +-
 drivers/target/target_core_fabric_configfs.c      |    2 +-
 drivers/target/target_core_fabric_lib.c           |    2 +-
 drivers/target/target_core_file.c                 |    2 +-
 drivers/target/target_core_hba.c                  |    2 +-
 drivers/target/target_core_iblock.c               |    2 +-
 drivers/target/target_core_pr.c                   |    2 +-
 drivers/target/target_core_pscsi.c                |    2 +-
 drivers/target/target_core_rd.c                   |    2 +-
 drivers/target/target_core_sbc.c                  |    2 +-
 drivers/target/target_core_spc.c                  |    2 +-
 drivers/target/target_core_stat.c                 |    2 +-
 drivers/target/target_core_tmr.c                  |    2 +-
 drivers/target/target_core_tpg.c                  |    2 +-
 drivers/target/target_core_transport.c            |    2 +-
 drivers/target/target_core_ua.c                   |    2 +-
 drivers/vhost/scsi.c                              |    4 ++--
 41 files changed, 45 insertions(+), 84 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 51c3bed..3591855 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1,7 +1,7 @@
 /*******************************************************************************
  * This file contains iSCSI extentions for RDMA (iSER) Verbs
  *
- * (c) Copyright 2013 RisingTide Systems LLC.
+ * (c) Copyright 2013 Datera, Inc.
  *
  * Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 83a8f7a..e0b1156 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -10,7 +10,7 @@
  *
  *  Forward port and refactoring to modern qla2xxx and target/configfs
  *
- *  Copyright (C) 2010-2011 Nicholas A. Bellinger <nab@kernel.org>
+ *  Copyright (C) 2010-2013 Nicholas A. Bellinger <nab@kernel.org>
  *
  *  This program is free software; you can redistribute it and/or
  *  modify it under the terms of the GNU General Public License
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index f790fca..69225bd 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -2,12 +2,9 @@
  * This file contains tcm implementation using v4 configfs fabric infrastructure
  * for QLogic target mode HBAs
  *
- * ?? Copyright 2010-2011 RisingTide Systems LLC.
+ * (c) Copyright 2010-2013 Datera, Inc.
  *
- * Licensed to the Linux Foundation under the General Public License (GPL)
- * version 2.
- *
- * Author: Nicholas A. Bellinger <nab@risingtidesystems.com>
+ * Author: Nicholas A. Bellinger <nab@daterainc.com>
  *
  * tcm_qla2xxx_parse_wwn() and tcm_qla2xxx_format_wwn() contains code from
  * the TCM_FC / Open-FCoE.org fabric module.
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index da6bbfe..db740e7 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1,9 +1,7 @@
 /*******************************************************************************
  * This file contains main functions related to the iSCSI Target Core Driver.
  *
- * \u00a9 Copyright 2007-2011 RisingTide Systems LLC.
- *
- * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
+ * (c) Copyright 2007-2013 Datera, Inc.
  *
  * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index cee1754..7505fdd 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -1,9 +1,7 @@
 /*******************************************************************************
  * This file houses the main functions for the iSCSI CHAP support
  *
- * \u00a9 Copyright 2007-2011 RisingTide Systems LLC.
- *
- * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
+ * (c) Copyright 2007-2013 Datera, Inc.
  *
  * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 116114f..fd14525 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -2,9 +2,7 @@
  * This file contains the configfs implementation for iSCSI Target mode
  * from the LIO-Target Project.
  *
- * \u00a9 Copyright 2007-2011 RisingTide Systems LLC.
- *
- * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
+ * (c) Copyright 2007-2013 Datera, Inc.
  *
  * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
@@ -1481,7 +1479,7 @@ static ssize_t lio_target_wwn_show_attr_lio_version(
 	struct target_fabric_configfs *tf,
 	char *page)
 {
-	return sprintf(page, "RisingTide Systems Linux-iSCSI Target "ISCSIT_VERSION"\n");
+	return sprintf(page, "Datera Inc. iSCSI Target "ISCSIT_VERSION"\n");
 }
 
 TF_WWN_ATTR_RO(lio_target, lio_version);
diff --git a/drivers/target/iscsi/iscsi_target_datain_values.c b/drivers/target/iscsi/iscsi_target_datain_values.c
index 848fee7..e93d5a7 100644
--- a/drivers/target/iscsi/iscsi_target_datain_values.c
+++ b/drivers/target/iscsi/iscsi_target_datain_values.c
@@ -1,9 +1,7 @@
 /*******************************************************************************
  * This file contains the iSCSI Target DataIN value generation functions.
  *
- * \u00a9 Copyright 2007-2011 RisingTide Systems LLC.
- *
- * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
+ * (c) Copyright 2007-2013 Datera, Inc.
  *
  * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
diff --git a/drivers/target/iscsi/iscsi_target_device.c b/drivers/target/iscsi/iscsi_target_device.c
index 1b74033..6c7a510 100644
--- a/drivers/target/iscsi/iscsi_target_device.c
+++ b/drivers/target/iscsi/iscsi_target_device.c
@@ -2,9 +2,7 @@
  * This file contains the iSCSI Virtual Device and Disk Transport
  * agnostic related functions.
  *
- \u00a9 Copyright 2007-2011 RisingTide Systems LLC.
- *
- * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
+ * (c) Copyright 2007-2013 Datera, Inc.
  *
  * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index 08bd878..41052e5 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -2,9 +2,7 @@
  * This file contains error recovery level zero functions used by
  * the iSCSI Target driver.
  *
- * \u00a9 Copyright 2007-2011 RisingTide Systems LLC.
- *
- * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
+ * (c) Copyright 2007-2013 Datera, Inc.
  *
  * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index 586c268..e048d64 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -1,9 +1,7 @@
 /*******************************************************************************
  * This file contains error recovery level one used by the iSCSI Target driver.
  *
- * \u00a9 Copyright 2007-2011 RisingTide Systems LLC.
- *
- * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
+ * (c) Copyright 2007-2013 Datera, Inc.
  *
  * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
diff --git a/drivers/target/iscsi/iscsi_target_erl2.c b/drivers/target/iscsi/iscsi_target_erl2.c
index 45a5afd..33be1fb 100644
--- a/drivers/target/iscsi/iscsi_target_erl2.c
+++ b/drivers/target/iscsi/iscsi_target_erl2.c
@@ -2,9 +2,7 @@
  * This file contains error recovery level two functions used by
  * the iSCSI Target driver.
  *
- * \u00a9 Copyright 2007-2011 RisingTide Systems LLC.
- *
- * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
+ * (c) Copyright 2007-2013 Datera, Inc.
  *
  * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index d903c0c..82ed9a9 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1,9 +1,7 @@
 /*******************************************************************************
  * This file contains the login functions used by the iSCSI Target driver.
  *
- * \u00a9 Copyright 2007-2011 RisingTide Systems LLC.
- *
- * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
+ * (c) Copyright 2007-2013 Datera, Inc.
  *
  * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 24b0e33..14d1aed 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -1,9 +1,7 @@
 /*******************************************************************************
  * This file contains main functions related to iSCSI Parameter negotiation.
  *
- * \u00a9 Copyright 2007-2011 RisingTide Systems LLC.
- *
- * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
+ * (c) Copyright 2007-2013 Datera, Inc.
  *
  * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
diff --git a/drivers/target/iscsi/iscsi_target_nodeattrib.c b/drivers/target/iscsi/iscsi_target_nodeattrib.c
index 11dc293..93bdc47 100644
--- a/drivers/target/iscsi/iscsi_target_nodeattrib.c
+++ b/drivers/target/iscsi/iscsi_target_nodeattrib.c
@@ -1,9 +1,7 @@
 /*******************************************************************************
  * This file contains the main functions related to Initiator Node Attributes.
  *
- * \u00a9 Copyright 2007-2011 RisingTide Systems LLC.
- *
- * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
+ * (c) Copyright 2007-2013 Datera, Inc.
  *
  * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 034bd6d..4d2e23f 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -1,9 +1,7 @@
 /*******************************************************************************
  * This file contains main functions related to iSCSI Parameter negotiation.
  *
- * \u00a9 Copyright 2007-2011 RisingTide Systems LLC.
- *
- * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
+ * (c) Copyright 2007-2013 Datera, Inc.
  *
  * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
diff --git a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
index edb592a..ca41b58 100644
--- a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
+++ b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
@@ -2,9 +2,7 @@
  * This file contains main functions related to iSCSI DataSequenceInOrder=No
  * and DataPDUInOrder=No.
  *
- \u00a9 Copyright 2007-2011 RisingTide Systems LLC.
- *
- * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
+ * (c) Copyright 2007-2013 Datera, Inc.
  *
  * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
diff --git a/drivers/target/iscsi/iscsi_target_stat.c b/drivers/target/iscsi/iscsi_target_stat.c
index 899bdb4..f788e8b 100644
--- a/drivers/target/iscsi/iscsi_target_stat.c
+++ b/drivers/target/iscsi/iscsi_target_stat.c
@@ -2,9 +2,7 @@
  * Modern ConfigFS group context specific iSCSI statistics based on original
  * iscsi_target_mib.c code
  *
- * Copyright (c) 2011 Rising Tide Systems
- *
- * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
+ * Copyright (c) 2011-2013 Datera, Inc.
  *
  * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
@@ -177,7 +175,7 @@ ISCSI_STAT_INSTANCE_ATTR_RO(description);
 static ssize_t iscsi_stat_instance_show_attr_vendor(
 	struct iscsi_wwn_stat_grps *igrps, char *page)
 {
-	return snprintf(page, PAGE_SIZE, "RisingTide Systems iSCSI-Target\n");
+	return snprintf(page, PAGE_SIZE, "Datera, Inc. iSCSI-Target\n");
 }
 ISCSI_STAT_INSTANCE_ATTR_RO(vendor);
 
diff --git a/drivers/target/iscsi/iscsi_target_tmr.c b/drivers/target/iscsi/iscsi_target_tmr.c
index b997e5d..78404b1 100644
--- a/drivers/target/iscsi/iscsi_target_tmr.c
+++ b/drivers/target/iscsi/iscsi_target_tmr.c
@@ -1,9 +1,7 @@
 /*******************************************************************************
  * This file contains the iSCSI Target specific Task Management functions.
  *
- * \u00a9 Copyright 2007-2011 RisingTide Systems LLC.
- *
- * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
+ * (c) Copyright 2007-2013 Datera, Inc.
  *
  * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index e070ce2..4faeb47 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -1,9 +1,7 @@
 /*******************************************************************************
  * This file contains iSCSI Target Portal Group related functions.
  *
- * \u00a9 Copyright 2007-2011 RisingTide Systems LLC.
- *
- * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
+ * (c) Copyright 2007-2013 Datera, Inc.
  *
  * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
diff --git a/drivers/target/iscsi/iscsi_target_tq.c b/drivers/target/iscsi/iscsi_target_tq.c
index 39c7dfa..c1b5143 100644
--- a/drivers/target/iscsi/iscsi_target_tq.c
+++ b/drivers/target/iscsi/iscsi_target_tq.c
@@ -1,9 +1,7 @@
 /*******************************************************************************
  * This file contains the iSCSI Login Thread and Thread Queue functions.
  *
- * \u00a9 Copyright 2007-2011 RisingTide Systems LLC.
- *
- * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
+ * (c) Copyright 2007-2013 Datera, Inc.
  *
  * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 8d85d8c..f2de28e 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -1,9 +1,7 @@
 /*******************************************************************************
  * This file contains the iSCSI Target specific utility functions.
  *
- * \u00a9 Copyright 2007-2011 RisingTide Systems LLC.
- *
- * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
+ * (c) Copyright 2007-2013 Datera, Inc.
  *
  * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 568ad25..0f6d69d 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -3,7 +3,7 @@
  * This file contains the Linux/SCSI LLD virtual SCSI initiator driver
  * for emulated SAS initiator ports
  *
- * © Copyright 2011 RisingTide Systems LLC.
+ * © Copyright 2011-2013 Datera, Inc.
  *
  * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
  *
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index ea928c4..e56822e 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -3,7 +3,7 @@
  *
  * This file contains SPC-3 compliant asymmetric logical unit assigntment (ALUA)
  *
- * (c) Copyright 2009-2012 RisingTide Systems LLC.
+ * (c) Copyright 2009-2013 Datera, Inc.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 328f425..82e81c5 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3,7 +3,7 @@
  *
  * This file contains ConfigFS logic for the Generic Target Engine project.
  *
- * (c) Copyright 2008-2012 RisingTide Systems LLC.
+ * (c) Copyright 2008-2013 Datera, Inc.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index f9f1793..d90dbb0 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -4,7 +4,7 @@
  * This file contains the TCM Virtual Device and Disk Transport
  * agnostic related functions.
  *
- * (c) Copyright 2003-2012 RisingTide Systems LLC.
+ * (c) Copyright 2003-2013 Datera, Inc.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index f5ce68f..3503996 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -4,7 +4,7 @@
  * This file contains generic fabric module configfs infrastructure for
  * TCM v4.x code
  *
- * (c) Copyright 2010-2012 RisingTide Systems LLC.
+ * (c) Copyright 2010-2013 Datera, Inc.
  *
  * Nicholas A. Bellinger <nab@linux-iscsi.org>
 *
diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 687b0b0..0d1cf8b 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -4,7 +4,7 @@
  * This file contains generic high level protocol identifier and PR
  * handlers for TCM fabric modules
  *
- * (c) Copyright 2010-2012 RisingTide Systems LLC.
+ * (c) Copyright 2010-2013 Datera, Inc.
  *
  * Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index c5448a5..b662f89 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -3,7 +3,7 @@
  *
  * This file contains the Storage Engine <-> FILEIO transport specific functions
  *
- * (c) Copyright 2005-2012 RisingTide Systems LLC.
+ * (c) Copyright 2005-2013 Datera, Inc.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index d2616cd..a25051a 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -3,7 +3,7 @@
  *
  * This file contains the TCM HBA Transport related functions.
  *
- * (c) Copyright 2003-2012 RisingTide Systems LLC.
+ * (c) Copyright 2003-2013 Datera, Inc.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 81464eb..b9a3394 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -4,7 +4,7 @@
  * This file contains the Storage Engine  <-> Linux BlockIO transport
  * specific functions.
  *
- * (c) Copyright 2003-2012 RisingTide Systems LLC.
+ * (c) Copyright 2003-2013 Datera, Inc.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index bd78faf..99ea1db 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -4,7 +4,7 @@
  * This file contains SPC-3 compliant persistent reservations and
  * legacy SPC-2 reservations with compatible reservation handling (CRH=1)
  *
- * (c) Copyright 2009-2012 RisingTide Systems LLC.
+ * (c) Copyright 2009-2013 Datera, Inc.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 9170b36..551c96c 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -3,7 +3,7 @@
  *
  * This file contains the generic target mode <-> Linux SCSI subsystem plugin.
  *
- * (c) Copyright 2003-2012 RisingTide Systems LLC.
+ * (c) Copyright 2003-2013 Datera, Inc.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 958d17ad..131327a 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -4,7 +4,7 @@
  * This file contains the Storage Engine <-> Ramdisk transport
  * specific functions.
  *
- * (c) Copyright 2003-2012 RisingTide Systems LLC.
+ * (c) Copyright 2003-2013 Datera, Inc.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index aa1379d..2572ba7 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1,7 +1,7 @@
 /*
  * SCSI Block Commands (SBC) parsing and emulation.
  *
- * (c) Copyright 2002-2012 RisingTide Systems LLC.
+ * (c) Copyright 2002-2013 Datera, Inc.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 566dd27..6144b69 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1,7 +1,7 @@
 /*
  * SCSI Primary Commands (SPC) parsing and emulation.
  *
- * (c) Copyright 2002-2012 RisingTide Systems LLC.
+ * (c) Copyright 2002-2013 Datera, Inc.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index d154ce7..9c642e0 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -4,7 +4,7 @@
  * Modern ConfigFS group context specific statistics based on original
  * target_core_mib.c code
  *
- * (c) Copyright 2006-2012 RisingTide Systems LLC.
+ * (c) Copyright 2006-2013 Datera, Inc.
  *
  * Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 0d7cacb..2500099 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -3,7 +3,7 @@
  *
  * This file contains SPC-3 task management infrastructure
  *
- * (c) Copyright 2009-2012 RisingTide Systems LLC.
+ * (c) Copyright 2009-2013 Datera, Inc.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index aac9d27..b9a6ec0 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -3,7 +3,7 @@
  *
  * This file contains generic Target Portal Group related functions.
  *
- * (c) Copyright 2002-2012 RisingTide Systems LLC.
+ * (c) Copyright 2002-2013 Datera, Inc.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 6d0e523..2cc723d 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3,7 +3,7 @@
  *
  * This file contains the Generic Target Engine Core.
  *
- * (c) Copyright 2002-2012 RisingTide Systems LLC.
+ * (c) Copyright 2002-2013 Datera, Inc.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index bf0e390..b04467e 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -3,7 +3,7 @@
  *
  * This file contains logic for SPC-3 Unit Attention emulation
  *
- * (c) Copyright 2009-2012 RisingTide Systems LLC.
+ * (c) Copyright 2009-2013 Datera, Inc.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index d52a3a0..4b79a1f 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1,12 +1,12 @@
 /*******************************************************************************
  * Vhost kernel TCM fabric driver for virtio SCSI initiators
  *
- * (C) Copyright 2010-2012 RisingTide Systems LLC.
+ * (C) Copyright 2010-2013 Datera, Inc.
  * (C) Copyright 2010-2012 IBM Corp.
  *
  * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
  *
- * Authors: Nicholas A. Bellinger <nab@risingtidesystems.com>
+ * Authors: Nicholas A. Bellinger <nab@daterainc.com>
  *          Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
  *
  * This program is free software; you can redistribute it and/or modify
-- 
1.7.2.5

