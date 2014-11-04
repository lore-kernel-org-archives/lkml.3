Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbaKDKyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:54:33 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:35206 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752845AbaKDKxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:53:14 -0500
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: [PATCH v5 8/8] ARM: multi_v7_defconfig: Enable MiPHY28lp - ST's Generic (SATA, PCIe & USB3) PHY
Date: Tue,  4 Nov 2014 11:51:24 +0100
Message-Id: <1415098284-11182-9-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415098284-11182-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1415098284-11182-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-11-04_05:2014-11-03,2014-11-04,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
---
 arch/arm/configs/multi_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index f1dc7fc..d5c2ff1 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -425,6 +425,7 @@ CONFIG_PWM_TEGRA=y
 CONFIG_PWM_VT8500=y
 CONFIG_OMAP_USB2=y
 CONFIG_TI_PIPE3=y
+CONFIG_PHY_MIPHY28LP=y
 CONFIG_PHY_MIPHY365X=y
 CONFIG_PHY_SUN4I_USB=y
 CONFIG_EXT4_FS=y
-- 
1.9.1

