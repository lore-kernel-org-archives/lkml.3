Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbaIQIc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:32:28 -0400
Received: from mail-db3on0135.outbound.protection.outlook.com ([157.55.234.135]:26144
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751854AbaIQIc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:32:26 -0400
X-Greylist: delayed 925 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Sep 2014 04:32:26 EDT
From: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
To: <shawn.guo@freescale.com>
CC: <stefan@agner.ch>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Subject: [PATCH 0/3] Add PWM and backlight support for Colibri VF61 modules
Date: Wed, 17 Sep 2014 13:46:27 +0530
Message-ID: <cover.1410930820.git.bhuvanchandra.dv@toradex.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [115.115.225.206]
X-ClientProxiedBy: BY2PR04CA059.namprd04.prod.outlook.com (10.141.249.177) To
 AMSPR05MB261.eurprd05.prod.outlook.com (10.242.95.18)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0337AFFE9A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(48376002)(93916002)(50986999)(50466002)(64706001)(89996001)(66066001)(83322001)(20776003)(31966008)(62966002)(95666004)(90102001)(92566001)(110136001)(86362001)(47776003)(105586002)(85306004)(83072002)(2351001)(77096002)(81156004)(36756003)(97736003)(87286001)(79102003)(19580395003)(77982003)(106356001)(69596002)(21056001)(33646002)(53416004)(74662003)(107046002)(102836001)(101416001)(4396001)(77156001)(88136002)(87976001)(50226001)(229853001)(81342003)(42186005)(85852003)(99396002)(92726001)(76482002)(2371004)(74502003)(46102003)(81542003)(104166001)(80022003)(7059017);DIR:OUT;SFP:1102;SCL:1;SRVR:AMSPR05MB261;H:trdx.toradex.int;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:3;LANG:en;
X-OriginatorOrg: toradex.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabled pwm second instance and backlight control

Bhuvanchandra DV (3):
  ARM: dts: vf610: Add PWM second instance
  ARM: dts: vf610-colibri: Add PWM support
  ARM: dts: vf610-colibri: Add backlight support

 arch/arm/boot/dts/vf610-colibri-eval-v3.dts |   14 ++++++++++++
 arch/arm/boot/dts/vf610-colibri.dtsi        |   32 +++++++++++++++++++++++++++
 arch/arm/boot/dts/vf610.dtsi                |   13 +++++++++++
 3 files changed, 59 insertions(+)

-- 
1.7.9.5

