Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbaGPC4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 22:56:16 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:41047 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbaGPC4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 22:56:14 -0400
X-PGP-Universal: processed;
	by shaapppus01.asia.root.pri on Wed, 16 Jul 2014 09:56:51 +0800
From: Huayi Li <huayi.li@csr.com>
To: Thierry Reding <thierry.reding@gmail.com>, <linux-pwm@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <workgroup.linux@csr.com>,
        <rongjun.ying@csr.com>, <barry.song@csr.com>,
        Huayi Li <huayi.li@csr.com>
Subject: [PATCH v5 4/4] ARM: prima2_defconfig: enable PWM and sirf PWM driver
Date: Wed, 16 Jul 2014 09:55:14 +0800
Message-ID: <1405475714-10006-5-git-send-email-huayi.li@csr.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405475714-10006-1-git-send-email-huayi.li@csr.com>
References: <1405475714-10006-1-git-send-email-huayi.li@csr.com>
MIME-Version: 1.0
X-Originating-IP: [10.125.12.180]
X-CFilter-Loop: Reflected
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Huayi Li <huayi.li@csr.com>
---
 arch/arm/configs/prima2_defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/prima2_defconfig b/arch/arm/configs/prima2_defconfig
index 23591db..303204a 100644
--- a/arch/arm/configs/prima2_defconfig
+++ b/arch/arm/configs/prima2_defconfig
@@ -50,6 +50,8 @@ CONFIG_DMADEVICES_DEBUG=y
 CONFIG_DMADEVICES_VDEBUG=y
 CONFIG_SIRF_DMA=y
 # CONFIG_IOMMU_SUPPORT is not set
+CONFIG_PWM=y
+CONFIG_PWM_SIRF=y
 CONFIG_EXT2_FS=y
 CONFIG_MSDOS_FS=y
 CONFIG_VFAT_FS=y
-- 
1.9.3



Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Keep up to date with CSR on our technical blog, www.csr.com/blog, CSR people blog, www.csr.com/people, YouTube, www.youtube.com/user/CSRplc, Facebook, www.facebook.com/pages/CSR/191038434253534, or follow us on Twitter at www.twitter.com/CSR_plc.
New for 2014, you can now access the wide range of products powered by aptX at www.aptx.com.
