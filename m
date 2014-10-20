Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaJTDcn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 23:32:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34105 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbaJTDch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 23:32:37 -0400
X-AuditID: cbfee691-f79b86d000004a5a-35-544482501db5
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, ben-linux@fluff.org, linux@arm.linux.org.uk,
        mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net,
        tomasz.figa@gmail.com, mturquette@linaro.org,
        thomas.abraham@linaro.org, linus.walleij@linaro.org,
        sw0312.kim@samsung.com, kyungmin.park@samsung.com,
        inki.dae@samsung.com, geunsik.lim@samsung.com, jh80.chung@samsung.com,
        cw00.choi@samsung.com, jaewon02.kim@samsung.com,
        ideal.song@samsung.com, yj44.cho@samsung.com,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3/5] clk: samsung: Document binding for Exynos4415 clock
 controller
Date: Mon, 20 Oct 2014 12:32:13 +0900
Message-id: <1413775935-17743-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1413775749-17539-1-git-send-email-cw00.choi@samsung.com>
References: <1413775749-17539-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsWyRsSkUDewySXEoHkXm8XfScfYLSatO8Bk
	cf3Lc1aLPxNa2Sx2/b3PaDHp/gQWix0NR1gtbvxqY7XoXXCVzeJs0xt2iyl/ljNZbHp8jdXi
	8q45bBYzzu9jsrh9mddi6fWLTBZPJ1xkszh1/TObxeE37awWMya/ZLM4NmMJo8WqXX8YLfbu
	nMzoIO6xZt4aRo+W5h42j9+/JjF6/F31gtlj56y77B53ru1h89i8pN7jyokmVo++LasYPT5v
	kgvgiuKySUnNySxLLdK3S+DKOPnjG0vBJ+GKnoOiDYwXBboYOTkkBEwklv05zQxhi0lcuLee
	rYuRi0NIYCmjxLW9L5lhirb8nckIkZjOKNGxsYEdwmlikjj56i0bSBWbgJbE/hc3wGwRgWyJ
	K433mUGKmAU+MEv03HrNApIQFgiVOPphHZjNIqAq0fN8CVgDr4CrxPH+pWwQ6+QkPux5xA5i
	cwq4SRzu+s/UxcgBtM1VYsZmVZCZEgJbOCQ+PtgANUdA4tvkQywgNRICshKbDkBdLSlxcMUN
	lgmMwgsYGVYxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn525iBEbt6X/PJu5gvH/A+hCjAAejEg/v
	DjOXECHWxLLiytxDjKZAGyYyS4km5wNTQ15JvKGxmZGFqYmpsZG5pZmSOK+O9M9gIYH0xJLU
	7NTUgtSi+KLSnNTiQ4xMHJxSDYyF1gUGPKX3l3XM2D6hz3b6BjfF8JwX91csnhtgKJB7IT7/
	vf3Wj7Jdd20SNwTNYPr4SOPeIzHBQwcXFyr87v14QHTiReMfldu+C4aciDX6eFzNL2t5lLOq
	ws/JhwxWuGh1bDo7c6uuT3bwGxWxBO7KT0Vme+cImgvMWKsYpvxht5qy+KPv868osRRnJBpq
	MRcVJwIAPJ2wM9UCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xoG5Ak0uIwfLdlhZ/Jx1jt5i07gCT
	xfUvz1kt/kxoZbPY9fc+o8Wk+xNYLHY0HGG1uPGrjdWid8FVNouzTW/YLab8Wc5ksenxNVaL
	y7vmsFnMOL+PyeL2ZV6LpdcvMlk8nXCRzeLU9c9sFofftLNazJj8ks3i2IwljBardv1htNi7
	czKjg7jHmnlrGD1amnvYPH7/msTo8XfVC2aPnbPusnvcubaHzWPzknqPKyeaWD36tqxi9Pi8
	SS6AK6qB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH
	6F0lhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8bJH99YCj4JV/QcFG1g
	vCjQxcjJISFgIrHl70xGCFtM4sK99WxdjFwcQgLTGSU6NjawQzhNTBInX71lA6liE9CS2P/i
	BpgtIpAtcaXxPjNIEbPAB2aJnluvWUASwgKhEkc/rAOzWQRUJXqeLwFr4BVwlTjev5QNYp2c
	xIc9j9hBbE4BN4nDXf+Zuhg5gLa5SszYrDqBkXcBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k
	/NxNjOCU8ExqB+PKBotDjAIcjEo8vDvMXEKEWBPLiitzDzFKcDArifD+ywAK8aYkVlalFuXH
	F5XmpBYfYjQFOmois5Rocj4wXeWVxBsam5gZWRqZG1oYGZsrifMeaLUOFBJITyxJzU5NLUgt
	gulj4uCUamBcf7zvatdTKTXRuq7idxpJvL0JT/4UpspEln6N5ms45aa6cd9129yIU+/Ms5hP
	3o74Yjbr7uayZsPFEz/KWrP9U1pZ/jJCRmjOUubDx8Or2SOy571+2nQp647T5zy7jAu7ptnd
	adv9N0c7hOerwcVatmk/+S+5zF4p6vNKzDRo3f0LbNavjggpsRRnJBpqMRcVJwIAtyWz0h8D	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Exynos4415 clocks are statically listed and registered using the
Samsung specific common clock helper functions. Both device tree based
clock lookup and clkdev based clock lookups are supported.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/clock/exynos4415-clock.txt | 49 ++++++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos4415-clock.txt

diff --git a/Documentation/devicetree/bindings/clock/exynos4415-clock.txt b/Documentation/devicetree/bindings/clock/exynos4415-clock.txt
new file mode 100644
index 0000000..8aa4f4f
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/exynos4415-clock.txt
@@ -0,0 +1,49 @@
+* Samsung Exynos4415 Clock Controller
+
+The Exynos4415 clock controller generates and supplies clock to various
+controllers within the Exynos4415 SoC.
+
+Required Properties:
+
+- compatible: should be one of the following.
+  - "samsung,exynos4415-cmu" - controller compatible with Exynos4415 SoC.
+  - "samsung,exynos4415-cmu-dmc" - controller compatible with
+    Exynos4415 SoC for Dynamic Memory Controller domain.
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
+
+Example 2: UART controller node that consumes the clock generated by the clock
+	   controller. Refer to the standard clock bindings for information
+	   about 'clocks' and 'clock-names' property.
+
+	serial_0: serial@13800000 {
+		compatible = "samsung,exynos4210-uart";
+		reg = <0x13800000 0x100>;
+		interrupts = <0 109 0>;
+		clocks = <&cmu CLK_UART0>, <&cmu CLK_SCLK_UART0>;
+		clock-names = "uart", "clk_uart_baud0";
+	};
-- 
1.8.0

