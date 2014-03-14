Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbaCNPnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:43:09 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:15402
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754841AbaCNPnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:43:08 -0400
Date: Fri, 14 Mar 2014 21:08:27 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@lsi.com>,
        <Nagalakshmi.Nandigama@lsi.com>, <sreekanth.reddy@lsi.com>,
        <linux-kernel@vger.kernel.org>, <sreekanthreddy0547@gmail.com>
Subject: [PATCH 04/11][SCSI]mpt2sas: Copyright in driver sources is updated
 for year the 2014
Message-ID: <20140314153827.GA7970@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(199002)(189002)(46406003)(4396001)(95416001)(77982001)(93516002)(50986001)(90146001)(76786001)(76176001)(56816005)(47736001)(77096001)(83072002)(85852003)(76796001)(94316002)(59766001)(23726002)(47776003)(74706001)(63696002)(92726001)(87936001)(92566001)(47976001)(20776003)(79102001)(81816001)(94946001)(50466002)(74876001)(49866001)(87266001)(93136001)(57986002)(80022001)(19580405001)(46102001)(56776001)(19580395003)(54316002)(76482001)(69226001)(83322001)(85306002)(80976001)(74502001)(54356001)(81342001)(6806004)(97186001)(97336001)(74662001)(16796002)(31966008)(33656001)(44976005)(53806001)(47446002)(86362001)(65816001)(97756001)(81686001)(51856001)(83506001)(74366001)(95666003)(36756003)(81542001)(2004002)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR07MB067;H:COSEXCH10.lsi.com;FPR:AC674E5E.E8169E6E.CED4BBBF.C3768242.20256;PTR:cosexch10.lsi.com;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0150F3F97D
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copyright in driver sources is updated for year the 2014.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 drivers/scsi/mpt2sas/Kconfig             |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c      |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_base.h      |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_config.c    |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c       |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.h       |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_debug.h     |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c     |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_transport.c |    2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mpt2sas/Kconfig b/drivers/scsi/mpt2sas/Kconfig
index 39f08dd..657b45c 100644
--- a/drivers/scsi/mpt2sas/Kconfig
+++ b/drivers/scsi/mpt2sas/Kconfig
@@ -2,7 +2,7 @@
 # Kernel configuration file for the MPT2SAS
 #
 # This code is based on drivers/scsi/mpt2sas/Kconfig
-# Copyright (C) 2007-2012  LSI Corporation
+# Copyright (C) 2007-2014  LSI Corporation
 #  (mailto:DL-MPTFusionLinux@lsi.com)
 
 # This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 7355b28..774720f 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3,7 +3,7 @@
  * for access to MPT (Message Passing Technology) firmware.
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_base.c
- * Copyright (C) 2007-2013  LSI Corporation
+ * Copyright (C) 2007-2014  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 61b02ee..863a248 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -3,7 +3,7 @@
  * for access to MPT (Message Passing Technology) firmware.
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_base.h
- * Copyright (C) 2007-2013  LSI Corporation
+ * Copyright (C) 2007-2014  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
index 0c47425..c72a2ff 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_config.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
@@ -2,7 +2,7 @@
  * This module provides common API for accessing firmware configuration pages
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_base.c
- * Copyright (C) 2007-2013  LSI Corporation
+ * Copyright (C) 2007-2014  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index b7f887c..5221c4b 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -3,7 +3,7 @@
  * controllers
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_ctl.c
- * Copyright (C) 2007-2013  LSI Corporation
+ * Copyright (C) 2007-2014  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.h b/drivers/scsi/mpt2sas/mpt2sas_ctl.h
index 8b2ac18..fa0567c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.h
@@ -3,7 +3,7 @@
  * controllers
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_ctl.h
- * Copyright (C) 2007-2013  LSI Corporation
+ * Copyright (C) 2007-2014  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt2sas/mpt2sas_debug.h b/drivers/scsi/mpt2sas/mpt2sas_debug.h
index a9021cb..cc57ef3 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_debug.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_debug.h
@@ -2,7 +2,7 @@
  * Logging Support for MPT (Message Passing Technology) based controllers
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_debug.c
- * Copyright (C) 2007-2013  LSI Corporation
+ * Copyright (C) 2007-2014  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index d502728..5ee6bf0 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2,7 +2,7 @@
  * Scsi Host Layer for MPT (Message Passing Technology) based controllers
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_scsih.c
- * Copyright (C) 2007-2013  LSI Corporation
+ * Copyright (C) 2007-2014  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index 410f4a3..0d1d064 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -2,7 +2,7 @@
  * SAS Transport Layer for MPT (Message Passing Technology) based controllers
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_transport.c
- * Copyright (C) 2007-2013  LSI Corporation
+ * Copyright (C) 2007-2014  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
-- 
1.7.1

