Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965943AbaFRKyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 06:54:46 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:44912 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965512AbaFRKyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 06:54:44 -0400
Date: Wed, 18 Jun 2014 11:54:38 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: kernel@stlinux.com, maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, devicetree@vger.kernel.org
Subject: [PATCH v2] ARM: stih41x: Rename stih416-b2020-revE.dts to
 stih416-b2020e.dts
Message-ID: <20140618105438.GC8300@lee--X1>
References: <1403087508-6710-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403087508-6710-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two reasons for this rename.  Firstly, it removes the camel case
convention which isn't used by any other platform and secondly it
matches the naming convention for the internal kernel, which can
become annoying when flipping between the two.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
v1 -> v2: Appropriate change to the Makefile.
---
 arch/arm/boot/dts/Makefile                                       | 2 +-
 arch/arm/boot/dts/{stih416-b2020-revE.dts => stih416-b2020e.dts} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename arch/arm/boot/dts/{stih416-b2020-revE.dts => stih416-b2020e.dts} (100%)

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 5986ff6..adb5ed9 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -357,7 +357,7 @@ dtb-$(CONFIG_ARCH_STI)+= stih407-b2120.dtb \
        stih415-b2020.dtb \
        stih416-b2000.dtb \
        stih416-b2020.dtb \
-       stih416-b2020-revE.dtb
+       stih416-b2020e.dtb
 dtb-$(CONFIG_MACH_SUN4I) += \
        sun4i-a10-a1000.dtb \
        sun4i-a10-cubieboard.dtb \
diff --git a/arch/arm/boot/dts/stih416-b2020-revE.dts b/arch/arm/boot/dts/stih416-b2020e.dts
similarity index 100%
rename from arch/arm/boot/dts/stih416-b2020-revE.dts
rename to arch/arm/boot/dts/stih416-b2020e.dts
-- 
1.8.3.2
