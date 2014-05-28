Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbaE1Jj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:39:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:50728 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbaE1Jjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:39:52 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-a4-5385aee58460
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 4/4] dt-bindings: extcon: Add support for SM5502 MUIC device
Date: Wed, 28 May 2014 18:39:36 +0900
Message-id: <1401269976-12754-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1401269976-12754-1-git-send-email-cw00.choi@samsung.com>
References: <1401269976-12754-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsWyRsSkRPfputZgg8bHphbXvzxntZh/5Byr
	Rf+bhawW516tZLQ42/SG3WJh2xIWi8u75rBZLL1+kcniduMKNosJ09eyWLy9M53FonXvEXYH
	Ho8189Ywelzu62XyWLn8C5vH5hVaHptWdbJ59G1ZxejxeZNcAHsUl01Kak5mWWqRvl0CV8a5
	zuksBWv5K853b2FtYGzn7WLk5JAQMJF4seEAK4QtJnHh3nq2LkYuDiGBpYwS7yY9YoMpmtK3
	jgkiMZ1R4vC+vywQThOTxIv1HewgVWwCWhL7X9wA6xARUJDY3PuMFaSIWeAvk8Sj/uNgO4QF
	fCT2rL8ANIqDg0VAVWLC1HSQMK+Aq8SBT18ZIbbJSXzY8whsJqeAm8SMGYfBZgoB1Sw/chDs
	CgmBS+wShzbdAUuwCAhIfJt8iAVkpoSArMSmA8wQcyQlDq64wTKBUXgBI8MqRtHUguSC4qT0
	IlO94sTc4tK8dL3k/NxNjMBoOf3v2cQdjPcPWB9iTAYaN5FZSjQ5HxhteSXxhsZmRhamJqbG
	RuaWZqQJK4nzpj9KChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAaJPGO+VA8ZxUFqcU6fuz
	ngW4nL3Z+O1kU2BUdAbD4upd7adthdaauGlJJ77bM/djm+QyN78HfF5pPxhu3DbreuxeKSmb
	erhxfaZ0Kdvevbv5L/JnLr3xyPtTcG/d6lX/b6udFO76IOBal6zOJM9SPTX+tkwS55MdrRHf
	J6eIbT/CanPo+4Q0JZbijERDLeai4kQA+LzySKwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t9jQd2n61qDDa680rG4/uU5q8X8I+dY
	LfrfLGS1OPdqJaPF2aY37BYL25awWFzeNYfNYun1i0wWtxtXsFlMmL6WxeLtneksFq17j7A7
	8HismbeG0eNyXy+Tx8rlX9g8Nq/Q8ti0qpPNo2/LKkaPz5vkAtijGhhtMlITU1KLFFLzkvNT
	MvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4AuVVIoS8wpBQoFJBYXK+nbYZoQ
	GuKmawHTGKHrGxIE12NkgAYS1jBmnOuczlKwlr/ifPcW1gbGdt4uRk4OCQETiSl965ggbDGJ
	C/fWs3UxcnEICUxnlDi87y8LhNPEJPFifQc7SBWbgJbE/hc32EBsEQEFic29z1hBipgF/jJJ
	POo/zgqSEBbwkdiz/gLQWA4OFgFViQlT00HCvAKuEgc+fWWE2CYn8WHPI7CZnAJuEjNmHAab
	KQRUs/zIQaYJjLwLGBlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgTH4jOpHYwrGywOMQpw
	MCrx8B5Y3BIsxJpYVlyZe4hRgoNZSYTXaWlrsBBvSmJlVWpRfnxRaU5q8SHGZKCjJjJLiSbn
	A9NEXkm8obGJmZGlkbmhhZGxOWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwNuTZPX64
	Ry5jS6yJvsaJ9KVuT43m8a2ePi+0ZMmCfPeWWzVZl34X3v3fxFoXs8Xnb6M4I9/JrCvP/hfL
	61l23ghs/rriRkrIY82gbYZK9jc9mXdKfs7hl19ev8YtTs/8aO6vTe8+TXUX81um07tWzH9C
	udCxjhWMYnIJpcxzz9noMVcnMsYrsRRnJBpqMRcVJwIA1TxIFAkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add documentation for binding of SM5502 MUIC (Micro-USB Interface
Controller) device which is using EXTCON subsystem. The SM5502 MUIC device
can detect various external accessories when external accessories is attached
or detached.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org

---
 .../devicetree/bindings/extcon/extcon-sm5502.txt   | 23 ++++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-sm5502.txt

diff --git a/Documentation/devicetree/bindings/extcon/extcon-sm5502.txt b/Documentation/devicetree/bindings/extcon/extcon-sm5502.txt
new file mode 100644
index 0000000..4ecda22
--- /dev/null
+++ b/Documentation/devicetree/bindings/extcon/extcon-sm5502.txt
@@ -0,0 +1,23 @@
+
+* SM5502 MUIC (Micro-USB Interface Controller) device
+
+The Silicon Mitus SM5502 is a MUIC (Micro-USB Interface Controller) device
+which can detect the state of external accessory when external accessory is
+attached or detached and button is pressed or released. It is interfaced to
+the host controller using an I2C interface.
+
+Required properties:
+- compatible: Should be "siliconmitus,sm5502-muic"
+- reg: Specifies the I2C slave address of the MUIC block. It should be 0x25
+- interrupt-parent: Specifies the phandle of the interrupt controller to which
+  the interrupts from sm5502 are delivered to.
+- interrupts: Interrupt specifiers for detection interrupt sources.
+
+Example:
+
+	sm5502@25 {
+		compatible = "siliconmitus,sm5502-muic";
+		interrupt-parent = <&gpx1>;
+		interrupts = <5 0>;
+		reg = <0x25>;
+	};
-- 
1.8.0

