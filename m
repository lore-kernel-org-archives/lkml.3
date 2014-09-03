Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbaICK2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:28:22 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:55311 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155AbaICK2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 06:28:15 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, kishon@ti.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH 3/3] MAINTAINERS: Add phy-stih407-usb.c file to ARCH/STI architecture
Date: Wed,  3 Sep 2014 11:27:59 +0100
Message-Id: <1409740079-16554-4-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409740079-16554-1-git-send-email-peter.griffin@linaro.org>
References: <1409740079-16554-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the new phy-stih407-usb.c usb phy driver found on
STMicroelectronics stih407 consumer electronics SoC's into the STI
arch section of the maintainers file.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 55381955..0d0818a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1399,6 +1399,7 @@ F:	drivers/i2c/busses/i2c-st.c
 F:	drivers/tty/serial/st-asc.c
 F:	drivers/mmc/host/sdhci-st.c
 F:	drivers/usb/dwc3/dwc3-st.c
+F:	drivers/phy/phy-stih407-usb.c
 
 ARM/TECHNOLOGIC SYSTEMS TS7250 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-- 
1.9.1

