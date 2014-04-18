Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaDRBQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 21:16:57 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53777 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaDRBPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 21:15:32 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-f2-53507cb20410
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, ben-linux@fluff.org, kgene.kim@samsung.com,
        t.figa@samsung.com, arnd@arndb.de, olof@lixom.net,
        marc.zyngier@arm.com, thomas.abraham@linaro.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, sajjan.linux@gmail.com,
        tushar.behera@linaro.org, sachin.kamat@linaro.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCHv3 6/7] dt-bindings: add documentation for Exynos3250 clock
 controller
Date: Fri, 18 Apr 2014 10:15:27 +0900
Message-id: <1397783728-6193-7-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397783728-6193-1-git-send-email-cw00.choi@samsung.com>
References: <1397783728-6193-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42JZI2JSqLupJiDYYMUhLYu/k46xW0xad4DJ
	4vJ+bYvrX56zWsw/co7Vov/NQlaLzx9a2C3OvVrJaNG74CqbxdmmN+wWmx5fY7W4vGsOm8WM
	8/uYLG5f5rX4e+cfm8XS6xeZLJ5OuMhmcer6ZzaLCdPXsli8vTOdxaJ17xF2i5N/ehktnhz+
	yGoxY/JLNov1M16zWBybsYTRov3vXjaLvTsnMzrIeKyZt4bRo6W5h83j969JjB6X+3qZPP6u
	esHssXPWXXaPlcu/sHlsXqHlsWlVJ5vHnWt7gLwl9R5XTjSxevRtWcXo8XmTXABfFJdNSmpO
	Zllqkb5dAldG94SfrAXzRCrmLprO3sDYIdjFyMkhIWAi0dP8gBXCFpO4cG89WxcjF4eQwFJG
	iVNrb7LBFD2Yew0qsYhR4s2D56wQThOTxOoHs8Gq2AS0JPa/uAFmiwgoSGzufQZWxCzQySZx
	/vtFsISwQLjE3Et/mUBsFgFVif1vXoDZvAIuElvn/GaEWCcn8WHPI3YQm1PAVeL84yMsILYQ
	UM3D79NZQIZKCHzgkFi+7jY7xCABiW+TDwElOIASshKbDjBDzJGUOLjiBssERuEFjAyrGEVT
	C5ILipPSiwz1ihNzi0vz0vWS83M3MQLTwel/z3p3MN4+YH2IMRlo3ERmKdHkfGA6ySuJNzQ2
	M7IwNTE1NjK3NCNNWEmcN+lhUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRkaFWwfljLR6
	NDazKUv+mZzd9+JRyIuz+k9jZv27xxuzv3i58SYhuewtocVFHrk9uV7dv9ctenpqwqzFOUsT
	t1TJN0tuFij5UebNXfi//1p5ya+oL2dXxMYvtF6qwqXt2MnJXyGdpdA6s/uCgPTZHUw1bw9k
	Ojro7L9/osbbt07tk13TxX3lSizFGYmGWsxFxYkAX615sh0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOKsWRmVeSWpSXmKPExsVy+t9jAd1NNQHBBi8uKFj8nXSM3WLSugNM
	Fpf3a1tc//Kc1WL+kXOsFv1vFrJafP7Qwm5x7tVKRoveBVfZLM42vWG32PT4GqvF5V1z2Cxm
	nN/HZHH7Mq/F3zv/2CyWXr/IZPF0wkU2i1PXP7NZTJi+lsXi7Z3pLBate4+wW5z808to8eTw
	R1aLGZNfslmsn/GaxeLYjCWMFu1/97JZ7N05mdFBxmPNvDWMHi3NPWwev39NYvS43NfL5PF3
	1Qtmj52z7rJ7rFz+hc1j8wotj02rOtk87lzbA+Qtqfe4cqKJ1aNvyypGj8+b5AL4ohoYbTJS
	E1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAIaOkUJaYUwoU
	CkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzOie8JO1YJ5IxdxF09kbGDsEuxg5OSQE
	TCQezL3GBmGLSVy4tx7I5uIQEljEKPHmwXNWCKeJSWL1g9lgVWwCWhL7X9wAs0UEFCQ29z4D
	K2IW6GSTOP/9IlhCWCBcYu6lv0wgNouAqsT+Ny/AbF4BF4mtc34zQqyTk/iw5xE7iM0p4Cpx
	/vERFhBbCKjm4ffpLBMYeRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECE42z6R3MK5q
	sDjEKMDBqMTDe+Grf7AQa2JZcWXuIUYJDmYlEV7l0oBgId6UxMqq1KL8+KLSnNTiQ4zJQFdN
	ZJYSTc4HJsK8knhDYxMzI0sjc0MLI2Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamBU
	ld1lZulcptC1vEipjkGVjZNv3ymV4AV2nQd3a7yakWSiyiz+RlhetZD5UvxKXZnnPj++NnN8
	tIpOYG5qXXzz6L1lN1v/8QZtPzCzvfZ1oMgmazXZ/MKUP9e2Tlvks7XgxovylxJV/t13HghO
	fRT88t307Tn5Nae6bu9p1hKcNyOyQ+6JWqoSS3FGoqEWc1FxIgC6OeryegMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Exynos3250 clocks are statically listed and registered using the
Samsung specific common clock helper functions. Both device tree based
clock lookup and clkdev based clock lookups are supported.

Cc: Mike Turquette <mturquette@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/clock/exynos3250-clock.txt | 41 ++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos3250-clock.txt

diff --git a/Documentation/devicetree/bindings/clock/exynos3250-clock.txt b/Documentation/devicetree/bindings/clock/exynos3250-clock.txt
new file mode 100644
index 0000000..aadc9c5
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/exynos3250-clock.txt
@@ -0,0 +1,41 @@
+* Samsung Exynos3250 Clock Controller
+
+The Exynos3250 clock controller generates and supplies clock to various
+controllers within the Exynos3250 SoC.
+
+Required Properties:
+
+- compatible: should be one of the following.
+  - "samsung,exynos3250-cmu" - controller compatible with Exynos3250 SoC.
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
+dt-bindings/clock/exynos3250.h header and can be used in device
+tree sources.
+
+Example 1: An example of a clock controller node is listed below.
+
+	cmu: clock-controller@10030000 {
+		compatible = "samsung,exynos3250-cmu";
+		reg = <0x10030000 0x20000>;
+		#clock-cells = <1>;
+	};
+
+Example 2: UART controller node that consumes the clock generated by the clock
+	   controller. Refer to the standard clock bindings for information
+	   about 'clocks' and 'clock-names' property.
+
+	serial@13800000 {
+		compatible = "samsung,exynos4210-uart";
+		reg = <0x13800000 0x100>;
+		interrupts = <0 109 0>;
+		clocks = <&cmu CLK_UART0>, <&cmu CLK_SCLK_UART0>;
+		clock-names = "uart", "clk_uart_baud0";
+	};
-- 
1.8.0

