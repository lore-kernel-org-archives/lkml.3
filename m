Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751145AbaFLRkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:40:43 -0400
Received: from mail-by2lp0236.outbound.protection.outlook.com ([207.46.163.236]:55143
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751076AbaFLRkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:40:41 -0400
X-WSS-ID: 0N72H3L-08-N29-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <tj@kernel.org>, <b.zolnierkie@samsung.com>
CC: <hdegoede@redhat.com>, <lho@apm.com>, <tphan@apm.com>, <stripathi@apm.com>,
        <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 0/2] ahci: Add support for 64-bit DMA mask driver
Date: Thu, 12 Jun 2014 12:40:22 -0500
Message-ID: <1402594824-4151-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428001)(189002)(199002)(101416001)(74502001)(74662001)(80022001)(33646001)(46102001)(68736004)(4396001)(89996001)(19580395003)(83322001)(64706001)(77156001)(19580405001)(104166001)(97736001)(93916002)(50466002)(102836001)(86362001)(99396002)(62966002)(50986999)(92726001)(86152002)(88136002)(84676001)(81542001)(81342001)(50226001)(87936001)(76482001)(87286001)(36756003)(85852003)(83072002)(20776003)(48376002)(44976005)(79102001)(77982001)(53416003)(47776003);DIR:OUT;SFP:;SCL:1;SRVR:CY1PR0201MB0825;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 02408926C4
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

V2:
	- Changes based on review comments from Hans and Bartlomiej.
	- Remove the logic in ahci_xgene as suggested by Bartlomiej.

Suravee Suthikulpanit (2):
  ata: Check and set 64-bit DMA mask for platform AHCI driver
  ahci/xgene: Remove logic to set 64-bit DMA mask

 drivers/ata/ahci_xgene.c       | 10 ----------
 drivers/ata/libahci_platform.c | 13 +++++++++++++
 2 files changed, 13 insertions(+), 10 deletions(-)

-- 
1.9.0

