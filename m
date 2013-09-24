Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3IXIJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:09:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44965 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab3IXIJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:09:00 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-67-5241489b2e39
From: Lukasz Majewski <l.majewski@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 5/6] ARM: dts: exynos4x12: Device tree node definition for TMU
 on Exynos4x12
Date: Tue, 24 Sep 2013 10:08:21 +0200
Message-id: <1380010102-25817-6-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t9jAd3ZHo5BBps2qFs0XA2x2DhjPavF
	/CPnWC3W7P/JZNF59gmzxZtH3BZvHm5mtLi8aw6bxefeI4wWM87vY7K43biCzaJ/YS+TxZOH
	fWwW62e8ZnHg81i85yWTx7ppb5k9+rasYvR4tLiF0eP4je1MHp83yQWwRXHZpKTmZJalFunb
	JXBlzFmnWHCKrWLayetsDYzbWbsYOTkkBEwkZt58wgZhi0lcuLcezBYSWMQocXlCWhcjF5Dd
	xSRxue07C0iCTUBP4vPdp0wgCRGBJkaJH0e+MYMkmAWOMUt8WSUCYgsLxEkcWzYdbAOLgKrE
	3+7fYDavgJvE1LM7mCC2yUs8vd8Hto1TwF2i/ekURojNbhJvH21lmcDIu4CRYRWjaGpBckFx
	UnquoV5xYm5xaV66XnJ+7iZGcIA+k9rBuLLB4hCjAAejEg/vDm+HICHWxLLiytxDjBIczEoi
	vDdsHYOEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5otQ4UEkhPLEnNTk0tSC2CyTJxcEo1MPrV
	enivOdrOvSx/deOm/pLld1i3nHqvUCWZfldm2pe+YnbFrV9dt5ZZLGZZ1PgkoNMw4dEXnSUM
	kwT8n89um5k17c6uDVY2qyboSZ+7GvbpcLzFrtvT1vg/f/EteULex33KLNHVE+ZqyE/kbT05
	Sedr/LlHoZPOGK/j3nlLeOHV4otq8VvedkgqsRRnJBpqMRcVJwIAJ7isb0wCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TMU device tree node definition for Exynos4x12 family of SoCs.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/boot/dts/exynos4x12.dtsi |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index ad531fe..64c0ece 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -176,4 +176,14 @@
 			};
 		};
 	};
+
+	tmu@100C0000 {
+		compatible = "samsung,exynos4412-tmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <2 4>;
+		reg = <0x100C0000 0x100>;
+		clocks = <&clock 383>;
+		clock-names = "tmu_apbif";
+		status = "disabled";
+	};
 };
-- 
1.7.10.4

