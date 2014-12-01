Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaLADq5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 22:46:57 -0500
Received: from mail-bn1bbn0102.outbound.protection.outlook.com ([157.56.111.102]:22992
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752219AbaLADq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 22:46:56 -0500
X-WSS-ID: 0NFVX62-08-3Q9-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <arnd@arndb.de>, <mark.rutland@arm.com>, <will.deacon@arm.com>,
        <marc.zyngier@arm.com>, <catalin.marinas@arm.com>
CC: <robherring2@gmail.com>, <liviu.dudau@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arm@kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 0/2] arm64: amd-seattle: Misceleneous DT fix up
Date: Sun, 30 Nov 2014 21:46:38 -0600
Message-ID: <1417405600-19232-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(19580405001)(44976005)(50226001)(46102003)(4396001)(101416001)(105586002)(68736004)(19580395003)(87936001)(33646002)(88136002)(92566001)(89996001)(86152002)(92726001)(2201001)(50986999)(229853001)(31966008)(107046002)(95666004)(84676001)(106466001)(21056001)(104166001)(102836001)(97736003)(36756003)(99396003)(53416004)(20776003)(64706001)(47776003)(86362001)(93916002)(87286001)(120916001)(48376002)(50466002)(77096004)(62966003)(77156002);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB205;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-Forefront-PRVS: 0412A98A59
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This patch set mainly fixes up the dma-ranges and pci bus range.
Please see each patch for more details.

Suravee Suthikulpanit (2):
  arm64: amd-seattle: Fix dma-ranges property
  arm64: amd-seattle: Fix PCI bus range due to SMMU limitation

 arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

-- 
1.9.3

