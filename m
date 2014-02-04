Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbaBDSuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 13:50:46 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:52584 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbaBDSun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 13:50:43 -0500
From: "Steven J. Magnani" <steve.magnani@digidescorp.com>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH] qla2xxx: Re-sync module parameter descriptions with the code
Date: Tue,  4 Feb 2014 12:50:35 -0600
Message-Id: <1391539835-8431-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix module parameter descriptions mentioning default values that no longer
match the code.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN linux-3.14-rc1/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- linux-3.14-rc1/drivers/scsi/qla2xxx/qla_os.c	2014-02-02 18:42:13.000000000 -0600
+++ b/drivers/scsi/qla2xxx/qla_os.c	2014-02-04 12:41:45.133576764 -0600
@@ -120,15 +120,17 @@ MODULE_PARM_DESC(ql2xmaxqdepth,
 int ql2xenabledif = 2;
 module_param(ql2xenabledif, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xenabledif,
-		" Enable T10-CRC-DIF "
-		" Default is 0 - No DIF Support. 1 - Enable it"
-		", 2 - Enable DIF for all types, except Type 0.");
+		" Enable T10-CRC-DIF:\n"
+		" Default is 2.\n"
+		"  0 -- No DIF Support\n"
+		"  1 -- Enable DIF for all types\n"
+		"  2 -- Enable DIF for all types, except Type 0.\n");
 
 int ql2xenablehba_err_chk = 2;
 module_param(ql2xenablehba_err_chk, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xenablehba_err_chk,
 		" Enable T10-CRC-DIF Error isolation by HBA:\n"
-		" Default is 1.\n"
+		" Default is 2.\n"
 		"  0 -- Error isolation disabled\n"
 		"  1 -- Error isolation enabled only for DIX Type 0\n"
 		"  2 -- Error isolation enabled for all Types\n");
