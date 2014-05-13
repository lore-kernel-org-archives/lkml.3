Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461AbaEMNHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:07:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20452 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933328AbaEMNGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:06:39 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-fd-537218dce71e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, ben-linux@fluff.org,
        arnd@arndb.de, olof@lixom.net, marc.zyngier@arm.com,
        thomas.abraham@linaro.org, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        hyunhee.kim@samsung.com, yj44.cho@samsung.com,
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
Subject: [PATCHv5 4/5] dt-bindings: add documentation for Exynos3250 clock
 controller
Date: Tue, 13 May 2014 22:05:07 +0900
Message-id: <1399986308-23744-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1399986308-23744-1-git-send-email-cw00.choi@samsung.com>
References: <1399986308-23744-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42JZI2JSpHtHoijYYOYeJYu/k46xW0xad4DJ
	4vJ+bYvrX56zWsw/co7Vov/NQlaLzx9a2C3OvVrJaDHp/gQWi94FV9kszja9YbfY9Pgaq8Xl
	XXPYLGac38dkcfsyr8XfO//YLJZev8hk8XTCRTaLU9c/s1lMmL6WxeLtneksFq17j7BbnPzT
	y2jx5PBHVosZk1+yWayf8ZrF4tiMJYwW7X/3slns3TmZ0UHWY828NYweLc09bB6/f01i9Ljc
	18vk8XfVC2aPnbPusnusXP6FzWPzCi2PTas62TzuXNsD5C2p97hyoonVo2/LKkaPz5vkAvii
	uGxSUnMyy1KL9O0SuDKm9D1kKZgnUnGuq5e1gbFDsIuRk0NCwETixfIL7BC2mMSFe+vZuhi5
	OIQEljJKrJ64hAmmaO/PqcwQiUWMEls6LjBBOE1MEsc3XgWrYhPQktj/4gYbiC0ioCsxZeYd
	VpAiZoEpbBIft+5jBUkIC4RLrLjYxAxiswioStz7eRbM5hVwldi9eTILxDo5iQ97HoHdxCng
	JvHrdguYLQRUs+zsXbDNEgI/OCQ6vu5mhBgkIPFt8iGgZg6ghKzEpgPMEHMkJQ6uuMEygVF4
	ASPDKkbR1ILkguKk9CJDveLE3OLSvHS95PzcTYzAxHD637PeHYy3D1gfYkwGGjeRWUo0OR+Y
	WPJK4g2NzYwsTE1MjY3MLc1IE1YS5016mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgZHD
	4030tZdrKo5s6/ov4dB02Wf/1VOHtJTWvQrtV3vUf++tdl6LYmz3NrYLERfW/niaOTtnjeaq
	H28erXwt/i/+f/43wzk9HO/yLsf/Mrtd/eFmsYJhVbNYNNeTRU8YTp+JN5w1ie1q+G5b96zK
	qWlFGyNKtm1l/n9txbyXeqZbLHgX6l798n6ZEktxRqKhFnNRcSIAMy6nnSIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDKsWRmVeSWpSXmKPExsVy+t9jAd07EkXBBndXSlj8nXSM3WLSugNM
	Fpf3a1tc//Kc1WL+kXOsFv1vFrJafP7Qwm5x7tVKRotJ9yewWPQuuMpmcbbpDbvFpsfXWC0u
	75rDZjHj/D4mi9uXeS3+3vnHZrH0+kUmi6cTLrJZnLr+mc1iwvS1LBZv70xnsWjde4Td4uSf
	XkaLJ4c/slrMmPySzWL9jNcsFsdmLGG0aP+7l81i787JjA6yHmvmrWH0aGnuYfP4/WsSo8fl
	vl4mj7+rXjB77Jx1l91j5fIvbB6bV2h5bFrVyeZx59oeIG9JvceVE02sHn1bVjF6fN4kF8AX
	1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQMMHiWF
	ssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxpS+hywF80QqznX1sjYwdgh2
	MXJySAiYSOz9OZUZwhaTuHBvPVsXIxeHkMAiRoktHReYIJwmJonjG68ygVSxCWhJ7H9xgw3E
	FhHQlZgy8w4rSBGzwBQ2iY9b97GCJIQFwiVWXGwCG8sioCpx7+dZMJtXwFVi9+bJLBDr5CQ+
	7HnEDmJzCrhJ/LrdAmYLAdUsO3uXaQIj7wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsY
	wWnnmdQOxpUNFocYBTgYlXh4fxoXBguxJpYVV+YeYpTgYFYS4XX/BBTiTUmsrEotyo8vKs1J
	LT7EmAx01URmKdHkfGBKzCuJNzQ2MTOyNDI3tDAyNidNWEmc90CrdaCQQHpiSWp2ampBahHM
	FiYOTqkGxuxoqyNKCU9ynN92v/F9Hq1ZoRwVkq18JLdTaeIHTssUl/BjMx9zJs96FMpVt0fB
	svdKX8Nk36P8j30VDFvFtyZUeoWtPFfzpEyzN2Kj/40vs+8u5XqmvP6BknojP5embnTJNI+O
	xptTH/en50701ov70bnur1t7/4/4+G3iRyus90j8kchVYinOSDTUYi4qTgQA3LAM/X8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Exynos3250 clocks are statically listed and registered using the
Samsung specific common clock helper functions. Both device tree based
clock lookup and clkdev based clock lookups are supported.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Tomasz Figa <t.figa@samsung.com>
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

