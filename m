Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751055AbaJISYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 14:24:30 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:54201 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaJISYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 14:24:25 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Rutland <mark.rutland@arm.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v2 1/1] Documentation: dt-bindings: Explain order in patch series
Date: Thu,  9 Oct 2014 20:24:07 +0200
Message-Id: <1412879047-24138-1-git-send-email-javier.martinez@collabora.co.uk>
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

Changes since v1:
 - Small typo error, sorry for the noise.

 Documentation/devicetree/bindings/submitting-patches.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/submitting-patches.txt b/Documentation/devicetree/bindings/submitting-patches.txt
index 042a027..b7ba01a 100644
--- a/Documentation/devicetree/bindings/submitting-patches.txt
+++ b/Documentation/devicetree/bindings/submitting-patches.txt
@@ -12,6 +12,9 @@ I. For patch submitters
 
        devicetree@vger.kernel.org
 
+  3) The Documentation/ portion of the patch should come in the series before
+     the code implementing the binding.
+
 II. For kernel maintainers
 
   1) If you aren't comfortable reviewing a given binding, reply to it and ask
-- 
2.1.0

