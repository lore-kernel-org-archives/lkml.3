Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbaIXU3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:29:22 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:11132 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751182AbaIXU3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:29:21 -0400
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Rob Herring <robh+dt@kernel.org>, Grant Likely <grant.likely@linaro.org>
CC: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] dt/bindings: include binding header files path in guidelines
Date: Wed, 24 Sep 2014 13:29:31 -0700
Message-ID: <1411590571-30120-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include the dt bindings include path in the submitting patches
guidelines for completeness.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 .../devicetree/bindings/submitting-patches.txt     |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/submitting-patches.txt b/Documentation/devicetree/bindings/submitting-patches.txt
index 042a027..68f11d9 100644
--- a/Documentation/devicetree/bindings/submitting-patches.txt
+++ b/Documentation/devicetree/bindings/submitting-patches.txt
@@ -6,7 +6,8 @@ I. For patch submitters
   0) Normal patch submission rules from Documentation/SubmittingPatches
      applies.
 
-  1) The Documentation/ portion of the patch should be a separate patch.
+  1) The Documentation/ and include/dt-bindings/ portion of the patch should be
+     a separate patch.
 
   2) Submit the entire series to the devicetree mailinglist at
 
-- 
1.7.9.5

