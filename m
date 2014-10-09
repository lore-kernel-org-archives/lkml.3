Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaJISTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 14:19:05 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:54194 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaJISTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 14:19:02 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Rutland <mark.rutland@arm.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 1/1] Documentation: dt-bindings: Explain order in patch series
Date: Thu,  9 Oct 2014 20:18:27 +0200
Message-Id: <1412878707-23754-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When posting a patch series that includes both code implementing a
Device Tree binding and its associated documentation, the DT docs
should come in the series before the implementation.

This not only avoids checkpatch.pl to complain about undocumented
bindings but also makes the review process easier.

Document this convention since it may not be obvious.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 Documentation/devicetree/bindings/submitting-patches.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/submitting-patches.txt b/Documentation/devicetree/bindings/submitting-patches.txt
index 042a027..e3bd2bb 100644
--- a/Documentation/devicetree/bindings/submitting-patches.txt
+++ b/Documentation/devicetree/bindings/submitting-patches.txt
@@ -12,6 +12,9 @@ I. For patch submitters
 
        devicetree@vger.kernel.org
 
+ 3) The Documentation/ portion of the patch should come in the series before
+    the code implementing the binding.
+
 II. For kernel maintainers
 
   1) If you aren't comfortable reviewing a given binding, reply to it and ask
-- 
2.1.0

