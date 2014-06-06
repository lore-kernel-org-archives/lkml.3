Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbaFFNw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 09:52:27 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:15174
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751601AbaFFNwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 09:52:25 -0400
X-WSS-ID: 0N6R2J9-07-CE3-02
X-M-MSG: 
Subject: [PATCH] amd-xgbe: Remove unnecessary include
To: <netdev@vger.kernel.org>, <davem@davemloft.net>, <sfr@canb.auug.org.au>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Fri, 6 Jun 2014 08:52:19 -0500
Message-ID: <20140606135219.32017.96806.stgit@tlendack-t1.amdoffice.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428001)(189002)(199002)(101416001)(84676001)(20776003)(46102001)(50466002)(53416003)(83072002)(85852003)(79102001)(4396001)(64706001)(81342001)(47776003)(83506001)(99396002)(68736004)(102836001)(80022001)(81542001)(86362001)(2201001)(76482001)(92566001)(92726001)(23676002)(87936001)(97746001)(97736001)(77982001)(21056001)(103116003)(33646001)(74502001)(44976005)(54356999)(31966008)(74662001)(50986999)(83322001)(19580405001)(19580395003)(71626003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB202;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 023495660C
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The include of asm/cputype.h breaks the powerpc build. This
include was accidentally left in from driver debugging and
can be removed.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
index 36bc86e..002293b 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
@@ -116,7 +116,6 @@
 
 #include <linux/phy.h>
 #include <linux/clk.h>
-#include <asm/cputype.h>
 
 #include "xgbe.h"
 #include "xgbe-common.h"

