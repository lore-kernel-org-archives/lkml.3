Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbaKGBj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 20:39:29 -0500
Received: from mail-bn1bbn0104.outbound.protection.outlook.com ([157.56.111.104]:23470
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751051AbaKGBjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 20:39:17 -0500
X-WSS-ID: 0NENB9B-07-OYD-02
X-M-MSG: 
From: <sherry.hurwitz@amd.com>
To: <linux-firmware@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <suravee.suthikulpanit@amd.com>,
        "Sherry Hurwitz" <sherry.hurwitz@amd.com>
Subject: [RESEND PATCH 1/1] linux-firmware: Update AMD microcode patch firmware files
Date: Thu, 6 Nov 2014 19:38:26 -0600
Message-ID: <1415324306-5377-2-git-send-email-sherry.hurwitz@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415324306-5377-1-git-send-email-sherry.hurwitz@amd.com>
References: <1415324306-5377-1-git-send-email-sherry.hurwitz@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(377424004)(86362001)(86152002)(92726001)(46102003)(104166001)(110136001)(87286001)(105586002)(89996001)(36756003)(64706001)(88136002)(87936001)(84676001)(99396003)(62966003)(77096003)(50466002)(575784001)(48376002)(20776003)(47776003)(76176999)(101416001)(50986999)(19580395003)(44976005)(68736004)(107046002)(95666004)(53416004)(21056001)(92566001)(31966008)(50226001)(33646002)(120916001)(106466001)(2351001)(77156002)(102836001)(229853001)(19580405001)(97736003)(4396001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB208;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
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

For AMD Family 15h Processors
file:   amd-ucode/microcode_amd_family15h.bin
md5sum: ee3f0f46936aa1788dc31ca3487e0ff3

For AMD Family 16h Processors
file:   amd-ucode/microcode_amd_family16h.bin
md5sum: 6a47a6393c52ddfc0b5b044efc076a77

Version: 2014_10_28
Signed-off-by: Sherry Hurwitz <sherry.hurwitz@amd.com>
---
 LICENSE.amd-ucode                      |   2 +-
 WHENCE                                 |   4 +++-
 amd-ucode/microcode_amd_fam15h.bin     | Bin 7876 -> 7876 bytes
 amd-ucode/microcode_amd_fam15h.bin.asc |  16 ++++++++--------
 amd-ucode/microcode_amd_fam16h.bin     | Bin 0 -> 3510 bytes
 amd-ucode/microcode_amd_fam16h.bin.asc |  11 +++++++++++
 6 files changed, 23 insertions(+), 10 deletions(-)
 create mode 100644 amd-ucode/microcode_amd_fam16h.bin
 create mode 100644 amd-ucode/microcode_amd_fam16h.bin.asc

diff --git a/LICENSE.amd-ucode b/LICENSE.amd-ucode
index 9d4c425..2cf8590 100644
--- a/LICENSE.amd-ucode
+++ b/LICENSE.amd-ucode
@@ -1,4 +1,4 @@
-Copyright (C) 2010-2013 Advanced Micro Devices, Inc., All rights reserved.
+Copyright (C) 2010-2014 Advanced Micro Devices, Inc., All rights reserved.
 
 Permission is hereby granted by Advanced Micro Devices, Inc. ("AMD"),
 free of any license fees, to any person obtaining a copy of this
diff --git a/WHENCE b/WHENCE
index b77516d..c7ce58d 100644
--- a/WHENCE
+++ b/WHENCE
@@ -2470,7 +2470,9 @@ Driver: microcode_amd - AMD CPU Microcode Update Driver for Linux
 File: amd-ucode/microcode_amd.bin
 Version: 2013-07-10
 File: amd-ucode/microcode_amd_fam15h.bin
-Version: 2013-07-10
+Version: 2014-10-28
+File: amd-ucode/microcode_amd_fam16h.bin
+Version: 2014-10-28
 
 License: Redistributable. See LICENSE.amd-ucode for details
 
diff --git a/amd-ucode/microcode_amd_fam15h.bin b/amd-ucode/microcode_amd_fam15h.bin
index 08a2f7ce5a9c53e35a1bdd4b2e59cf581639b2f0..ec48ec0a18134832d70a4cd8cbf744bfe0ae1bd3 100644
GIT binary patch
delta 2603
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
ND5M%y)w7%wC<>q00PO$(

delta 2603
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
N)z^_;3A3COC<-V^14;k@

diff --git a/amd-ucode/microcode_amd_fam15h.bin.asc b/amd-ucode/microcode_amd_fam15h.bin.asc
index 6125d0d..3bc803f 100644
--- a/amd-ucode/microcode_amd_fam15h.bin.asc
+++ b/amd-ucode/microcode_amd_fam15h.bin.asc
@@ -1,11 +1,11 @@
 -----BEGIN PGP SIGNATURE-----
-Version: GnuPG v1.4.11 (GNU/Linux)
+Version: GnuPG v1
 
-iQEcBAABAgAGBQJR3dkfAAoJEKXo28mMAQi0iTsIAJ5nCgz/+jFYag2W/OH+kOQe
-BDXYSC5diXQR5wF/HUkXWh0sl+jNK/OrRVxT7sFaEgAUhEXhK6Df/h7qnJAYQGFr
-5+CKhfSr/0Qbk1ziWYAXVKMOXbuLWSSIov1SCcwLsps7A7puITK6xDemLby7KDGC
-xCUfKIM/BO6DyFpNhKQ+xJdDi+yVxUKQhbdk/8gY94VdUnVZq3CTK9UStpBuaXu0
-qJNfhbaU+OzgZmnmLq5+xGsCML1xfbgF6sexVRx7oT/Jv30tm97YQJWR0h4DU7jU
-zjID8kGtYRVV7+i8jC+jVpFo21yDVUkHUcqtNXXRB/lbOYFAm+UJviAEc4NEdSw=
-=JaWY
+iQEcBAABAgAGBQJUTqLvAAoJEOS+UznzKK5zyaIIAKZcXmU+sBO4YGH5Aq2SdRYe
+rlwE5oeYNh+AdzzLm9EqHwSC+MciFI7HqQz8PvKAsfaoD17mQjonIXga8l2/w3OW
+/vIJjJnu9QB2C9XpjAiQCxS5QaMtIfEEjVld+MeHs6Ld3PwGuAXCkxKcJ2sHLZd3
+UcwwHxcm98KYouogjVZoJeb226cjz6fzUVJK9t9yi2S+SWmIvkjSZEI6W0WFoFCL
+x0jM7lFNcusGtg5K6UsyAdwPwvfbBN5FoV29/DaP+/HA4GP/W/cgbQxS72skDJg5
+c/icP0ntAND2iprtTQXF9//mWdX2FLYD55eu+pShZmO8t4Qvq4tJgiVz3hJiK+U=
+=KBP3
 -----END PGP SIGNATURE-----
diff --git a/amd-ucode/microcode_amd_fam16h.bin b/amd-ucode/microcode_amd_fam16h.bin
new file mode 100644
index 0000000000000000000000000000000000000000..b339424d3bdd7812f6b48116c0ebaf07d9e1e955
GIT binary patch
literal 3510
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

literal 0
HcmV?d00001

diff --git a/amd-ucode/microcode_amd_fam16h.bin.asc b/amd-ucode/microcode_amd_fam16h.bin.asc
new file mode 100644
index 0000000..b9bff2c
--- /dev/null
+++ b/amd-ucode/microcode_amd_fam16h.bin.asc
@@ -0,0 +1,11 @@
+-----BEGIN PGP SIGNATURE-----
+Version: GnuPG v1
+
+iQEcBAABAgAGBQJUTtyFAAoJEOS+UznzKK5z4mwIAKEoRVZfNlqlsD2SR6Sfy3Cw
+8SgsmUk0Wtdt4AmIMn3O4cZ+ONN9knMrJyLcDk+dH2dGsWPutNCE73diC7jP+P2W
+hPy++6o9EBgCVBGxa/9ltuIAsS6N7HXPX2StZHcSaZEy+QWFX9rLmX9YF2lHzhwr
+mbgK9/LLL2mV9BzBeuLAWBpzijIIrYgBfxDQS5gLwyveJMrWFO4WqupXd6XyrFur
+ixe4paWNqHf82Llz7Yy55H8TAlES4eCg/wpxKVFAMDrs25MEXLoIGlAwLoTZBRkQ
+bX+HsHfN3IcOi67UxwbRzTkb+hBvT13yJN4TymKhXstx4A/a3jF2sMlUD4aRs88=
+=YwHU
+-----END PGP SIGNATURE-----
-- 
1.9.1

