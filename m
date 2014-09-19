Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbaISNjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 09:39:22 -0400
Received: from mail-db3on0142.outbound.protection.outlook.com ([157.55.234.142]:33566
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755848AbaISNjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 09:39:21 -0400
From: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
To: <shawn.guo@freescale.com>
CC: <stefan@agner.ch>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Subject: [PATCH v2 0/2] Add PWM and backlight support for Colibri VF61 modules
Date: Fri, 19 Sep 2014 19:08:50 +0530
Message-ID: <cover.1411130205.git.bhuvanchandra.dv@toradex.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [115.115.225.206]
X-ClientProxiedBy: DM2PR10CA0043.namprd10.prod.outlook.com (10.141.241.11) To
 AM3PR05MB257.eurprd05.prod.outlook.com (10.242.249.14)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(66066001)(83072002)(50986999)(48376002)(93916002)(69596002)(81342003)(77096002)(77156001)(62966002)(101416001)(88136002)(102836001)(99396002)(36756003)(104166001)(31966008)(19580395003)(50226001)(97736003)(89996001)(46102003)(106356001)(86362001)(2371004)(92566001)(85306004)(74662003)(42186005)(33646002)(87976001)(53416004)(83322001)(21056001)(107046002)(105586002)(85852003)(90102001)(77982003)(2351001)(76482002)(4396001)(229853001)(79102003)(80022003)(47776003)(110136001)(95666004)(87286001)(81156004)(81542003)(92726001)(50466002)(74502003)(20776003)(7059019);DIR:OUT;SFP:1102;SCL:1;SRVR:AM3PR05MB257;H:trdx.toradex.int;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: toradex.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:
[1] Sorted the node names alphabetically.
[2] Updated the node name 'bl: backlight' to 'backlight: bl'.
[3] Dropped the leading space in 'pwm-names' property of backlight.

Bhuvanchandra DV (2):
  ARM: dts: vf610-colibri: Add PWM support
  ARM: dts: vf610-colibri: Add backlight support

 arch/arm/boot/dts/vf610-colibri-eval-v3.dts |   14 ++++++++++++
 arch/arm/boot/dts/vf610-colibri.dtsi        |   33 +++++++++++++++++++++++++--
 2 files changed, 45 insertions(+), 2 deletions(-)

-- 
1.7.9.5

