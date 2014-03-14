Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbaCNQR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:17:26 -0400
Received: from [207.46.163.182] ([207.46.163.182]:40444 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753644AbaCNQRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:17:24 -0400
Date: Fri, 14 Mar 2014 21:42:49 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@lsi.com>,
        <Nagalakshmi.Nandigama@lsi.com>, <sreekanth.reddy@lsi.com>,
        <linux-kernel@vger.kernel.org>, <sreekanthreddy0547@gmail.com>
Subject: [PATCH 6/9][SCSI]mpt3sas: Copyright in driver sources is updated for
 year the 2014
Message-ID: <20140314161249.GA8393@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(189002)(199002)(80022001)(65816001)(80976001)(83072002)(44976005)(93516002)(90146001)(81686001)(33656001)(47976001)(69226001)(46102001)(97186001)(97756001)(19580395003)(51856001)(83322001)(19580405001)(575784001)(86362001)(77982001)(53806001)(95666003)(59766001)(50986001)(93136001)(54356001)(87936001)(83506001)(6806004)(56816005)(85852003)(47736001)(81342001)(81816001)(74876001)(54316002)(97336001)(56776001)(79102001)(85306002)(76786001)(76796001)(81542001)(23726002)(87266001)(76482001)(94316002)(77096001)(47776003)(74366001)(4396001)(49866001)(46406003)(50466002)(74706001)(92726001)(74662001)(92566001)(74502001)(95416001)(47446002)(16796002)(20776003)(57986002)(63696002)(36756003)(31966008)(94946001)(76176001)(2004002)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:SN2PR07MB078;H:COSEXCH10.lsi.com;CLIP:192.19.220.100;FPR:AD26526E.282A826E.88F08BF7.4F7870A0.2031E;PTR:cosexch10.lsi.com;MX:1;A:1;LANG:;
X-Forefront-PRVS: 0150F3F97D
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copyright in driver sources is updated for year the 2014.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
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

