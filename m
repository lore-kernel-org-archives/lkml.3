Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbbAZQXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:23:18 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:49471 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955AbbAZQXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:23:14 -0500
From: mathieu.poirier@linaro.org
To: gregkh@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] coresight: remove the unnecessary replicator property
Date: Mon, 26 Jan 2015 09:22:18 -0700
Message-Id: <1422289345-2084-3-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422289345-2084-1-git-send-email-mathieu.poirier@linaro.org>
References: <1422289345-2084-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kaixu Xia <xiakaixu@huawei.com>

Now we use the device name to identify replicator instead
of a unique number, so just remove it.

Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 Documentation/devicetree/bindings/arm/coresight.txt | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/coresight.txt b/Documentation/devicetree/bindings/arm/coresight.txt
index d790f49066f3..a3089359aaa6 100644
--- a/Documentation/devicetree/bindings/arm/coresight.txt
+++ b/Documentation/devicetree/bindings/arm/coresight.txt
@@ -38,8 +38,6 @@ its hardware characteristcs.
 	  AMBA markee):
 		- "arm,coresight-replicator"
 
-	* id: a unique number that will identify this replicator.
-
 	* port or ports: same as above.
 
 * Optional properties for ETM/PTMs:
@@ -94,8 +92,6 @@ Example:
 		 * AMBA bus.  As such no need to add "arm,primecell".
 		 */
 		compatible = "arm,coresight-replicator";
-		/* this will show up in debugfs as "0.replicator" */
-		id = <0>;
 
 		ports {
 			#address-cells = <1>;
-- 
1.9.1

