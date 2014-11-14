Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935137AbaKNKEM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 05:04:12 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:47585 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980AbaKNKEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 05:04:05 -0500
X-AuditID: cbfee61a-f79c06d000004e71-d3-5465d393b259
From: Lukasz Majewski <l.majewski@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: [RESEND PATCH 2/2] ARM: dts: exynos4412-trats2: Enable TMU support at
 Trats2
Date: Fri, 14 Nov 2014 11:03:25 +0100
Message-id: <1415959405-14157-2-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415959405-14157-1-git-send-email-l.majewski@samsung.com>
References: <1381300194-13134-5-git-send-email-l.majewski@samsung.com>
 <1415959405-14157-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jQd3Jl1NDDJrX81lsnLGe1WLSugNM
	FvOPnGO16H+zkNXi3KuVjBa9C66yWbx5uJnRYtPja6wWl3fNYbOYcX4fk8Xty7wWS69fZLKY
	MH0ti0Xr3iPsFqt2/WF04PdYM28No0dLcw+bx+W+XiaPv6teMHvsnHWX3WPl8i9sHptWdbJ5
	bF5S79G3ZRWjx+dNcgFcUVw2Kak5mWWpRfp2CVwZqw6/YS1Yylax7N9NtgbGBaxdjJwcEgIm
	EuvuTIayxSQu3FvP1sXIxSEkMJ1R4n/3Iyini0nizL6PjCBVbAJ6Ep/vPmUCsUUE1CR6Fm8F
	izMLzGSROPinAMQWFgiX6J77hg3EZhFQldi0YRZYPa+Am8S+d2+ZIbYpSnQ/mwBUw8HBKeAu
	cXWdMsSuZkaJudfXsU1g5F3AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzion0ntYFzZ
	YHGIUYCDUYmHl8EtNUSINbGsuDL3EKMEB7OSCG/oeaAQb0piZVVqUX58UWlOavEhRmkOFiVx
	3gOt1oFCAumJJanZqakFqUUwWSYOTqkGxvMek+5pP2ETKZFcL7VLSplF7OgmViblmQIfi+7e
	/nRzzZ0DD+KmCP3xD7qvnbZciOPimbSgq6XhU9extE5bxbv1nlJDAFNF+XMGp27n9yYqz04G
	b1jy7NuJP1eip67LWXPv2E+tokWK7Hd2KKdvXDVZJ/Lv0sLPAdyFAmtMvflj6zZF7D97fJUS
	S3FGoqEWc1FxIgC9A+ZFZgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables support for TMU at Exynos4412 based Trats2 board.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Reviewed-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 5e066cd..121430d 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -551,6 +551,11 @@
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
2.0.0.rc2

