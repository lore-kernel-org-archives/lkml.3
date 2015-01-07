Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbbAGXxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:53:38 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:44586 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626AbbAGXvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:51:24 -0500
X-AuditID: cbfee68d-f79296d000004278-4c-54adc678b559
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv7 09/10] ARM: dts: exynos: Add PPMU node to Exynos3250-based
 Rinato/Monk board
Date: Thu, 08 Jan 2015 08:51:16 +0900
Message-id: <1420674677-3077-10-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1420674677-3077-1-git-send-email-cw00.choi@samsung.com>
References: <1420674677-3077-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42JZI2JSpFtxbG2IwaXFYhaP1yxmstg4Yz2r
	xfUvz1ktJt2fwGLx+oWhRf/j18wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8li6fWLTBa3
	G1ewWTxe8ZbdonXvEXaLVbv+MDoIeKyZt4bRY+esu+wei/e8ZPLYtKqTzWPzknqPvi2rGD0+
	b5ILYI/isklJzcksSy3St0vgypjQtYClYJ9QxanrZg2Mr/m6GDk4JARMJOZsD+ti5AQyxSQu
	3FvP1sXIxSEksJRR4syde6wQCROJ759WMkMkFjFKTFjwlAXCaWKSmLp4BjtIFZuAlsT+FzfY
	QGwRAT2JzmN7wOLMAn+YJJo2sYDYwgIJEi9OHGAEsVkEVCXuPnrADGLzCrhKfNr5nR1im4LE
	suUzwTZzAsWXbl4IViMk4CLxsucXI8hiCYGX7BLtd2+zQAwSkPg2+RALxDuyEpsOMEPMkZQ4
	uOIGywRG4QWMDKsYRVMLkguKk9KLDPWKE3OLS/PS9ZLzczcxAuPp9L9nvTsYbx+wPsQowMGo
	xMNb0LcmRIg1say4MvcQoynQhonMUqLJ+cCozSuJNzQ2M7IwNTE1NjK3NFMS51WU+hksJJCe
	WJKanZpakFoUX1Sak1p8iJGJg1OqgVHW+PdM75dJUWcXnfova8j9Qv/1jh8nnFMFJ3SfFnXJ
	jSk6Jzjnedu6JjHnlvbPyfffTFu22zHixOwtNy9aWf+aVyu/99R91trGfGbRzXF/73uL7r/d
	uLs0rKLIzqPnM88NUUahh4u6lz+wj7cIfZKvMut38/02/0CGkJ43lpOmFAdIqsRaPVdiKc5I
	NNRiLipOBAAArhHgogIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jAd2KY2tDDO5081o8XrOYyWLjjPWs
	Fte/PGe1mHR/AovF6xeGFv2PXzNbnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLpdcvMlnc
	blzBZvF4xVt2i9a9R9gtVu36w+gg4LFm3hpGj52z7rJ7LN7zkslj06pONo/NS+o9+rasYvT4
	vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0z
	B+h4JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGhK4FLAX7hCpOXTdr
	YHzN18XIySEhYCLx/dNKZghbTOLCvfVsXYxcHEICixglJix4ygLhNDFJTF08gx2kik1AS2L/
	ixtsILaIgJ5E57E9YHFmgT9MEk2bWEBsYYEEiRcnDjCC2CwCqhJ3Hz0A28Ar4Crxaed3doht
	ChLLls9kBbE5geJLNy8EqxEScJF42fOLcQIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5
	uZsYwfH6THoH46oGi0OMAhyMSjy8BX1rQoRYE8uKK3MPMUpwMCuJ8K5tWxsixJuSWFmVWpQf
	X1Sak1p8iNEU6KqJzFKiyfnAVJJXEm9obGJmZGlkbmhhZGyuJM6rZN8WIiSQnliSmp2aWpBa
	BNPHxMEp1cCYdbJh8qryE4z9to57fy+vUTb1WhLEohkaxSn8/UrT1w1PL19M6vq4fc+/BWrn
	Mqs4D0/PS94q4ns5y3gZa/jMx747u/9qX7H7fEB+bT5jjGsZg6r99eQa9gvrVZgi7fTY39S5
	SATNvKUjv5xTsCIoUjTeWPv1UnnNR394C7Rfiq/mdq6/JqnEUpyRaKjFXFScCAAbIY+j7QIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add PPMU dt node to Exynos3250-base Rinato/Monk board. The PPMU node
is used to get the utilization of DMC0/DMC1/LEFTBUS/RIGHTBUS Block.

Cc: Kukjin Kim <kgene@kernel.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250-monk.dts   | 40 +++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos3250-rinato.dts | 40 +++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-monk.dts b/arch/arm/boot/dts/exynos3250-monk.dts
index 24822aa..fcceb59 100644
--- a/arch/arm/boot/dts/exynos3250-monk.dts
+++ b/arch/arm/boot/dts/exynos3250-monk.dts
@@ -420,6 +420,46 @@
 	status = "okay";
 };
 
+&ppmu_dmc0 {
+	status = "okay";
+
+	events {
+		ppmu_dmc0_3: ppmu-event3-dmc0 {
+			event-name = "ppmu-event3-dmc0";
+		};
+	};
+};
+
+&ppmu_dmc1 {
+	status = "okay";
+
+	events {
+		ppmu_dmc1_3: ppmu-event3-dmc1 {
+			event-name = "ppmu-event3-dmc1";
+		};
+	};
+};
+
+&ppmu_leftbus {
+	status = "okay";
+
+	events {
+		ppmu_leftbus_3: ppmu-event3-leftbus {
+			event-name = "ppmu-event3-leftbus";
+		};
+	};
+};
+
+&ppmu_rightbus {
+	status = "okay";
+
+	events {
+		ppmu_rightbus_3: ppmu-event3-rightbus {
+			event-name = "ppmu-event3-rightbus";
+		};
+	};
+};
+
 &xusbxti {
 	clock-frequency = <24000000>;
 };
diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index 7cc52b5..9dd1ce1 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -595,6 +595,46 @@
 	status = "okay";
 };
 
+&ppmu_dmc0 {
+	status = "okay";
+
+	events {
+		ppmu_dmc0_3: ppmu-event3-dmc0 {
+			event-name = "ppmu-event3-dmc0";
+		};
+	};
+};
+
+&ppmu_dmc1 {
+	status = "okay";
+
+	events {
+		ppmu_dmc1_3: ppmu-event3-dmc1 {
+			event-name = "ppmu-event3-dmc1";
+		};
+	};
+};
+
+&ppmu_leftbus {
+	status = "okay";
+
+	events {
+		ppmu_leftbus_3: ppmu-event3-leftbus {
+			event-name = "ppmu-event3-leftbus";
+		};
+	};
+};
+
+&ppmu_rightbus {
+	status = "okay";
+
+	events {
+		ppmu_rightbus_3: ppmu-event3-rightbus {
+			event-name = "ppmu-event3-rightbus";
+		};
+	};
+};
+
 &xusbxti {
 	clock-frequency = <24000000>;
 };
-- 
1.8.5.5

