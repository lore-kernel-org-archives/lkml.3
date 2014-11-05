Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbaKEKW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:22:26 -0500
Received: from mail-am1on0133.outbound.protection.outlook.com ([157.56.112.133]:44640
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754389AbaKEKWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:22:24 -0500
From: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
To: <shawn.guo@freescale.com>
CC: <stefan@agner.ch>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Subject: [PATCH V2 0/2] Add I2C and enable M41T0M6 RTC
Date: Wed, 5 Nov 2014 15:35:06 +0530
Message-ID: <cover.1415181422.git.bhuvanchandra.dv@toradex.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [115.115.225.206]
X-ClientProxiedBy: HKXPR03CA0022.apcprd03.prod.outlook.com (10.141.129.12) To
 DB3PR05MB266.eurprd05.prod.outlook.com (10.141.4.23)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DB3PR05MB266;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(88136002)(2371004)(93916002)(86362001)(575784001)(97736003)(69596002)(19580395003)(50226001)(4396001)(31966008)(122386002)(50466002)(48376002)(21056001)(92566001)(46102003)(36756003)(107046002)(40100003)(62966003)(77096003)(77156002)(42186005)(102836001)(105586002)(104166001)(95666004)(81156004)(229853001)(53416004)(106356001)(101416001)(558084003)(92726001)(89996001)(87286001)(2351001)(50986999)(87976001)(64706001)(47776003)(66066001)(120916001)(110136001)(99396003)(20776003)(33646002)(7059028);DIR:OUT;SFP:1102;SCL:1;SRVR:DB3PR05MB266;H:trdx.toradex.int;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: toradex.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Bhuvanchandra DV (2):
  ARM: dts: vf-colibri: Add I2C support
  ARM: dts: vf-colibri-eval-v3.dts: Enable ST-M41T0M6 RTC

 arch/arm/boot/dts/vf-colibri-eval-v3.dtsi |   12 +++++++++++-
 arch/arm/boot/dts/vf-colibri.dtsi         |   13 +++++++++++++
 2 files changed, 24 insertions(+), 1 deletion(-)

-- 
1.7.9.5

