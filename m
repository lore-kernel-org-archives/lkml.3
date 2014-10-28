Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbaJ1WVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:21:11 -0400
Received: from mail-bn1bon0130.outbound.protection.outlook.com ([157.56.111.130]:16408
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753918AbaJ1WVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:21:09 -0400
X-WSS-ID: 0NE6D92-08-7OU-02
X-M-MSG: 
From: <sherry.hurwitz@amd.com>
To: David Woodhouse <dwmw2@infradead.org>, Ben Hutchings <ben@decadent.org.uk>
CC: <linux-kernel@vger.kernel.org>, <suravee.suthikulpanit@amd.com>,
        "Sherry Hurwitz" <sherry.hurwitz@amd.com>
Subject: [PATCH 0/1] linux-firmware: Update AMD microcode patch firmware files
Date: Tue, 28 Oct 2014 17:02:50 -0500
Message-ID: <1414533771-11046-1-git-send-email-sherry.hurwitz@amd.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(95666004)(33646002)(105586002)(107046002)(229853001)(85306004)(120916001)(62966002)(77096002)(97736003)(50466002)(104166001)(21056001)(106466001)(99396003)(46102003)(80022003)(92566001)(84676001)(92726001)(77156001)(87286001)(89996001)(20776003)(64706001)(93916002)(86362001)(50986999)(68736004)(31966008)(48376002)(86152002)(85852003)(88136002)(87936001)(19580405001)(76482002)(53416004)(44976005)(19580395003)(47776003)(101416001)(36756003)(102836001)(50226001)(4396001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB194;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB194;
X-Forefront-PRVS: 0378F1E47A
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=sherry.hurwitz@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sherry Hurwitz <sherry.hurwitz@amd.com>

This patch provides an updated microcode patch file for AMD family 15h 
processors and adds a microcode patch file for AMD family 16h processors.
The patch files have associated gnupg detached signature files for 
verification of origin.  The AMD Microcode Signing Key can be located at
keyserver hkp://keys.gnupg.net

AMD Microcode Signing Key 
Key ID F328AE73

Sherry Hurwitz (1):
  linux-firmware: Update AMD microcode patch firmware files

 LICENSE.amd-ucode                      |   2 +-
 WHENCE                                 |   4 +++-
 amd-ucode/microcode_amd_fam15h.bin     | Bin 7876 -> 7876 bytes
 amd-ucode/microcode_amd_fam15h.bin.asc |  16 ++++++++--------
 amd-ucode/microcode_amd_fam16h.bin     | Bin 0 -> 3510 bytes
 amd-ucode/microcode_amd_fam16h.bin.asc |  11 +++++++++++
 6 files changed, 23 insertions(+), 10 deletions(-)
 create mode 100644 amd-ucode/microcode_amd_fam16h.bin
 create mode 100644 amd-ucode/microcode_amd_fam16h.bin.asc

-- 
1.9.1

