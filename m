Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009AbaCQMDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 08:03:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28205 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792AbaCQMDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 08:03:02 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-0e-5326e475973b
From: Girish K S <ks.giri@samsung.com>
To: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: jassisinghbrar@gmail.com, s-anna@ti.com, ilho215.lee@samsung.com,
        Girish K S <ks.giri@samsung.com>
Subject: [PATCH 2/2] arm64: dts: exynos: added mailbox node
Date: Mon, 17 Mar 2014 17:33:59 +0530
Message-id: <1395057839-23871-3-git-send-email-ks.giri@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1395057839-23871-1-git-send-email-ks.giri@samsung.com>
References: <1395057839-23871-1-git-send-email-ks.giri@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsWyRsSkWrf0iVqwwdRFYhbzj5xjtTj6byGj
	xbUVc9kt5h/dwWSx6fE1VovLu+awWez9tY/Vgd1j56y77B6bl9R79G1Zxehx/MZ2Jo/Pm+QC
	WKO4bFJSczLLUov07RK4Mv7OXcxcsEi+4uJe1gbGaZJdjJwcEgImErNWPGaEsMUkLtxbz9bF
	yMUhJLCUUaJ702w2mKLOub/ZIRKLGCW+7XkAlhAS6GCSmDA7FsRmE1CT2LjuPjuILSKQIjHr
	/SIWEJtZIEPi/6FlYBuEBawlFl5YxgRiswioShzfsRKsnlfAWaLn7AFmiGWKEt3PJoDN5xRw
	kZh3YidQnANol7PEgpUaIDdICMxjl1gxbzoLxBwBiW+TD7GA1EgIyEpsghkjKXFwxQ2WCYzC
	CxgZVjGKphYkFxQnpRcZ6hUn5haX5qXrJefnbmIEBvjpf896dzDePmB9iDEZaNxEZinR5Hxg
	hOSVxBsamxlZmJqYGhuZW5qRJqwkzpv0MClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUAyNv
	n1CfFuMazgcCUUtuvDtVnC34P1GaJ+bkjrNRNzlOJ9o75z+R5Y1RaeRbPS/O/cHexpef+U6W
	LH9ScXgig8yka/M0BHe1/3p31fTa+vfH9t+20Ij7GBD2J2UeU8v9RIPSyX3ZDncPODDnv+OT
	4d9bHteUtKfateDhNX3+idWefvcSmf+rRimxFGckGmoxFxUnAgARFnKihgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t9jAd3SJ2rBBtO28VrMP3KO1eLov4WM
	FtdWzGW3mH90B5PFpsfXWC0u75rDZrH31z5WB3aPnbPusntsXlLv0bdlFaPH8RvbmTw+b5IL
	YI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMATpD
	SaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jxd+5i5oJF8hUX97I2ME6T
	7GLk5JAQMJHonPubHcIWk7hwbz1bFyMXh5DAIkaJb3sesIEkhAQ6mCQmzI4FsdkE1CQ2rrsP
	1iAikCIx6/0iFhCbWSBD4v+hZYwgtrCAtcTCC8uYQGwWAVWJ4ztWgtXzCjhL9Jw9wAyxTFGi
	+9kEsPmcAi4S807sBIpzAO1ylliwUmMCI+8CRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmb
	GMHx80xqB+PKBotDjAIcjEo8vBOU1YKFWBPLiitzDzFKcDArifCmXQMK8aYkVlalFuXHF5Xm
	pBYfYkwGOmois5Rocj4wtvNK4g2NTcxNjU0tTSxMzCxJE1YS5z3Qah0oJJCeWJKanZpakFoE
	s4WJg1OqgbEyzy7+2K8/FxdGb7RbX6G9tCbfY8V3Y5Gbdsncr9J1el71X9INZjg/17lZ8+yF
	v7xfmCquqHWsS99iUXQwLzJc2Hvfrn8GT/OceFsU3GwPvF5wxoFz96pvJQvyfDU/ZRU5yqdw
	ffqrdTrHf8ahl7tPfjEs/r7J2+HAJpHnK+PuHD/0Nb12vYASS3FGoqEWc1FxIgBrSTX74wIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the dt node for the mailbox IP

Signed-off-by: Girish K S <ks.giri@samsung.com>

Change-Id: I35e45e9a62592887a84a909aee54f259a2f731fa
---
 .../bindings/mailbox/samsung-mailbox.txt           |   24 +++++++
 arch/arm64/boot/dts/samsung-gh7.dtsi               |   66 ++++++++++++++++++++
 arch/arm64/boot/dts/samsung-ssdk-gh7.dts           |    3 +
 3 files changed, 93 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mailbox/samsung-mailbox.txt

