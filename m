Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbaIVKIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 06:08:45 -0400
Received: from mail-db3on0129.outbound.protection.outlook.com ([157.55.234.129]:22656
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750961AbaIVKIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 06:08:44 -0400
From: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
To: <shawn.guo@freescale.com>
CC: <stefan@agner.ch>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Subject: [PATCH v3 0/2] Add PWM and backlight support for Colibri VF61 modules
Date: Mon, 22 Sep 2014 15:38:10 +0530
Message-ID: <cover.1411378369.git.bhuvanchandra.dv@toradex.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [115.115.225.206]
X-ClientProxiedBy: DM2PR10CA0060.namprd10.prod.outlook.com (10.141.241.28) To
 AMSPR05MB262.eurprd05.prod.outlook.com (10.242.95.19)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:AMSPR05MB262;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(102836001)(229853001)(2351001)(89996001)(95666004)(42186005)(90102001)(33646002)(101416001)(20776003)(92726001)(92566001)(107046002)(105586002)(21056001)(81156004)(97736003)(104166001)(62966002)(120916001)(76482002)(50226001)(4396001)(106356001)(53416004)(36756003)(64706001)(88136002)(80022003)(79102003)(77096002)(74502003)(74662003)(46102003)(99396002)(50986999)(83072002)(50466002)(81542003)(81342003)(110136001)(77982003)(77156001)(48376002)(66066001)(86362001)(2371004)(87976001)(85852003)(31966008)(47776003)(93916002)(19580395003)(87286001)(85306004)(83322001)(69596002)(7059019);DIR:OUT;SFP:1102;SCL:1;SRVR:AMSPR05MB262;H:trdx.toradex.int;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: toradex.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v2:
[1] Droped the changes done in the root node.
[2] Fix typo in backlight node.

Bhuvanchandra DV (2):
  ARM: dts: vf610-colibri: Add PWM support
  ARM: dts: vf610-colibri: Add backlight support

 arch/arm/boot/dts/vf610-colibri-eval-v3.dts |   14 +++++++++++++
 arch/arm/boot/dts/vf610-colibri.dtsi        |   29 +++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

-- 
1.7.9.5

