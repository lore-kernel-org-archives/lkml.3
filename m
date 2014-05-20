Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaETNSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:18:36 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:50431 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868AbaETNS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:18:28 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Olof Johansson <olof@lixom.net>, Rob Landley <rob@landley.net>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Maxime Coquelin <maxime.coquelin@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
Cc: lee.jones@linaro.org
Subject: [PATCH v7 1/4] ARM: dts: Sort STi boards in Makefile
Date: Tue, 20 May 2014 15:17:29 +0200
Message-Id: <1400591852-17577-2-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400591852-17577-1-git-send-email-maxime.coquelin@st.com>
References: <1400591852-17577-1-git-send-email-maxime.coquelin@st.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-20_02:2014-05-20,2014-05-20,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The boards have to be sorted in alphanumerical order in the Makefile.

Cc: Olof Johansson <olof@lixom.net>
Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
---
 arch/arm/boot/dts/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 35c146f..6fa1343 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -336,8 +336,8 @@ dtb-$(CONFIG_ARCH_SPEAR3XX)+= spear300-evb.dtb \
 	spear320-hmi.dtb
 dtb-$(CONFIG_ARCH_SPEAR6XX)+= spear600-evb.dtb
 dtb-$(CONFIG_ARCH_STI)+= stih415-b2000.dtb \
-	stih416-b2000.dtb \
 	stih415-b2020.dtb \
+	stih416-b2000.dtb \
 	stih416-b2020.dtb
 dtb-$(CONFIG_ARCH_SUNXI) += \
 	sun4i-a10-a1000.dtb \
-- 
1.9.1

