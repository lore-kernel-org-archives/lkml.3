Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbaFYKp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:45:26 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:51899
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756298AbaFYKpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:45:23 -0400
Date: Wed, 25 Jun 2014 16:10:40 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@avagotech.com>,
        <Nagalakshmi.Nandigama@avagotech.com>, <sreekanth.reddy@avagotech.com>,
        <linux-kernel@vger.kernel.org>, <hch@infradead.org>,
        <martin.petersen@oracle.com>
Subject: [RESEND][PATCH 5/8][SCSI]mpt3sas: Copyright in driver sources is
 updated for year the 2014
Message-ID: <20140625104040.GA13023@avagotech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130481667091778292;(f081dce6-2920-4dfc-23e8-08d07091c5e3);()
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(26826002)(44976005)(6806004)(19580395003)(47776003)(20776003)(23726002)(19580405001)(83322001)(57986006)(76506005)(77096002)(92566001)(102836001)(81342001)(33656002)(85306003)(77982001)(4396001)(64706001)(50466002)(54356999)(50986999)(81542001)(79102001)(21056001)(92726001)(36756003)(80022001)(83072002)(575784001)(86362001)(85852003)(83506001)(46102001)(31966008)(74502001)(16796002)(74662001)(76482001)(99396002)(87936001)(97756001)(105596002)(46406003)(106466001)(95666004)(107046001)(2004002)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR07MB017;H:COSEXCH10.lsi.com;FPR:;MLV:ovr;PTR:cosexch10.lsi.com;A:1;MX:1;LANG:;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 02530BD3AA
Authentication-Results: spf=softfail (sender IP is 192.19.220.100)
 smtp.mailfrom=Sreekanth.Reddy@avagotech.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copyright in driver sources is updated for year the 2014.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/Kconfig                |    2 +-
 drivers/scsi/mpt3sas/mpi/mpi2.h             |    2 +-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h        |    2 +-
 drivers/scsi/mpt3sas/mpi/mpi2_init.h        |    2 +-
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h         |    2 +-
 drivers/scsi/mpt3sas/mpi/mpi2_raid.h        |    2 +-
 drivers/scsi/mpt3sas/mpi/mpi2_sas.h         |    2 +-
 drivers/scsi/mpt3sas/mpi/mpi2_tool.h        |    2 +-
 drivers/scsi/mpt3sas/mpi/mpi2_type.h        |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c         |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h         |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c       |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.h          |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_debug.h        |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c    |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.h |    2 +-
 19 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/mpt3sas/Kconfig b/drivers/scsi/mpt3sas/Kconfig
index d53e1b0..4d235dd 100644
--- a/drivers/scsi/mpt3sas/Kconfig
+++ b/drivers/scsi/mpt3sas/Kconfig
@@ -2,7 +2,7 @@
 # Kernel configuration file for the MPT3SAS
 #
 # This code is based on drivers/scsi/mpt3sas/Kconfig
-# Copyright (C) 2012-2013  LSI Corporation
+# Copyright (C) 2012-2014  LSI Corporation
 #  (mailto:DL-MPTFusionLinux@lsi.com)
 
 # This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2.h b/drivers/scsi/mpt3sas/mpi/mpi2.h
