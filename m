Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbaJIJDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 05:03:47 -0400
Received: from mail-bl2on0144.outbound.protection.outlook.com ([65.55.169.144]:16128
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755377AbaJIJDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 05:03:33 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <dp@opensource.wolfsonmicro.com>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 0/6] regmap: cache: cleanup and fix bugs.
Date: Thu, 9 Oct 2014 17:02:51 +0800
Message-ID: <1412845377-17134-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(31966008)(50226001)(4396001)(47776003)(20776003)(64706001)(97736003)(50466002)(48376002)(93916002)(86362001)(92566001)(26826002)(102836001)(92726001)(85306004)(50986999)(95666004)(84676001)(105606002)(2351001)(107046002)(229853001)(106466001)(81156004)(110136001)(104166001)(104016003)(120916001)(99396003)(89996001)(87936001)(88136002)(85852003)(87286001)(76482002)(46102003)(80022003)(6806004)(44976005)(69596002)(68736004)(21056001)(62966002)(77156001)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0617;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0617;
X-Forefront-PRVS: 0359162B6D
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0873;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Xiubo Li (6):
  regmap: cache: Sort include headers alphabetically
  regmap: cache: cleanup regcache_hw_init().
  regmap: cache: fix errno in regcache_hw_init()
  regmap: cache: speed regcache_hw_init() up.
  regmap: cache: use kmalloc_array instead of kmalloc
  regmap: cache: Fix possible ZERO_SIZE_PTR pointer dereferencing error.

 drivers/base/regmap/regcache-flat.c   |  2 +-
 drivers/base/regmap/regcache-lzo.c    |  2 +-
 drivers/base/regmap/regcache-rbtree.c |  4 +--
 drivers/base/regmap/regcache.c        | 63 +++++++++++++++++++----------------
 4 files changed, 38 insertions(+), 33 deletions(-)

-- 
2.1.0.27.g96db324

