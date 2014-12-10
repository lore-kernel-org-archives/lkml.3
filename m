Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbaLJIsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 03:48:54 -0500
Received: from mail-bn1bbn0104.outbound.protection.outlook.com ([157.56.111.104]:60645
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754597AbaLJIsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 03:48:51 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <p.zabel@pengutronix.de>,
        <thierry.reding@gmail.com>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
        <mturquette@linaro.org>, <airlied@linux.ie>
Subject: [PATCH RFC 02/15] of: Add vendor prefix for Himax Technologies Inc.
Date: Wed, 10 Dec 2014 16:37:15 +0800
Message-ID: <1418200648-32656-3-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418200648-32656-1-git-send-email-Ying.Liu@freescale.com>
References: <1418200648-32656-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(86362001)(48376002)(50466002)(4396001)(64706001)(47776003)(20776003)(104016003)(97736003)(68736005)(62966003)(21056001)(77156002)(36756003)(110136001)(77096005)(99396003)(46102003)(120916001)(106466001)(19580395003)(19580405001)(87936001)(89996001)(105606002)(84676001)(31966008)(76176999)(229853001)(50986999)(92566001)(50226001)(6806004)(107046002)(2351001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0636;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0636;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:CY1PR0301MB0636;
X-Forefront-PRVS: 0421BF7135
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0636;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 78efebb..3cee528 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -69,6 +69,7 @@ hannstar	HannStar Display Corporation
 haoyu	Haoyu Microelectronic Co. Ltd.
 hisilicon	Hisilicon Limited.
 hit	Hitachi Ltd.
+himax	Himax Technologies, Inc.
 honeywell	Honeywell
 hp	Hewlett Packard
 i2se	I2SE GmbH
-- 
2.1.0

