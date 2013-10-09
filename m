Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab3JIGb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 02:31:27 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37377 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab3JIGau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 02:30:50 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-77-5254f8079eae
From: Lukasz Majewski <l.majewski@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>, kgene.kim@samsung.com
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, devicetree@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v2 5/5] ARM: dts: exynos4412-trats2: Enable TMU support at
 Trats2
Date: Wed, 09 Oct 2013 08:29:54 +0200
Message-id: <1381300194-13134-6-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1381300194-13134-1-git-send-email-l.majewski@samsung.com>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
 <1381300194-13134-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t9jQV32HyFBBi0dwhYNV0MsNs5Yz2ox
	/8g5Vos1+38yWXSefcJs0bvgKpvFm0fcFm8ebma0uLxrDpvF594jjBYzzu9jsrjduILN4szp
	S6wWTx72sVmsn/GaxYHfY/Gel0we66a9ZfbYcrWdxaNvyypGj+M3tjN5fN4kF8AWxWWTkpqT
	WZZapG+XwJXx8u08xoKDbBXXL+xnamBcx9rFyMkhIWAiseZ3IxuELSZx4d56IJuLQ0hgOqPE
	hsY9jBBOF5PEhZXnwKrYBPQkPt99ygRiiwhkSJy6NJsJpIhZ4C+zxPVpx1hAEsICwRKbZqxk
	BLFZBFQlJq7YCtbAK+AmcfdTIyPEOnmJp/f7wIZyCrhLHLzzjh1iWzOjxKOLm1gmMPIuYGRY
	xSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcsM+kdjCubLA4xCjAwajEw/uAPyRIiDWxrLgy
	9xCjBAezkghv3kKgEG9KYmVValF+fFFpTmrxIUZpDhYlcd4DrdaBQgLpiSWp2ampBalFMFkm
	Dk6pBsa2jL4DN/I/naqyL6q3FJvC/Pt/4YZXAfb/Ah4LLrp8Z1Pnw9z4U4sMnRWmG1xPlfzs
	4PVj9fTPlZ8OaridcjF74Hbi1vZpoTtXvL109wzT5P4iozqDh8Ycuxq+7Hp6tOzpqZKKsGfq
	4UlZs8x5WvKvMT7yjZWL83u/X7rnpnqAxayWmnnThc8rsRRnJBpqMRcVJwIA6lk3sFQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables support for TMU at Exynos4412 based Trats2 board.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>

---
Changes for v2:
- None

 arch/arm/boot/dts/exynos4412-trats2.dts |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index fb7b9ae..57136f8 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -467,6 +467,11 @@
 		status = "okay";
 	};
 
+	tmu@100C0000 {
+		vtmu-supply = <&ldo10_reg>;
+		status = "okay";
+	};
+
 	i2c_ak8975: i2c-gpio-0 {
 		compatible = "i2c-gpio";
 		gpios = <&gpy2 4 0>, <&gpy2 5 0>;
-- 
1.7.10.4

