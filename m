Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbaENJFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:05:49 -0400
Received: from mail-bl2on0131.outbound.protection.outlook.com ([65.55.169.131]:8111
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752779AbaENJFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:05:44 -0400
From: Richard Lee <superlibj8301@gmail.com>
To: <linux-mm@kvack.org>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <arnd@arndb.de>,
        <robherring2@gmail.com>
CC: <lauraa@codeaurora.org>, <akpm@linux-foundation.org>,
        <d.hatayama@jp.fujitsu.com>, <zhangyanfei@cn.fujitsu.com>,
        <liwanp@linux.vnet.ibm.com>, <iamjoonsoo.kim@lge.com>,
        <hannes@cmpxchg.org>, <linux-kernel@vger.kernel.org>,
        Richard Lee <superlibj8301@gmail.com>
Subject: [PATCHv2 0/2] Add IO mapping space reused support
Date: Wed, 14 May 2014 16:18:50 +0800
Message-ID: <1400055532-13134-1-git-send-email-superlibj8301@gmail.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130445319304216014;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(199002)(189002)(81156002)(99396002)(46102001)(2201001)(44976005)(86362001)(80022001)(77096999)(73972005)(88136002)(20776003)(68736004)(93916002)(62966002)(87936001)(47776003)(61266001)(102836001)(87286001)(69596002)(48376002)(89996001)(97736001)(73392001)(92566001)(21056001)(77156001)(84676001)(85852003)(33646001)(4396001)(83072002)(81342001)(81442001)(87572001)(81542001)(87792001)(50986999)(36756003)(77982001)(6806004)(74662001)(55446002)(2009001)(64706001)(50466002)(79102001)(31966008)(74502001)(82202001)(92726001)(50226001)(57042002)(46252002)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB406;H:az84smr01.freescale.net;FPR:;MLV:nov;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0211965D06
Authentication-Results: spf=softfail (sender IP is 192.88.158.2)
 smtp.mailfrom=superlibj8301@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in V2:
 - Uses the atomic_t instead.
 - Revises some comment message.


Richard Lee (2):
  mm/vmalloc: Add IO mapping space reused interface support.
  ARM: ioremap: Add IO mapping space reused support.

 arch/arm/mm/ioremap.c   |  6 ++++
 include/linux/vmalloc.h |  5 +++
 mm/vmalloc.c            | 82 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 93 insertions(+)

-- 
1.8.4

