Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbbALJgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:36:37 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:6730 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbbALJgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:36:36 -0500
From: Kaixu Xia <xiakaixu@huawei.com>
To: <mathieu.poirier@linaro.org>
CC: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <xiakaixu@huawei.com>,
        <kaixu.xia@linaro.org>
Subject: [PATCH] coresight: remove the unnecessary replicator property
Date: Mon, 12 Jan 2015 17:29:54 +0800
Message-ID: <1421054994-64261-1-git-send-email-xiakaixu@huawei.com>
X-Mailer: git-send-email 1.8.5.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we use the device name to identify replicator instead
of a unique number, so just remove it.

Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
---
 Documentation/devicetree/bindings/arm/coresight.txt | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/coresight.txt b/Documentation/devicetree/bindings/arm/coresight.txt
index d790f49..a308935 100644
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
1.8.5.5