diff --git a/Documentation/devicetree/bindings/mailbox/samsung-mailbox.txt b/Documentation/devicetree/bindings/mailbox/samsung-mailbox.txt
new file mode 100644
index 0000000..1908d71
--- /dev/null
+++ b/Documentation/devicetree/bindings/mailbox/samsung-mailbox.txt
@@ -0,0 +1,24 @@
+
+Samsung Mailbox Driver
+
+Required properties:
+- compatible:		Should be one of the following,
+			    "samsung,gh7-mailbox" for
+				Samsung GH7 SoC series
+			    "samsung,exynos-mailbox" for
+				exynosx SoC series
+- reg:			Contains the mailbox register address range (base address
+			and length)
+- interrupts: 		Contains the interrupt information for the mailbox
+			device.
+- samsung,mbox-names:	Array of the names of the mailboxes
+
+Example:
+
+/* Samsung GH7 SoC */
+mailbox@100a0000 {
+	compatible = "samsung,gh7-mailbox";
+	reg = <0x0 0x100a0000 0x0 0x1000>;
+	interrupts = <0 310 0>;
+	samsung,mbox-names = "a7q-scp";
+};
diff --git a/arch/arm64/boot/dts/samsung-gh7.dtsi b/arch/arm64/boot/dts/samsung-gh7.dtsi
index c3610bd..be4cce9 100644
--- a/arch/arm64/boot/dts/samsung-gh7.dtsi
+++ b/arch/arm64/boot/dts/samsung-gh7.dtsi
@@ -107,5 +107,71 @@
 			interrupts = <0 420 0>;
 			arm,primecell-periphid = <0x341011>; /* HACK */
 		};
+
+	};
+
+	mailbox@100a0000 {
+		compatible = "samsung,gh7-mailbox";
+		reg = <0x0 0x100a0000 0x0 0x1000>;
+		interrupts = <0 310 0>;
+		samsung,mbox-names = "a7q-scp";
+		status = "disabled";
+	};
+
+	mailbox@24100000 {
+		compatible = "samsung,exynos-mailbox";
+		reg = 	< 0x0 0x24100000 0x0 0x10000>;
+		interrupts = <0 251 0>;
+		samsung,mbox-names = "ncp-a7q-0";
+		status = "disabled";
+	};
+	mailbox@24110000 {
+		compatible = "samsung,exynos-mailbox";
+		reg = 	<0x0 0x24110000 0x0 0x10000>;
+		interrupts = <0 252 0>;
+		samsung,mbox-names = "ncp-a7q-1";
+		status = "disabled";
+	};
+	mailbox@24120000 {
+		compatible = "samsung,exynos-mailbox";
+		reg = 	<0x0 0x24120000 0x0 0x10000>;
+		interrupts = <0 253 0>;
+		samsung,mbox-names = "ncp-a7q-2";
+		status = "disabled";
+	};
+	mailbox@24130000 {
+		compatible = "samsung,exynos-mailbox";
+		reg = 	<0x0 0x24130000 0x0 0x10000>;
+		interrupts = <0 254 0>;
+		samsung,mbox-names = "ncp-a7q-3";
+		status = "disabled";
+	};
+	mailbox@24140000 {
+		compatible = "samsung,exynos-mailbox";
+		reg = 	<0x0 0x24140000 0x0 0x10000>;
+		interrupts = <0 255 0>;
+		samsung,mbox-names = "ncp-a7q-4";
+		status = "disabled";
+	};
+	mailbox@24150000 {
+		compatible = "samsung,exynos-mailbox";
+		reg = 	<0x0 0x24150000 0x0 0x10000>;
+		interrupts = <0 256 0>;
+		samsung,mbox-names = "ncp-a7q-5";
+		status = "disabled";
+	};
+	mailbox@24160000 {
+		compatible = "samsung,exynos-mailbox";
+		reg = 	<0x0 0x24160000 0x0 0x10000>;
+		interrupts = <0 257 0>;
+		samsung,mbox-names = "ncp-a7q-6";
+		status = "disabled";
+	};
+	mailbox@24170000 {
+		compatible = "samsung,exynos-mailbox";
+		reg = 	<0x0 0x24170000 0x0 0x10000>;
+		interrupts = <0 258 0>;
+		samsung,mbox-names = "ncp-a7q-7";
+		status = "disabled";
 	};
 };
diff --git a/arch/arm64/boot/dts/samsung-ssdk-gh7.dts b/arch/arm64/boot/dts/samsung-ssdk-gh7.dts
index 4ce7d67..bfe5455 100644
--- a/arch/arm64/boot/dts/samsung-ssdk-gh7.dts
+++ b/arch/arm64/boot/dts/samsung-ssdk-gh7.dts
@@ -23,4 +23,7 @@
 		device_type = "memory";
 		reg = <0x00000000 0x80000000 0 0x20000000>;
 	};
+	mailbox@100a0000 {
+		status = "okay";
+	};
 };
-- 
1.7.10.4

