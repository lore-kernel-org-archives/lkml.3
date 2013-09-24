Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab3IXIJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:09:53 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64525 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab3IXIJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:09:05 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-a5-524148a06bd1
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
Subject: [PATCH 6/6] ARM: dts: exynos4412-trats2: Enable TMU support at Trats2
Date: Tue, 24 Sep 2013 10:08:22 +0200
Message-id: <1380010102-25817-7-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t9jAd0FHo5BBiu+KFo0XA2x2DhjPavF
	/CPnWC3W7P/JZNF59gmzxZtH3BZvHm5mtLi8aw6bxefeI4wWM87vY7K43biCzaJ/YS+TxZOH
	fWwW62e8ZnHg81i85yWTx7ppb5k9+rasYvR4tLiF0eP4je1MHp83yQWwRXHZpKTmZJalFunb
	JXBlfPn6nK1gCVvF6RuRDYxzWLsYOTgkBEwkGq5zdjFyApliEhfurWfrYuTiEBJYxCjRceI6
	M4TTxSSx8P1zZpAqNgE9ic93nzKBJEQEmhglfhz5BpZgFjjGLPFllQiILSzgJ9G74gkLiM0i
	oCrx5N0BJhCbV8BN4t3iFlaIdfIST+/3sYHYnALuEu1PpzCC2EJANW8fbWWZwMi7gJFhFaNo
	akFyQXFSeq6RXnFibnFpXrpecn7uJkZwgD6T3sG4qsHiEKMAB6MSD++FBIcgIdbEsuLK3EOM
	EhzMSiK8N2wdg4R4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmy1DhQSSE8sSc1OTS1ILYLJMnFw
	SjUwKhwN28EyaXXRJClxddn1LN/43/3OTn6tL/zj/2TzkL32ZXtNtPnyNnuEula4mr0Ps64L
	Npw/39/t/4EFc65V1++oZ1sXJ+EoaXpFcsfj9uD7vJdiAjbfUdSTLPFi2Pxde8V/4U1LsgKe
	F6fOmqt86PVC29KvpWcvXnxVwr5jtZ7zluMeHSaSSizFGYmGWsxFxYkApE2UwUwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables support for TMU at Exynos4412 based Trats2 board.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
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

