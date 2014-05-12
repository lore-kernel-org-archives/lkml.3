Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaELDVa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 23:21:30 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:53399
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750822AbaELDV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 23:21:29 -0400
From: Richard Lee <superlibj8301@gmail.com>
To: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
CC: Richard Lee <superlibj8301@gmail.com>
Subject: [RFC][PATCH 0/2] Add IO mapping space reused support
Date: Mon, 12 May 2014 10:19:53 +0800
Message-ID: <1399861195-21087-1-git-send-email-superlibj8301@gmail.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130443375711064779;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(199002)(189002)(77156001)(74502001)(55446002)(4396001)(50466002)(33646001)(79102001)(74662001)(61266001)(82202001)(50226001)(73972005)(47776003)(64706001)(36756003)(97736001)(20776003)(80022001)(92566001)(31966008)(62966002)(84676001)(92726001)(73392001)(85852003)(83072002)(87572001)(2201001)(99396002)(46102001)(93916002)(86362001)(2009001)(6806004)(44976005)(87792001)(21056001)(48376002)(68736004)(69596002)(88136002)(89996001)(81442001)(77982001)(81342001)(50986999)(87936001)(81156002)(77096999)(87286001)(81542001)(57042002)(46252002)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB409;H:az84smr01.freescale.net;FPR:;MLV:nov;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0209425D0A
Authentication-Results: spf=softfail (sender IP is 192.88.158.2)
 smtp.mailfrom=superlibj8301@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Richard Lee (2):
  mm/vmalloc: Add IO mapping space reused interface.
  ARM: ioremap: Add IO mapping space reused support.

 arch/arm/mm/ioremap.c   | 11 ++++++++-
 include/linux/vmalloc.h |  5 ++++
 mm/vmalloc.c            | 63 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 78 insertions(+), 1 deletion(-)

-- 
1.8.4

