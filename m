Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbaHHKUC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 06:20:02 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:34615 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558AbaHHKT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 06:19:56 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH 3/3] MAINTAINERS: Add phy-stih41x-usb.c to ARCH/STI architecture
Date: Fri,  8 Aug 2014 11:19:35 +0100
Message-Id: <1407493175-2611-4-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407493175-2611-1-git-send-email-peter.griffin@linaro.org>
References: <1407493175-2611-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c2066f4..6283d83 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1356,6 +1356,7 @@ F:	drivers/pinctrl/pinctrl-st.c
 F:	drivers/media/rc/st_rc.c
 F:	drivers/i2c/busses/i2c-st.c
 F:	drivers/tty/serial/st-asc.c
+F:	drivers/phy/phy-stih41x-usb.c
 
 ARM/TECHNOLOGIC SYSTEMS TS7250 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-- 
1.9.1

