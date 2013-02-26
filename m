Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759836Ab3BZW6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:58:24 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51015 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab3BZW6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:58:20 -0500
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 12/15] staging: omap-thermal: add DT example for OMAP54xx devices
Date: Tue, 26 Feb 2013 18:53:35 -0400
Message-ID: <1361919218-9788-13-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1361919218-9788-1-git-send-email-eduardo.valentin@ti.com>
References: <1361919218-9788-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update documentation with DT example for OMAP54xx devices.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap_bandgap.txt |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap_bandgap.txt b/drivers/staging/omap-thermal/omap_bandgap.txt
index e30dc1c..a4a33d1 100644
--- a/drivers/staging/omap-thermal/omap_bandgap.txt
+++ b/drivers/staging/omap-thermal/omap_bandgap.txt
@@ -49,3 +49,12 @@ bandgap {
 	interrupts = <0 126 4>; /* talert */
 	ti,tshut-gpio = <86>;
 };
+
+OMAP5430:
+bandgap {
+	reg = <0x4a0021e0 0xc
+		0x4a00232c 0xc
+		0x4a002380 0x2c
+		0x4a0023C0 0x3c>;
+	compatible = "ti,omap5430-bandgap";
+};
-- 
1.7.7.1.488.ge8e1c

