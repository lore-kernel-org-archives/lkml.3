Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaGGIK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 04:10:56 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:45468
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750855AbaGGIKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 04:10:53 -0400
From: Cristian Stoica <cristian.stoica@freescale.com>
To: Randy Dunlap <rdunlap@infradead.org>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Cristian Stoica" <cristian.stoica@freescale.com>
Subject: [PATCH] Documentation: devres: update list of supported calls
Date: Mon, 7 Jul 2014 11:10:26 +0300
Message-ID: <1404720626-20841-1-git-send-email-cristian.stoica@freescale.com>
X-Mailer: git-send-email 1.8.3.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(104016002)(86362001)(50986999)(85306003)(87286001)(74502001)(33646001)(83322001)(84676001)(104166001)(95666004)(26826002)(107046002)(21056001)(62966002)(31966008)(97736001)(99396002)(105606002)(74662001)(64706001)(110136001)(46102001)(81156004)(79102001)(81542001)(76482001)(102836001)(80022001)(69596002)(20776003)(77156001)(19580395003)(4396001)(50226001)(81342001)(19580405001)(85852003)(92566001)(106466001)(36756003)(48376002)(50466002)(93916002)(44976005)(229853001)(77982001)(83072002)(87936001)(89996001)(88136002)(68736004)(6806004)(92726001)(47776003);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB349;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02652BD10A
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=cristian.stoica@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 Documentation/driver-model/devres.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index 1525e30..7a48896 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -234,6 +234,7 @@ certainly invest a bit more effort into libata core layer).
   -----------------------------
 
 MEM
+  devm_kmalloc()
   devm_kzalloc()
   devm_kfree()
   devm_kmemdup()
-- 
1.8.3.1

