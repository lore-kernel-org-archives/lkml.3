Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbaFXOQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:16:24 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:36665
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753680AbaFXOQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:16:23 -0400
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <iommu@lists.linux-foundation.org>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alex.williamson@redhat.com>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 0/3] iommu/fsl: Fixes for the PAMU driver. 
Date: Tue, 24 Jun 2014 19:27:14 +0530
Message-ID: <1403618237-26248-1-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(68736004)(93916002)(97736001)(86362001)(48376002)(77982001)(79102001)(50986999)(44976005)(46102001)(83322001)(6806004)(31966008)(74502001)(74662001)(50466002)(76482001)(84676001)(77156001)(64706001)(105606002)(83072002)(21056001)(26826002)(47776003)(20776003)(4396001)(89996001)(92566001)(2201001)(80022001)(85852003)(104166001)(102836001)(50226001)(95666004)(85306003)(104016002)(81342001)(87936001)(87286001)(62966002)(99396002)(81542001)(106466001)(88136002)(92726001)(36756003)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB470;H:tx30smr01.am.freescale.net;FPR:;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02524402D6
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Varun.Sethi@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set contains fixes for the PAMU driver. 
The patches are based on 3.16-rc1.

Varun Sethi (3):
  Fix PAMU window size check. 
  Fix the device domain attach condition.
  Fix the error condition during iommu group creation.

 drivers/iommu/fsl_pamu.c        |    8 ++++----
 drivers/iommu/fsl_pamu_domain.c |   19 +++++++++----------
 2 files changed, 13 insertions(+), 14 deletions(-)

-- 
1.7.9.5

