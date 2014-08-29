Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaH2C1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 22:27:00 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:46126
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751470AbaH2C06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 22:26:58 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <shawn.guo@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] ARM: dts: vf610-twr: remove useless property for sound card.
Date: Fri, 29 Aug 2014 10:22:21 +0800
Message-ID: <1409278941-16975-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(189002)(36756003)(93916002)(68736004)(89996001)(74662001)(26826002)(46102001)(92726001)(50226001)(19580395003)(85852003)(31966008)(74502001)(86362001)(2201001)(92566001)(4396001)(69596002)(6806004)(76482001)(90102001)(229853001)(44976005)(80022001)(83322001)(77156001)(79102001)(99396002)(97736001)(83072002)(20776003)(19580405001)(87286001)(50466002)(47776003)(105606002)(48376002)(81542001)(21056001)(77982001)(62966002)(88136002)(84676001)(95666004)(104016003)(50986999)(64706001)(81342001)(106466001)(104166001)(102836001)(87936001)(85306004)(107046002)(81156004);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0301MB0623;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0318501FAE
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was added by:
Commit 8128c4f36 ("ARM: dts: vf610-twr: Add simple-card support.")

This useless property may cause some confusions for users.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 arch/arm/boot/dts/vf610-twr.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/vf610-twr.dts b/arch/arm/boot/dts/vf610-twr.dts
index 58e988e..82d16ac 100644
--- a/arch/arm/boot/dts/vf610-twr.dts
+++ b/arch/arm/boot/dts/vf610-twr.dts
@@ -76,7 +76,6 @@
 
 		simple-audio-card,cpu {
 			sound-dai = <&sai2>;
-			master-clkdir-out;
 			frame-master;
 			bitclock-master;
 		};
-- 
1.8.5

