Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab3HMHTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 03:19:19 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14078 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab3HMHTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 03:19:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 13 Aug 2013 00:19:16 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@kernel.org>, <sameo@linux.intel.com>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <rob@landley.net>, <lee.jones@linaro.org>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gg@slimlogic.co.uk>, <kishon@ti.com>,
        <j-keerthy@ti.com>, <ian.campbell@citrix.com>, <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/3] regulator: palmas: Update the DT binding doc for smps10 out1 and out2
Date: Tue, 13 Aug 2013 13:03:43 +0530
Message-ID: <1376379225-10604-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1376379225-10604-1-git-send-email-ldewangan@nvidia.com>
References: <1376379225-10604-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Palams regulator SMPS10 is splitted into two regulator SMPS10-OUT1 and
SMPS10-OUT2 to match with hw behavior. With this regulator name got
changed in driver.

Update the DT binding document to match with driver.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 .../devicetree/bindings/regulator/palmas-pmic.txt  |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
index 30b0581..794d13d 100644
--- a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
+++ b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
@@ -25,8 +25,8 @@ Optional nodes:
 	       Additional custom properties  are listed below.
 
 	       For ti,palmas-pmic - smps12, smps123, smps3 depending on OTP,
-	       smps45, smps457, smps7 depending on variant, smps6, smps[8-10],
-	       ldo[1-9], ldoln, ldousb.
+	       smps45, smps457, smps7 depending on variant, smps6, smps[8-9],
+	       mps10_out2, smps10_out1, do[1-9], ldoln, ldousb.
 
 	       Optional sub-node properties:
 	       ti,warm-reset - maintain voltage during warm reset(boolean)
-- 
1.7.1.1

