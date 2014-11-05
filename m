Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbaKERDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:03:19 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:64463 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021AbaKERAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:00:32 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        pekon@pek-sem.com, linux-mtd@lists.infradead.org
Subject: [PATCH v4 05/11] mtd: nand: Add new generic NAND Device Tree property 'nand-chip-select'
Date: Wed,  5 Nov 2014 16:59:47 +0000
Message-Id: <1415206793-25670-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415206793-25670-1-git-send-email-lee.jones@linaro.org>
References: <1415206793-25670-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/mtd/nand.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/mtd/nand.txt b/Documentation/devicetree/bindings/mtd/nand.txt
index b53f92e..1d542c51 100644
--- a/Documentation/devicetree/bindings/mtd/nand.txt
+++ b/Documentation/devicetree/bindings/mtd/nand.txt
@@ -12,6 +12,9 @@
 - nand-ecc-step-size: integer representing the number of data bytes
 		      that are covered by a single ECC step.
 
+- nand-chip-select: integer representing chip number associated with the
+		    described Flash chip.
+
 The ECC strength and ECC step size properties define the correction capability
 of a controller. Together, they say a controller can correct "{strength} bit
 errors per {size} bytes".
-- 
1.9.1

