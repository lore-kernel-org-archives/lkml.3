Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbbAOBwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 20:52:06 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:58732 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbbAOBvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 20:51:12 -0500
X-AuditID: cbfee68f-f791c6d000004834-29-54b71d097105
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Youngjun Cho <yj44.cho@samsung.com>
Subject: [PATCH v4 7/9] ARM: dts: Add the support for exynos busfreq on
 Exynos3250-based Rinato/Monk board
Date: Thu, 15 Jan 2015 10:50:55 +0900
Message-id: <1421286657-4720-8-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1421286657-4720-1-git-send-email-cw00.choi@samsung.com>
References: <1421286657-4720-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsWyRsSkQJdTdnuIQd9UHovHaxYzWWycsZ7V
	4vqX56wWk+5PYLF4/cLQov/xa2aLs01v2C02Pb7GanF51xw2i8+9RxgtZpzfx2Sx9PpFJovb
	jSvYLB6veMtu0br3CLvFql1/GC327pzM6CDosWbeGkaPnbPusnss3vOSyWPTqk42j81L6j36
	tqxi9Pi8SS6APYrLJiU1J7MstUjfLoEr43vbdtaCe3wV+9ffZmtg3M/TxcjBISFgIvH7pHYX
	IyeQKSZx4d56ti5GLg4hgaWMEkfefWSHSJhITHjTzQ6RmM4ocXz6aSaQhJBAE5PE06ZsEJtN
	QEti/4sbbCC2iICeROexPWANzAILmSVubesCSwgL5Ej87X4O1swioCqxZ9UksDivgIvEt1Vt
	rBDbFCSWLZ8JZnMKuEr0/NrPDrHMRWLV3cmMEDUf2SVaX4RCzBGQ+Db5EAvEN7ISmw4wQ5RI
	ShxccYNlAqPwAkaGVYyiqQXJBcVJ6UXGesWJucWleel6yfm5mxiBkXX637P+HYx3D1gfYhTg
	YFTi4XU4sjVEiDWxrLgy9xCjKdCGicxSosn5wPjNK4k3NDYzsjA1MTU2Mrc0UxLnXSj1M1hI
	ID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD47Gt9VOfGc7LtQm7EJA96foEP3Ym3bf6Uo1NPA/O
	z2YI38UoxqB2+MvaFpas7wLZjb3sTN4lJzJ7RV6qHHu1Mcf3fKRCZf6N65PYWAoinNflH5+R
	tmj3Fu01E6b0fuz3P3rm77aP3w6yHciqKBYRe6176obPq307racGVK3o/eVkc/2Nw7Rdskos
	xRmJhlrMRcWJAHuYJvunAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t9jQV1O2e0hBpubWSwer1nMZLFxxnpW
	i+tfnrNaTLo/gcXi9QtDi/7Hr5ktzja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27ReveI+wWq3b9YbTYu3Myo4Ogx5p5axg9ds66y+6xeM9LJo9NqzrZPDYvqffo
	27KK0ePzJrkA9qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUX
	nwBdt8wcoA+UFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBnf27azFtzj
	q9i//jZbA+N+ni5GTg4JAROJCW+62SFsMYkL99azdTFycQgJTGeUOD79NBNIQkigiUniaVM2
	iM0moCWx/8UNNhBbREBPovPYHnaQBmaBhcwSt7Z1gSWEBXIk/nY/B2tmEVCV2LNqElicV8BF
	4tuqNlaIbQoSy5bPBLM5BVwlen7tZ4dY5iKx6u5kxgmMvAsYGVYxiqYWJBcUJ6XnGuoVJ+YW
	l+al6yXn525iBMfuM6kdjCsbLA4xCnAwKvHwOhzZGiLEmlhWXJl7iFGCg1lJhPftp20hQrwp
	iZVVqUX58UWlOanFhxhNga6ayCwlmpwPTCt5JfGGxiZmRpZG5oYWRsbmSuK8SvZtIUIC6Ykl
	qdmpqQWpRTB9TBycUg2Msww5Pa9aTj1fpr/Mn8f1oUt92n++p3+XcZrlV/vlJLhwrZuw0L6o
	1uD5NvuyJ4sfZ2+YLZOr9PGX7xcH0V3qe547Ot0POPT6648m1ul2ohwKk2xa+llmHbE/2h7/
	T9pq2s1kqYIju+VrLu7tN9W8+/GKXE/EvCnrLThiJRRTGdme/XZ6VmuqxFKckWioxVxUnAgA
	wz+HT/MCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Exynos3250 memory-bus node which includes the regulator
and devfreq-event phandle. The devfreq-event phandle is used for the
governor of devfreq device and provide the current usage state of
MIF (Memory Interface) / INT (Internal) memory bus group.

Cc: Kukjin Kim <kgene@kernel.org>
Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Youngjun Cho <yj44.cho@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250-monk.dts   | 12 ++++++++++++
 arch/arm/boot/dts/exynos3250-rinato.dts | 12 ++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-monk.dts b/arch/arm/boot/dts/exynos3250-monk.dts
index fcceb59..efadb16 100644
--- a/arch/arm/boot/dts/exynos3250-monk.dts
+++ b/arch/arm/boot/dts/exynos3250-monk.dts
@@ -460,6 +460,18 @@
 	};
 };
 
+&memory_bus_mif {
+	devfreq-events = <&ppmu_dmc0_3>, <&ppmu_dmc1_3>;
+	vdd-mem-supply = <&buck1_reg>;
+	status = "okay";
+};
+
+&memory_bus_int {
+	devfreq-events = <&ppmu_leftbus_3>, <&ppmu_rightbus_3>;
+	vdd-mem-supply = <&buck3_reg>;
+	status = "okay";
+};
+
 &xusbxti {
 	clock-frequency = <24000000>;
 };
diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index 9dd1ce1..cf800ed 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -635,6 +635,18 @@
 	};
 };
 
+&memory_bus_mif {
+	devfreq-events = <&ppmu_dmc0_3>, <&ppmu_dmc1_3>;
+	vdd-mem-supply = <&buck1_reg>;
+	status = "okay";
+};
+
+&memory_bus_int {
+	devfreq-events = <&ppmu_leftbus_3>, <&ppmu_rightbus_3>;
+	vdd-mem-supply = <&buck3_reg>;
+	status = "okay";
+};
+
 &xusbxti {
 	clock-frequency = <24000000>;
 };
-- 
1.8.5.5

