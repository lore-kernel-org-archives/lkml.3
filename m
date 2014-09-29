Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbaI2Ltj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 07:49:39 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:49963 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaI2Ltg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 07:49:36 -0400
From: zhang.lyra@gmail.com
To: catalin.marinas@arm.com, gregkh@linuxfoundation.org,
        ijc+devicetree@hellion.org.uk, jslaby@suse.cz, galak@codeaurora.org,
        broonie@linaro.org, mark.rutland@arm.com, m-karicheri2@ti.com,
        pawel.moll@arm.com, artagnon@gmail.com, rrichter@cavium.com,
        robh+dt@kernel.org, will.deacon@arm.com, orsonzhai@gmail.com,
        geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "chunyan.zhang" <chunyan.zhang@spreadtrum.com>
Subject: [PATCH 1/6] Documentation: DT: Add bindings for Spreadtrum serial
Date: Mon, 29 Sep 2014 19:48:29 +0800
Message-Id: <1411991314-6636-2-git-send-email-zhang.lyra@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411991314-6636-1-git-send-email-zhang.lyra@gmail.com>
References: <1411991314-6636-1-git-send-email-zhang.lyra@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "chunyan.zhang" <chunyan.zhang@spreadtrum.com>

Adds the device-tree documentation for Spreadtrum's serial.

Signed-off-by: chunyan.zhang <chunyan.zhang@spreadtrum.com>
---
 .../devicetree/bindings/serial/of-serial.txt       |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/serial/of-serial.txt b/Documentation/devicetree/bindings/serial/of-serial.txt
index 7705477..a0bb1d1 100644
--- a/Documentation/devicetree/bindings/serial/of-serial.txt
+++ b/Documentation/devicetree/bindings/serial/of-serial.txt
@@ -14,6 +14,7 @@ Required properties:
 	- "altr,16550-FIFO32"
 	- "altr,16550-FIFO64"
 	- "altr,16550-FIFO128"
+	- "sprd,serial"
 	- "serial" if the port type is unknown.
 - reg : offset and length of the register set for the device.
 - interrupts : should contain uart interrupt.
-- 
1.7.9.5

