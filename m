Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbaG2CS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 22:18:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64692 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbaG2CRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 22:17:20 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-c6-53d7042dcc5e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com
Cc: t.figa@samsung.com, ben-linux@fluff.org, linux@arm.linux.org.uk,
        kyungmin.park@samsung.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 2/3] ARM: dts: Remove duplicate 'interrput-parent' property for
 Exynos3250
Date: Tue, 29 Jul 2014 11:17:11 +0900
Message-id: <1406600232-31033-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1406600232-31033-1-git-send-email-cw00.choi@samsung.com>
References: <1406600232-31033-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42JZI2JSqKvLcj3Y4NA5QYtJ6w4wWVz/8pzV
	Yv6Rc6wWvQuuslmcbXrDbrHp8TVWi4VtS1gsLu+aw2Yx4/w+Jovbl3kt1s94zeLA7dHS3MPm
	8XfVC2aPzUvqPfq2rGL0+LxJLoA1issmJTUnsyy1SN8ugSvjy/ktjAV9HBV/myaxNzCeYeti
	5OCQEDCReLDMrIuRE8gUk7hwbz1QmItDSGApo8SRqyuYIBImEs8Ob2WHSCxilHh6fhczhNPE
	JLF5wS5WkCo2AS2J/S9usIHYIgKSEk0Nf8CKmAVWMUncOP6CGSQhLBAjMe/lDrCxLAKqEus3
	XGIFOYNXwFVi0bMkiG1yEh/2PGIHsTkF3CRab54EaxUCKjl95igLyEwJgU3sEtsP3GCEmCMg
	8W3yIRaId2QlNh1ghpgjKXFwxQ2WCYzCCxgZVjGKphYkFxQnpRcZ6hUn5haX5qXrJefnbmIE
	xsLpf896dzDePmB9iDEZaNxEZinR5HxgLOWVxBsamxlZmJqYGhuZW5qRJqwkzpv0MClISCA9
	sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+M5ITGFS75rohftl5l61Mz7r/+pakebDc+uvpibui0j
	/31q+BnzA03mT44c2ZV8eOoBxuiYV+6RO7ty17PvjHi0+ZD88fbIiu3Rux93JGRnzd2YNMvj
	TTovi01yTZPEvnfxklffivjfXq712uXhu8JnhQ8X7FIXmf3mrf30P1auL92fH+16fPOKEktx
	RqKhFnNRcSIADU9nSpsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jAV1dluvBBi+mcFpMWneAyeL6l+es
	FvOPnGO16F1wlc3ibNMbdotNj6+xWixsW8JicXnXHDaLGef3MVncvsxrsX7GaxYHbo+W5h42
	j7+rXjB7bF5S79G3ZRWjx+dNcgGsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaW
	FuZKCnmJuam2Si4+AbpumTlAlykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkAD
	CWsYM76c38JY0MdR8bdpEnsD4xm2LkZODgkBE4lnh7eyQ9hiEhfurQeKc3EICSxilHh6fhcz
	hNPEJLF5wS5WkCo2AS2J/S9ugHWLCEhKNDX8AStiFljFJHHj+AtmkISwQIzEvJc7mEBsFgFV
	ifUbLgE1c3DwCrhKLHqWBLFNTuLDnkdgmzkF3CRab54EaxUCKjl95ijLBEbeBYwMqxhFUwuS
	C4qT0nMN9YoTc4tL89L1kvNzNzGCY+2Z1A7GlQ0WhxgFOBiVeHg3zL0WLMSaWFZcmXuIUYKD
	WUmEd/4SoBBvSmJlVWpRfnxRaU5q8SFGU6CjJjJLiSbnA9NAXkm8obGJmZGlkbmhhZGxuZI4
	74FW60AhgfTEktTs1NSC1CKYPiYOTqkGxulX9v88b317WuBF6XsFkhMnui3mCRNYo8PRb8DV
	HuW/8LPmFZ8biWH7MirXKCrEacS0FskXp7ZWmO6aYjLNcu1x2T3xiWL+zH/WGZz0fPTqUoKZ
	nkDO8gN1DyfIykf+fOcS8qto5TfOqmaXXzJRj48UnmxrUXb327tPQyTuaqeP5Y8JDspTlFiK
	MxINtZiLihMB68NNhcsCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes duplicat 'interrupt-parent' property for Exynos3250
because exynos3250.dtsi already defined 'interrupt-parent' property
as following:

In arch/arm/boot/dts/exynos3250.dtsi:

	compatible = "samsung,exynos3250";
	interrupt-parent = <&gic>;

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 41a260a..5043178 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -204,7 +204,6 @@
 
 			wakeup-interrupt-controller {
 				compatible = "samsung,exynos4210-wakeup-eint";
-				interrupt-parent = <&gic>;
 				interrupts = <0 48 0>;
 			};
 		};
@@ -243,7 +242,6 @@
 			compatible = "arm,amba-bus";
 			#address-cells = <1>;
 			#size-cells = <1>;
-			interrupt-parent = <&gic>;
 			ranges;
 
 			pdma0: pdma@12680000 {
-- 
1.8.0

