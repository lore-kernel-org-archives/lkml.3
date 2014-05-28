Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbaE1KVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 06:21:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36108 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbaE1KVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 06:21:44 -0400
From: Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>, Keerthy <j-keerthy@ti.com>
Subject: [PATCH 2/9] regulator: palmas: Add tps65917 compatible string
Date: Wed, 28 May 2014 15:50:15 +0530
Message-ID: <1401272423-25761-3-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401272423-25761-1-git-send-email-j-keerthy@ti.com>
References: <1401272423-25761-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tps65917 compatible string.

Signed-off-by: Keerthy <j-keerthy@ti.com>
---
 .../devicetree/bindings/regulator/palmas-pmic.txt  |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
index 42e6b6b..725393c 100644
--- a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
+++ b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
@@ -7,6 +7,7 @@ Required properties:
   ti,twl6037-pmic
   ti,tps65913-pmic
   ti,tps65914-pmic
+  ti,tps65917-pmic
 and also the generic series names
   ti,palmas-pmic
 - interrupt-parent : The parent interrupt controller which is palmas.
-- 
1.7.9.5

