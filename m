Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751173AbaJOFhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 01:37:50 -0400
Received: from mail-bn1bn0105.outbound.protection.outlook.com ([157.56.110.105]:40096
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751041AbaJOFht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 01:37:49 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <thierry.reding@gmail.com>, <linux-pwm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v2 0/3] pwm: ftm: add Power Management support
Date: Wed, 15 Oct 2014 13:21:32 +0800
Message-ID: <1413350495-40980-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(69596002)(6806004)(95666004)(21056001)(68736004)(62966002)(44976005)(50986999)(4396001)(104166001)(81156004)(106466001)(107046002)(102836001)(26826002)(80022003)(105606002)(46102003)(50226001)(97736003)(20776003)(88136002)(92726001)(87936001)(87286001)(99396003)(50466002)(31966008)(89996001)(77156001)(92566001)(84676001)(64706001)(36756003)(47776003)(93916002)(85306004)(76482002)(48376002)(104016003)(86362001)(120916001)(85852003)(229853001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0615;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0615;
X-Forefront-PRVS: 0365C0E14B
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v2:
- Fix one bug.
- Add regmap cache support.
- Remove run time PM for now.

Xiubo Li (3):
  pwm: ftm: fix one bug of wrong counting the use counter.
  pwm: ftm: add regmap rbtree type cache support.
  pwm: ftm: add Power Management support for FTM pwm.

 drivers/pwm/pwm-fsl-ftm.c | 64 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 60 insertions(+), 4 deletions(-)

-- 
2.1.0.27.g96db324

