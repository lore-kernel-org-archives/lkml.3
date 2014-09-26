Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbaIZLkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:40:21 -0400
Received: from mail-bn1on0141.outbound.protection.outlook.com ([157.56.110.141]:12640
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753453AbaIZLkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:40:19 -0400
From: Chenhui Zhao <chenhui.zhao@freescale.com>
To: <linux-kernel@vger.kernel.org>, <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
CC: <leoli@freescale.com>, <Jason.Jin@freescale.com>,
        <Zhuoyu.Zhang@freescale.com>
Subject: [PATCH 0/3] arm: ls1: add deep sleep support
Date: Fri, 26 Sep 2014 19:25:00 +0800
Message-ID: <1411730703-25836-1-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.7.3
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(74662003)(89996001)(92566001)(77982003)(50466002)(62966002)(97736003)(95666004)(2201001)(77156001)(74502003)(93916002)(83322001)(21056001)(79102003)(85852003)(80022003)(86362001)(87936001)(64706001)(83072002)(229853001)(92726001)(81542003)(558084003)(20776003)(47776003)(107046002)(4396001)(48376002)(31966008)(104016003)(50226001)(90102001)(102836001)(46102003)(87286001)(85306004)(106466001)(33646002)(36756003)(50986999)(6806004)(10300001)(81342003)(84676001)(120916001)(105606002)(88136002)(44976005)(68736004)(99396003)(104166001)(76482002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB376;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB376;
X-Forefront-PRVS: 03468CBA43
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=chenhui.zhao@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are for supporting deep sleep on LS1.
They are based on the platform patches for LS1.
