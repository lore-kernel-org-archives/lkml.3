Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbaLaFUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 00:20:18 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:38595 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaLaFUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 00:20:03 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-91-54a3877b3fe8
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        b.zolnierkie@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC PATCHv2 8/8] ARM: dts: Add memory bus node for Exynos4412-based
 TRATS2 board
Date: Wed, 31 Dec 2014 14:19:52 +0900
Message-id: <1420003192-5576-9-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1420003192-5576-1-git-send-email-cw00.choi@samsung.com>
References: <1420003192-5576-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42JZI2JSrFvdvjjEYO1mWYvHaxYzWWycsZ7V
	4vqX56wWk+5PYLF4/cLQonfBVTaLs01v2C02Pb7GanF51xw2i8+9RxgtZpzfx2Sx9PpFJovb
	jSvYLB6veMtusWrXH0YHfo8189YweuycdZfdY/Gel0wem5fUe/RtWcXo8XmTXABbFJdNSmpO
	Zllqkb5dAlfGlkUuBXM5K7Zc/cjWwPiMvYuRg0NCwETizhyRLkZOIFNM4sK99WxdjFwcQgJL
	GSX+Hm5lgam53mcHEV/EKHHm8A9GCKeJSWLKraksIN1sAloS+1/cYAOxRQRkJK5u3M4CUsQs
	8J9J4vGr5awgCWGBGIkNN1ayg9gsAqoSCze9A2vmFXCR6L24jwXiDAWJZctnsoJs5hRwlZjw
	xRkkLARUMmNLMxPITAmBe+wSi38dgZojIPFt8iGoS2UlNh1ghhgjKXFwxQ2WCYzCCxgZVjGK
	phYkFxQnpReZ6BUn5haX5qXrJefnbmIERs7pf88m7GC8d8D6EKMAB6MSD+8Nu8UhQqyJZcWV
	uYcYTYE2TGSWEk3OB8ZnXkm8obGZkYWpiamxkbmlmZI472upn8FCAumJJanZqakFqUXxRaU5
	qcWHGJk4OKUaGLUZPALaX69j++rIns4SfuXYb5bbE2xbNnGIpa60/OIT+0nty1Uzm6clP9by
	n9See+pT/NyiVTHhXSquzqKRF/6yKv06OD3w2Lk3+pzSlvZ/5Y55Gz+ZsU1+nlHoPrU1l4Rd
	Un29dKe/SLQ2KJd2cVA88/u4x3aV4B8MxxebhP4Tf+X6+u8nHiWW4oxEQy3mouJEACF0FmWX	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t9jAd3q9sUhBt27xCwer1nMZLFxxnpW
	i+tfnrNaTLo/gcXi9QtDi94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27xapdfxgd+D3WzFvD6LFz1l12j8V7XjJ5bF5S79G3ZRWjx+dNcgFsUQ2MNhmp
	iSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAJysplCXmlAKF
	AhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM7YscimYy1mx5epHtgbGZ+xdjBwcEgIm
	Etf77LoYOYFMMYkL99azdTFycQgJLGKUOHP4ByOE08QkMeXWVBaQKjYBLYn9L26wgdgiAjIS
	VzduZwEpYhb4zyTx+NVyVpCEsECMxIYbK9lBbBYBVYmFm96BNfMKuEj0XtzHArFOQWLZ8pms
	IFdwCrhKTPjiDBIWAiqZsaWZaQIj7wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwZH5
	TGoH48oGi0OMAhyMSjy8N+wWhwixJpYVV+YeYpTgYFYS4b2sCRTiTUmsrEotyo8vKs1JLT7E
	aAp01ERmKdHkfGDSyCuJNzQ2MTOyNDI3tDAyNlcS51WybwsREkhPLEnNTk0tSC2C6WPi4JRq
	YFxv32Ny7b56kJju3hdP/N+8P93/9un7B/XpF258sO25oRzW1Mvpcfnx4/zwc9lvrjAwbUuc
	48b42edv8PtF7Y7+FinyJzSqrG/vP6T9wPCJ6MFHdfbu3g81l0ZI7pOreXXSa8nG9fkfO9kf
	yHT+k9pdfvjzP+4+hf7/DvPaPgd3HBQ9ueTAqYlKLMUZiYZazEXFiQBX0Mfy4gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Exynos4412 memory-bus node which includes the regulator
and devfreq-event phandle. The devfreq-event phandle is used for the
governor of devfreq device and provide the current usage state of
MIF (Memory Interface) / INT (Internal) memory bus group.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index bee0eed..21ba25e 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -917,6 +917,18 @@
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
 &pinctrl_0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&sleep0>;
-- 
1.8.5.5

