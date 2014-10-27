Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaJ0BMO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 21:12:14 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16706 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbaJ0BMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 21:12:10 -0400
X-AuditID: cbfee68d-f79296d000004278-78-544d9be0e033
From: Chanwoo Choi <cw00.choi@samsung.com>
To: s.nawrocki@samsung.com, tomasz.figa@gmail.com
Cc: kgene.kim@samsung.com, sw0312.kim@samsung.com, kyungmin.park@samsung.com,
        inki.dae@samsung.com, geunsik.lim@samsung.com, cw00.choi@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv3 2/2] clk: samsung: Document binding for Exynos4415 clock
 controller
Date: Mon, 27 Oct 2014 10:11:58 +0900
Message-id: <1414372318-594-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1414372318-594-1-git-send-email-cw00.choi@samsung.com>
References: <1414372318-594-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWyRsSkSPfBbN8Qg3enZCyuf3nOavFnQiub
	xaT7E1gsehdcZbM42/SG3eLyrjlsFjPO72OyOPymndVixuSXbBardv1hdODy2DnrLrtH35ZV
	jB6fN8kFMEdx2aSk5mSWpRbp2yVwZfTvX8hecEig4t+drWwNjN95uxg5OSQETCTWvDnECmGL
	SVy4t56ti5GLQ0hgKaPEvXMrmGCKjr9ZxQ6RmM4osfDIAyiniUni1aRVjCBVbAJaEvtf3ABq
	5+AQETCUuHlICaSGWeA6o8TMUz1gcWGBcIkpS71BylkEVCX2HtjEDmLzCjhLPDn0iBlimYLE
	suUzwS7iFHCR+Hr3FliNEFDNw7lHwPZKCCxil3i1qYENYpCAxLfJh1hA5ksIyEpsOgA1R1Li
	4IobLBMYhRcwMqxiFE0tSC4oTkovMtQrTswtLs1L10vOz93ECAz40/+e9e5gvH3A+hCjAAej
	Eg+vRaFviBBrYllxZe4hRlOgDROZpUST84FxlVcSb2hsZmRhamJqbGRuaaYkzqso9TNYSCA9
	sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2PxFD9v2Y9J/k/Drpsq6czau0p4f6qcq7yMtpaW6nLL
	yfz8rU5BU6uyzqhek1zXypay+rR9ftyzu1Nnp82aHf2TR/C1Svgm/7csSk3beIz/p/7LOmBe
	zf876vF8pQK7OVKpHl+iciWmv/xd/fYcw99zfv3y5nZqh9WZZM0MuI72ChjHcsy7qcRSnJFo
	qMVcVJwIAI4ogY9zAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t9jQd0Hs31DDD4/FLW4/uU5q8WfCa1s
	FpPuT2Cx6F1wlc3ibNMbdovLu+awWcw4v4/J4vCbdlaLGZNfslms2vWH0YHLY+esu+wefVtW
	MXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg
	65aZA3SMkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjGjf/9C9oJDAhX/
	7mxla2D8ztvFyMkhIWAicfzNKnYIW0ziwr31bF2MXBxCAtMZJRYeecAO4TQxSbyatIoRpIpN
	QEti/4sbQFUcHCIChhI3DymB1DALXGeUmHmqBywuLBAuMWWpN0g5i4CqxN4Dm8AW8Ao4Szw5
	9IgZYpmCxLLlM1lBbE4BF4mvd2+B1QgB1Tyce4R9AiPvAkaGVYyiqQXJBcVJ6bmGesWJucWl
	eel6yfm5mxjB8fRMagfjygaLQ4wCHIxKPLwWhb4hQqyJZcWVuYcYJTiYlUR4RfOBQrwpiZVV
	qUX58UWlOanFhxhNga6ayCwlmpwPjPW8knhDYxMzI0sjc0MLI2NzJXHeA63WgUIC6Yklqdmp
	qQWpRTB9TBycUg2MsclB897x1KxdqNwtIMD1MUftMO87+4iga3GTl4u8eBD23OXztfU2xU9K
	mIKOHpykYP7n6U2XdE2hmRdcDUMWiBbN3XSK7c6Ce9XW/SuUF2Sy7X3runhi16oZGyrmndEs
	eyxzNedflnNlcJtIgUecKBufnM3eJAX3lYWTYkuqOc9t/LLz6M5pSizFGYmGWsxFxYkAwSgf
	qL0CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DT binding documentation for Exynos4415 SoC system
clock controllers.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 .../devicetree/bindings/clock/exynos4415-clock.txt | 38 ++++++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos4415-clock.txt

diff --git a/Documentation/devicetree/bindings/clock/exynos4415-clock.txt b/Documentation/devicetree/bindings/clock/exynos4415-clock.txt
new file mode 100644
index 0000000..847d98b
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/exynos4415-clock.txt
@@ -0,0 +1,38 @@
+* Samsung Exynos4415 Clock Controller
+
+The Exynos4415 clock controller generates and supplies clock to various
+consumer devices within the Exynos4415 SoC.
+
+Required properties:
+
+- compatible: should be one of the following:
+  - "samsung,exynos4415-cmu" - for the main system clocks controller
+    (CMU_LEFTBUS, CMU_RIGHTBUS, CMU_TOP, CMU_CPU clock domains).
+  - "samsung,exynos4415-cmu-dmc" - for the Exynos4415 SoC DRAM Memory
+    Controller (DMC) domain clock controller.
+
+- reg: physical base address of the controller and length of memory mapped
+  region.
+
+- #clock-cells: should be 1.
+
+Each clock is assigned an identifier and client nodes can use this identifier
+to specify the clock which they consume.
+
+All available clocks are defined as preprocessor macros in
+dt-bindings/clock/exynos4415.h header and can be used in device
+tree sources.
+
+Example 1: An example of a clock controller node is listed below.
+
+	cmu: clock-controller@10030000 {
+		compatible = "samsung,exynos4415-cmu";
+		reg = <0x10030000 0x18000>;
+		#clock-cells = <1>;
+	};
+
+	cmu-dmc: clock-controller@105C0000 {
+		compatible = "samsung,exynos4415-cmu-dmc";
+		reg = <0x105C0000 0x3000>;
+		#clock-cells = <1>;
+	};
-- 
1.8.5.5

