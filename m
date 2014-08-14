Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbaHNKwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 06:52:53 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:46675
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752916AbaHNKwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 06:52:50 -0400
From: Cristian Stoica <cristian.stoica@freescale.com>
To: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>
Subject: caamhash.c fixes
Date: Thu, 14 Aug 2014 13:51:55 +0300
Message-ID: <1408013517-15526-1-git-send-email-cristian.stoica@freescale.com>
X-Mailer: git-send-email 1.8.3.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(95666004)(36756003)(21056001)(44976005)(48376002)(86362001)(62966002)(81542001)(80022001)(20776003)(64706001)(81156004)(81342001)(99396002)(47776003)(93916002)(33646002)(83322001)(105606002)(87936001)(79102001)(77156001)(92566001)(77982001)(50466002)(74502001)(97736001)(85306004)(104166001)(84676001)(26826002)(83072002)(92726001)(74662001)(107046002)(88136002)(558084003)(229853001)(89996001)(50226001)(50986999)(87286001)(104016003)(106466001)(6806004)(102836001)(76482001)(46102001)(69596002)(31966008)(68736004)(85852003)(4396001)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB400;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 03030B9493
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=cristian.stoica@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a set of two independent fixes for caamhash driver


drivers/crypto/caam/caamhash.c   | 28 +++++++++++++++++-----------
drivers/crypto/caam/sg_sw_sec4.h | 54 ------------------------------------------------------
2 files changed, 17 insertions(+), 65 deletions(-)

