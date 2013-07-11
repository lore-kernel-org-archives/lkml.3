Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab3GKA72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 20:59:28 -0400
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:43474
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753256Ab3GKA7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 20:59:19 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jul 2013 20:59:19 EDT
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz8d0Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1155h)
X-WSS-ID: 0MPQXZI-02-E6E-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <ben@decadent.org.uk>, <dwmw2@infradead.org>, <sherry.hurwitz@amd.com>
CC: <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 1/1 V2] linux-firmware: Add AMD microcode patch firmware files
Date: Wed, 10 Jul 2013 19:42:56 -0500
Message-ID: <1373503376-5841-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

For AMD Families 10h ~ 14h Processors
file:   amd-ucode/microcode_amd.bin
md5sum: 55ae79b82cbfddcf7142058be3c9ec2d

For AMD Family 15h Processors
file:   amd-ucode/microcode_amd_fam15h.bin
md5sum: 122ac7e56442c2b7c28eb26978b2d57c

Version: 07_10_2013

Signed-off-by: Sherry Hurwitz <sherry.hurwitz@amd.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

---

Key Name        = AMD Microcode Signing Key (for signing microcode container files only)
Key ID          = 8C0108B4
Key Fingerprint = 916A 7708 23A7 B27A ADE0  1565 A5E8 DBC9 8C01 08B4

GnuPG Signature for file : microcode_amd.bin.asc
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJR3dkLAAoJEKXo28mMAQi0/9cIAKraXlbchZkkIPzyMrZBZZJe
zapMterpLdDYL6zukfqgF7Frg94+ilGPK9yKAFsvC+EJyHrF5lbRQ/JthANdRv+Y
8sBKz5/knVI72WdjSjg+473I1rFdIUK+YN7Ygp6eAwP3fg/IQ9UD9iQfWKbbUnx0
WSEMCZm/izsyU2LQMJvtizJ2gz9ktFoALUtTvj0bv34CKr++qqngEVFy/WKQdR6x
R3l5MjFAhvzO0O9gV59s1tXbPU56HRhMbvSBn3NIVZu17pwAFySHwQLAeW10GH0j
UfgpKQppbz90iLLaSh8vseTOoTBn5SegDtK0JEJNMOuK1VoZ+kgv0cqGCs17HBQ=
=FnHv
-----END PGP SIGNATURE-----

GnuPG Signature for file : microcode_amd_fam15h.bin.asc
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJR3dkfAAoJEKXo28mMAQi0iTsIAJ5nCgz/+jFYag2W/OH+kOQe
BDXYSC5diXQR5wF/HUkXWh0sl+jNK/OrRVxT7sFaEgAUhEXhK6Df/h7qnJAYQGFr
5+CKhfSr/0Qbk1ziWYAXVKMOXbuLWSSIov1SCcwLsps7A7puITK6xDemLby7KDGC
xCUfKIM/BO6DyFpNhKQ+xJdDi+yVxUKQhbdk/8gY94VdUnVZq3CTK9UStpBuaXu0
qJNfhbaU+OzgZmnmLq5+xGsCML1xfbgF6sexVRx7oT/Jv30tm97YQJWR0h4DU7jU
zjID8kGtYRVV7+i8jC+jVpFo21yDVUkHUcqtNXXRB/lbOYFAm+UJviAEc4NEdSw=
=JaWY
-----END PGP SIGNATURE-----

 LICENSE.amd-ucode                  |   64 ++++++++++++++++++++++++++++++++++++
 WHENCE                             |    9 +++++
 amd-ucode/microcode_amd.bin        |  Bin 0 -> 12684 bytes
 amd-ucode/microcode_amd_fam15h.bin |  Bin 0 -> 7876 bytes
 4 files changed, 73 insertions(+)
 create mode 100644 LICENSE.amd-ucode
 create mode 100644 amd-ucode/microcode_amd.bin
 create mode 100644 amd-ucode/microcode_amd_fam15h.bin