index dc143dd..c34c115 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2013 LSI Corporation.
+ * Copyright (c) 2000-2014 LSI Corporation.
  *
  *
  *          Name:  mpi2.h
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
index becee07..e261a31 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2013 LSI Corporation.
+ * Copyright (c) 2000-2014 LSI Corporation.
  *
  *
  *          Name:  mpi2_cnfg.h
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_init.h b/drivers/scsi/mpt3sas/mpi/mpi2_init.h
index b3e3331..068c98e 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_init.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_init.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2013 LSI Corporation.
+ * Copyright (c) 2000-2014 LSI Corporation.
  *
  *
  *          Name:  mpi2_init.h
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h b/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
index 15813f3..4908309 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2013 LSI Corporation.
+ * Copyright (c) 2000-2014 LSI Corporation.
  *
  *
  *          Name:  mpi2_ioc.h
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_raid.h b/drivers/scsi/mpt3sas/mpi/mpi2_raid.h
index fbe3aae..13d93ca 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_raid.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_raid.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2013 LSI Corporation.
+ * Copyright (c) 2000-2014 LSI Corporation.
  *
  *
  *          Name:  mpi2_raid.h
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_sas.h b/drivers/scsi/mpt3sas/mpi/mpi2_sas.h
index 361a275..156e305 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_sas.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_sas.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2013 LSI Corporation.
+ * Copyright (c) 2000-2014 LSI Corporation.
  *
  *
  *          Name:  mpi2_sas.h
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_tool.h b/drivers/scsi/mpt3sas/mpi/mpi2_tool.h
index 94e32c2..904910d 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_tool.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_tool.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2013 LSI Corporation.
+ * Copyright (c) 2000-2014 LSI Corporation.
  *
  *
  *          Name:  mpi2_tool.h
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_type.h b/drivers/scsi/mpt3sas/mpi/mpi2_type.h
index ba1fed5..99ab093 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_type.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_type.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2000-2013 LSI Corporation.
+ *  Copyright (c) 2000-2014 LSI Corporation.
  *
  *
  *           Name:  mpi2_type.h
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index d46956e..8c77cd4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3,7 +3,7 @@
  * for access to MPT (Message Passing Technology) firmware.
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_base.c
- * Copyright (C) 2012-2013  LSI Corporation
+ * Copyright (C) 2012-2014  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 0f7add9..f163423 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -3,7 +3,7 @@
  * for access to MPT (Message Passing Technology) firmware.
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_base.h
- * Copyright (C) 2012-2013  LSI Corporation
+ * Copyright (C) 2012-2014  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 936ec03..4472c2a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -2,7 +2,7 @@
  * This module provides common API for accessing firmware configuration pages
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_base.c
- * Copyright (C) 2012-2013  LSI Corporation
+ * Copyright (C) 2012-2014  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 9b89de1..69fcfd4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3,7 +3,7 @@
  * controllers
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_ctl.c
- * Copyright (C) 2012-2013  LSI Corporation
+ * Copyright (C) 2012-2014  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.h b/drivers/scsi/mpt3sas/mpt3sas_ctl.h
index 53b0c48..5f3d7fd 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.h
@@ -3,7 +3,7 @@
  * controllers
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_ctl.h
- * Copyright (C) 2012-2013  LSI Corporation
+ * Copyright (C) 2012-2014  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt3sas/mpt3sas_debug.h b/drivers/scsi/mpt3sas/mpt3sas_debug.h
index 545b22d..4778e7d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_debug.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_debug.h
@@ -2,7 +2,7 @@
  * Logging Support for MPT (Message Passing Technology) based controllers
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_debug.c
- * Copyright (C) 2012-2013  LSI Corporation
+ * Copyright (C) 2012-2014  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 905c82c..76c8515 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2,7 +2,7 @@
  * Scsi Host Layer for MPT (Message Passing Technology) based controllers
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_scsih.c
- * Copyright (C) 2012-2013  LSI Corporation
+ * Copyright (C) 2012-2014  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 65170cb..d4bafaa 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -2,7 +2,7 @@
  * SAS Transport Layer for MPT (Message Passing Technology) based controllers
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_transport.c
- * Copyright (C) 2012-2013  LSI Corporation
+ * Copyright (C) 2012-2014  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
index f6533ab..8a2dd11 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
@@ -3,7 +3,7 @@
  * (Message Passing Technology) based controllers
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
- * Copyright (C) 2012-2013  LSI Corporation
+ * Copyright (C) 2012-2014  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.h b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.h
index bb69392..f681db5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.h
@@ -4,7 +4,7 @@
  * controllers
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_base.h
- * Copyright (C) 2012-2013  LSI Corporation
+ * Copyright (C) 2012-2014  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
-- 
1.7.1

