Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbaFTHxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 03:53:39 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:58854
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752358AbaFTHxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 03:53:38 -0400
From: Sorin Dumitru <sdumitru@ixiacom.com>
To: <linux-kernel@vger.kernel.org>, <linux-mips@linux-mips.org>
CC: <ralf@linux-mips.org>, <sdumitru@ixiacom.com>
Subject: [PATCH] mips: n32: use compat getsockopt syscall
Date: Fri, 20 Jun 2014 10:53:06 +0300
Message-ID: <1403250786-9763-1-git-send-email-sdumitru@ixiacom.com>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [205.168.23.154]
X-ClientProxiedBy: CO2PR05CA030.namprd05.prod.outlook.com (10.141.241.158) To
 BLUPR0601MB0946.namprd06.prod.outlook.com (25.160.35.22)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 024847EE92
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(428001)(189002)(199002)(81156003)(95666004)(93916002)(86362001)(33646001)(77096002)(50986999)(21056001)(101416001)(85306003)(46102001)(92726001)(76482001)(69596002)(19580395003)(19580405001)(83322001)(62966002)(77982001)(64706001)(79102001)(66066001)(106356001)(81542001)(80022001)(81342001)(47776003)(20776003)(42186005)(53416004)(87286001)(105586002)(4396001)(104166001)(99396002)(74662001)(50226001)(50466002)(87976001)(88136002)(48376002)(36756003)(83072002)(85852003)(77156001)(89996001)(102836001)(74502001)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR0601MB0946;H:ixro-sdumitru.ixiacom.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=sdumitru@ixiacom.com; 
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 205.168.23.154
X-MS-Exchange-CrossPremises-AuthSource: BLUPR0601MB0946.namprd06.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-AVStamp-Service: 1.0
X-MS-Exchange-CrossPremises-SCL: 1
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating;SFV:NSPM;SKIP:0;
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: BLUPR0601MB0946.namprd06.prod.outlook.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: ixiacom.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sorin Dumitru <sdumitru@ixiacom.com>
---
 arch/mips/kernel/scall64-n32.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kernel/scall64-n32.S b/arch/mips/kernel/scall64-n32.S
index c1dbcda..e543861 100644
--- a/arch/mips/kernel/scall64-n32.S
+++ b/arch/mips/kernel/scall64-n32.S
@@ -162,7 +162,7 @@ EXPORT(sysn32_call_table)
 	PTR	sys_getpeername
 	PTR	sys_socketpair
 	PTR	compat_sys_setsockopt
-	PTR	sys_getsockopt
+	PTR	compat_sys_getsockopt
 	PTR	__sys_clone			/* 6055 */
 	PTR	__sys_fork
 	PTR	compat_sys_execve
-- 
2.0.0