diff --git a/LICENSE.amd-ucode b/LICENSE.amd-ucode
new file mode 100644
index 0000000..9d4c425
--- /dev/null
+++ b/LICENSE.amd-ucode
@@ -0,0 +1,64 @@
+Copyright (C) 2010-2013 Advanced Micro Devices, Inc., All rights reserved.
+
+Permission is hereby granted by Advanced Micro Devices, Inc. ("AMD"),
+free of any license fees, to any person obtaining a copy of this
+microcode in binary form (the "Software") ("You"), to install,
+reproduce, copy and distribute copies of the Software and to permit
+persons to whom the Software is provided to do the same, subject to
+the following terms and conditions.  Your use of any portion of the
+Software shall constitute Your acceptance of the following terms and
+conditions. If You do not agree to the following terms and conditions,
+do not use, retain or redistribute any portion of the Software.
+
+If You redistribute this Software, You must reproduce the above
+copyright notice and this license with the Software.
+Without specific, prior, written permission from AMD, You may not
+reference AMD or AMD products in the promotion of any product derived
+from or incorporating this Software in any manner that implies that
+AMD endorses or has certified such product derived from or
+incorporating this Software.
+
+You may not reverse engineer, decompile, or disassemble this Software
+or any portion thereof.
+
+THE SOFTWARE IS PROVIDED "AS IS" WITHOUT ANY EXPRESS OR IMPLIED
+WARRANTY OF ANY KIND, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
+MERCHANTABILITY, NONINFRINGEMENT, TITLE, FITNESS FOR ANY PARTICULAR
+PURPOSE, OR WARRANTIES ARISING FROM CONDUCT, COURSE OF DEALING, OR
+USAGE OF TRADE. IN NO EVENT SHALL AMD OR ITS LICENSORS BE LIABLE FOR
+ANY DAMAGES WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR
+LOSS OF PROFITS, BUSINESS INTERRUPTION, OR LOSS OF DATA OR
+INFORMATION) ARISING OUT OF AMD'S NEGLIGENCE, GROSS NEGLIGENCE, THE
+USE OF OR INABILITY TO USE THE SOFTWARE, EVEN IF AMD HAS BEEN ADVISED
+OF THE POSSIBILITY OF SUCH DAMAGES. BECAUSE SOME JURISDICTIONS
+PROHIBIT THE EXCLUSION OR LIMITATION OF LIABILITY FOR CONSEQUENTIAL OR
+INCIDENTAL DAMAGES OR THE EXCLUSION OF IMPLIED WARRANTIES, THE ABOVE
+LIMITATION MAY NOT APPLY TO YOU.
+
+Without limiting the foregoing, the Software may implement third party
+technologies for which You must obtain licenses from parties other
+than AMD. You agree that AMD has not obtained or conveyed to You, and
+that You shall be responsible for obtaining the rights to use and/or
+distribute the applicable underlying intellectual property rights
+related to the third party technologies. These third party
+technologies are not licensed hereunder.
+
+If You use the Software (in whole or in part), You shall adhere to all
+applicable U.S., European, and other export laws, including but not
+limited to the U.S. Export Administration Regulations ("EAR"), (15
+C.F.R. Sections 730 through 774), and E.U. Council Regulation (EC) No
+1334/2000 of 22 June 2000. Further, pursuant to Section 740.6  of the
+EAR, You hereby certify that, except pursuant to a license granted by
+the United States Department of Commerce Bureau of Industry and
+Security or as otherwise permitted pursuant to a License Exception
+under the U.S. Export Administration Regulations ("EAR"), You will not
+(1) export, re-export or release to a national of a country in Country
+Groups D:1, E:1 or E:2 any restricted technology, software, or source
+code You receive hereunder, or (2) export to Country Groups D:1, E:1
+or E:2 the direct product of such technology or software, if such
+foreign produced direct product is subject to national security
+controls as identified on the Commerce Control List (currently found
+in Supplement 1 to Part 774 of EAR). For the most current Country
+Group listings, or for additional information about the EAR or Your
+obligations under those regulations, please refer to the U.S. Bureau
+of Industry and Security?s website at ttp://www.bis.doc.gov/.
diff --git a/WHENCE b/WHENCE
index d7fba9d..baf1df9 100644
--- a/WHENCE
+++ b/WHENCE
@@ -2175,3 +2175,12 @@ File: go7007/wis-startrek.fw
 Licence: Redistributable. See LICENCE.go7007_firmware for details
 
 --------------------------------------------------------------------------
+
+Driver: microcode_amd - AMD CPU Microcode Update Driver for Linux
+
+File: amd-ucode/microcode_amd.bin
+File: amd-ucode/microcode_amd_fam15h.bin
+
+License: Redistributable. See LICENSE.amd-ucode for details
+
+--------------------------------------------------------------------------
diff --git a/amd-ucode/microcode_amd.bin b/amd-ucode/microcode_amd.bin
new file mode 100644
index 0000000000000000000000000000000000000000..23c9dd3402636dd1780192515583b39b1d3a977c
GIT binary patch
literal 12684
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
P(Z4pv+NVZg)9-%(Gjb9I

literal 0
HcmV?d00001

diff --git a/amd-ucode/microcode_amd_fam15h.bin b/amd-ucode/microcode_amd_fam15h.bin
new file mode 100644
index 0000000000000000000000000000000000000000..08a2f7ce5a9c53e35a1bdd4b2e59cf581639b2f0
GIT binary patch
literal 7876
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

literal 0
HcmV?d00001

-- 
1.7.10.4


