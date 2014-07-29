Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaG2CRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 22:17:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37045 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbaG2CRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 22:17:18 -0400
X-AuditID: cbfee691-b7f306d000003d81-b4-53d7042c766a
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com
Cc: t.figa@samsung.com, ben-linux@fluff.org, linux@arm.linux.org.uk,
        kyungmin.park@samsung.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 1/3] ARM: dts: Add TMU dt node to monitor the temperature for
 Exynos3250
Date: Tue, 29 Jul 2014 11:17:10 +0900
Message-id: <1406600232-31033-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1406600232-31033-1-git-send-email-cw00.choi@samsung.com>
References: <1406600232-31033-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42JZI2JSoKvDcj3Y4PYBSYtJ6w4wWVz/8pzV
	Yv6Rc6wWvQuuslmcbXrDbrHp8TVWi4VtS1gsLu+aw2Yx4/w+Jovbl3kt1s94zeLA7dHS3MPm
	8XfVC2aPzUvqPfq2rGL0+LxJLoA1issmJTUnsyy1SN8ugSvjyu7ZrAVbOCs65t1jbmB8xt7F
	yMkhIWAi8fjkEVYIW0ziwr31bF2MXBxCAksZJd5c+8gGU/Tm2GVmiMQiRom+G9uZIJwmJonN
	C3aBtbMJaEnsf3EDrENEQFKiqeEPWAezwComiRvHXzCDJIQFoiR6X28C280ioCrx/dVNsAZe
	AVeJ1V1tUHfISXzY8wishlPATaL15kmwXiGgmtNnjrKADJUQ2MQucbbvI9QgAYlvkw8BJTiA
	ErISmw4wQ8yRlDi44gbLBEbhBYwMqxhFUwuSC4qT0otM9YoTc4tL89L1kvNzNzEC4+H0v2cT
	dzDeP2B9iDEZaNxEZinR5HxgPOWVxBsamxlZmJqYGhuZW5qRJqwkzpv+KClISCA9sSQ1OzW1
	ILUovqg0J7X4ECMTB6dUA2M5S3yHh4xRr++Fvc6zY5W5WoxkDz8u1Uus/iO2TVuBYalzQf0b
	IUP9SsPdtn4z7fbMSGRPC5rafIL7sh777b7IykXR1Yk890Rto1QXrDiw7FLTuZwtfUUbn5oH
	by5K3uW+xfZvsratfcDd0CiLd2s+/UzivHe9yEb16heb2CtbD8dynVN/oMRSnJFoqMVcVJwI
	AHzpPsadAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jAV0dluvBBivPC1tMWneAyeL6l+es
	FvOPnGO16F1wlc3ibNMbdotNj6+xWixsW8JicXnXHDaLGef3MVncvsxrsX7GaxYHbo+W5h42
	j7+rXjB7bF5S79G3ZRWjx+dNcgGsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaW
	FuZKCnmJuam2Si4+AbpumTlAlykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkAD
	CWsYM67sns1asIWzomPePeYGxmfsXYycHBICJhJvjl1mhrDFJC7cW8/WxcjFISSwiFGi78Z2
	JginiUli84JdrCBVbAJaEvtf3GADsUUEJCWaGv4wgxQxC6xikrhx/AXYKGGBKIne15vAVrAI
	qEp8f3UTrIFXwFVidVcbK8Q6OYkPex6B1XAKuEm03jwJ1isEVHP6zFGWCYy8CxgZVjGKphYk
	FxQnpeca6hUn5haX5qXrJefnbmIER9szqR2MKxssDjEKcDAq8fBumHstWIg1say4MvcQowQH
	s5II7/wlQCHelMTKqtSi/Pii0pzU4kOMpkBXTWSWEk3OByaCvJJ4Q2MTMyNLI3NDCyNjcyVx
	3gOt1oFCAumJJanZqakFqUUwfUwcnFINjAfzbxyPbT9QKKT/+7Zmbnrc3XbVpxy+jxyDXb+8
	1VNamZgs1n70g3fjxvBgrdCbFcnuokwff/Ftu8A1Y+1dxgtyx31UPvVo2T7ZMiuFzfdN3JfH
	YiKc+dvZfywL/MG1bUt89cLF2S4vesXCKpi65rRs9c4771G2mdnuEXOCZ+hm6fzOY79KlViK
	MxINtZiLihMB7OKui8wCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add TMU (Thermal Management Unit) dt node to monitor the high
temperature for Exynos3250.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
This patch has a dependency on following patch [1] which supporting the TMU
of Exynos3250:
 [1] https://git.kernel.org/cgit/linux/kernel/git/rzhang/linux.git/commit/?h=next&id=1fe56dc16a3dab400206443f70ae158c8f595c42

Changes from v1:
- Remove duplicate 'interrupt-parent' property.

 arch/arm/boot/dts/exynos3250.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 77a06df..41a260a 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -168,6 +168,15 @@
 			status = "disabled";
 		};
 
+		tmu: tmu@100C0000 {
+			compatible = "samsung,exynos3250-tmu";
+			reg = <0x100C0000 0x100>;
+			interrupts = <0 216 0>;
+			clocks = <&cmu CLK_TMU_APBIF>;
+			clock-names = "tmu_apbif";
+			status = "disabled";
+		};
+
 		gic: interrupt-controller@10481000 {
 			compatible = "arm,cortex-a15-gic";
 			#interrupt-cells = <3>;
-- 
1.8.0

