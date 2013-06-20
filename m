Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965528Ab3FTMFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:05:04 -0400
Received: from multi.imgtec.com ([194.200.65.239]:27107 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965178Ab3FTMDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:03:21 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: [PATCH 2/7] metag: *.dts: include using preprocessor
Date: Thu, 20 Jun 2013 13:02:33 +0100
Message-ID: <1371729758-10196-3-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371729758-10196-1-git-send-email-james.hogan@imgtec.com>
References: <1371729758-10196-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_20_13_03_19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include *.dtsi files from *.dts using the preprocessor to set a good
example for future device tree files. Files included in the old way
don't get pre-processed.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: devicetree-discuss@lists.ozlabs.org
---
 arch/metag/boot/dts/skeleton.dts       | 2 +-
 arch/metag/boot/dts/tz1090.dtsi        | 2 +-
 arch/metag/boot/dts/tz1090_generic.dts | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/metag/boot/dts/skeleton.dts b/arch/metag/boot/dts/skeleton.dts
index 7244d1f..7a49aeb 100644
--- a/arch/metag/boot/dts/skeleton.dts
+++ b/arch/metag/boot/dts/skeleton.dts
@@ -7,4 +7,4 @@
  */
 /dts-v1/;
 
-/include/ "skeleton.dtsi"
+#include "skeleton.dtsi"
diff --git a/arch/metag/boot/dts/tz1090.dtsi b/arch/metag/boot/dts/tz1090.dtsi
index ca057f0..ff7bb74 100644
--- a/arch/metag/boot/dts/tz1090.dtsi
+++ b/arch/metag/boot/dts/tz1090.dtsi
@@ -6,7 +6,7 @@
  * published by the Free Software Foundation.
  */
 
-/include/ "skeleton.dtsi"
+#include "skeleton.dtsi"
 
 / {
 	compatible = "toumaz,tz1090", "img,meta";
diff --git a/arch/metag/boot/dts/tz1090_generic.dts b/arch/metag/boot/dts/tz1090_generic.dts
index aa826cb..f960909 100644
--- a/arch/metag/boot/dts/tz1090_generic.dts
+++ b/arch/metag/boot/dts/tz1090_generic.dts
@@ -7,4 +7,4 @@
  */
 /dts-v1/;
 
-/include/ "tz1090.dtsi"
+#include "tz1090.dtsi"
-- 
1.8.1.2


