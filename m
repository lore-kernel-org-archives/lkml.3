Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268AbaKGBjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 20:39:16 -0500
Received: from mail-bn1bbn0106.outbound.protection.outlook.com ([157.56.111.106]:16075
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751051AbaKGBjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 20:39:14 -0500
X-WSS-ID: 0NENB9A-07-OYC-02
X-M-MSG: 
From: <sherry.hurwitz@amd.com>
To: <linux-firmware@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <suravee.suthikulpanit@amd.com>,
        "Sherry Hurwitz" <sherry.hurwitz@amd.com>
Subject: [RESEND PATCH 0/1] linux-firmware: Update AMD microcode patch firmware files
Date: Thu, 6 Nov 2014 19:38:25 -0600
Message-ID: <1415324306-5377-1-git-send-email-sherry.hurwitz@amd.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(86362001)(86152002)(92726001)(46102003)(104166001)(110136001)(87286001)(105586002)(89996001)(36756003)(64706001)(88136002)(87936001)(84676001)(99396003)(62966003)(77096003)(50466002)(48376002)(20776003)(47776003)(101416001)(50986999)(19580395003)(44976005)(68736004)(107046002)(95666004)(53416004)(21056001)(92566001)(31966008)(50226001)(33646002)(120916001)(106466001)(2351001)(77156002)(102836001)(229853001)(19580405001)(97736003)(4396001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB208;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03883BD916
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=sherry.hurwitz@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sherry Hurwitz <sherry.hurwitz@amd.com>

NOTE: I am resending this patch to the correct alias.

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

