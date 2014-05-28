Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaE1KVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 06:21:44 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52620 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbaE1KVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 06:21:42 -0400
From: Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>, Keerthy <j-keerthy@ti.com>
Subject: [PATCH 1/9] mfd: Add DT bindings for tps65917 PMIC
Date: Wed, 28 May 2014 15:50:14 +0530
Message-ID: <1401272423-25761-2-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401272423-25761-1-git-send-email-j-keerthy@ti.com>
References: <1401272423-25761-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT bindings for tps65917 PMIC.

Signed-off-by: Keerthy <j-keerthy@ti.com>
---
 Documentation/devicetree/bindings/mfd/palmas.txt |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/palmas.txt b/Documentation/devicetree/bindings/mfd/palmas.txt
index e5f0f83..eda8989 100644
--- a/Documentation/devicetree/bindings/mfd/palmas.txt
+++ b/Documentation/devicetree/bindings/mfd/palmas.txt
@@ -6,6 +6,7 @@ twl6037 (palmas)
 tps65913 (palmas)
 tps65914 (palmas)
 tps659038
+tps65917
 
 Required properties:
 - compatible : Should be from the list
@@ -16,6 +17,7 @@ Required properties:
   ti,tps65914
   ti,tps80036
   ti,tps659038
+  ti,tps65917
 and also the generic series names
   ti,palmas
 - interrupt-controller : palmas has its own internal IRQs
-- 
1.7.9.5

