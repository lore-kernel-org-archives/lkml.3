Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782AbaFZMWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 08:22:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:49376 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757493AbaFZMWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 08:22:46 -0400
X-AuditID: cbfee68f-b7fef6d000003970-c7-53ac10930d46
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, cpgs@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 1/3] ARM: DTS: use new compatible string for thermistors in
 trats2
Date: Thu, 26 Jun 2014 17:49:06 +0530
Message-id: <1403785148-20792-2-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1403785148-20792-1-git-send-email-ch.naveen@samsung.com>
References: <1403785148-20792-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkTneywJpggzn/jCxeHtK0uP7lOavF
	/CPnWC3OLjvIZtG8eD2bxbwj71gsLu+aw2Yx4/w+JotF2/4zO3B6zG64yOKxc9Zddo/9c9ew
	e/RtWcXo8XmTXABrFJdNSmpOZllqkb5dAlfG/KvTWQsOclfseHmTpYHxIGcXIweHhICJRPcr
	iy5GTiBTTOLCvfVsXYxcHEICSxklbr65zghT87DLFSI+nVGi+9sfVginn0ni6ZwXLCDdbAJm
	EgcXrWYHsUUEHCV2zPnHBFLELHCMUWLfvPmMIAlhgRCJV2feghWxCKhKvD3bA9bMK+Aqsb5z
	OxPENgWJOZNsQMKcAm4SLR8OsICEhYBKrl2UBxkpIbCOXeJc52o2iDECEt8mH2KBaJWV2HSA
	GeIZSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjMOhP/3vWv4Px7gHr
	Q4zJQOMmMkuJJucDoyavJN7Q2MzIwtTE1NjI3NKMNGElcd77D5OChATSE0tSs1NTC1KL4otK
	c1KLDzEycXBKNTC28BRo9jz/tKmtzHlZ8BxhBuWnixyL7c5yBrw6f8rSQDX+1AGXNPYrxhn7
	f69madi++KiwxF0tnjTbhe1dCTpJt2Jsr/rFr/ocMy9L+1LV0+rv61R1zrVU2ix9d3Bxr/Nz
	Jz83T94dRmpbF27kk/2nLPX2c0Rit7XqxuQlCYEGdkbHrlgfXKzEUpyRaKjFXFScCAARSNwv
	kAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t9jQd3JAmuCDf5P1rJ4eUjT4vqX56wW
	84+cY7U4u+wgm0Xz4vVsFvOOvGOxuLxrDpvFjPP7mCwWbfvP7MDpMbvhIovHzll32T32z13D
	7tG3ZRWjx+dNcgGsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2
	Si4+AbpumTlABykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM+Zfnc5a
	cJC7YsfLmywNjAc5uxg5OCQETCQedrl2MXICmWISF+6tZ+ti5OIQEpjOKNH97Q8rhNPPJPF0
	zgsWkCo2ATOJg4tWs4PYIgKOEjvm/GMCKWIWOMYosW/efEaQhLBAiMSrM2/BilgEVCXenu0B
	a+YVcJVY37mdCWKzgsScSTYgYU4BN4mWDwdYQMJCQCXXLspPYORdwMiwilE0tSC5oDgpPddI
	rzgxt7g0L10vOT93EyM4qp5J72Bc1WBxiFGAg1GJh/fD41XBQqyJZcWVuYcYJTiYlUR47/Ov
	CRbiTUmsrEotyo8vKs1JLT7EaAp000RmKdHkfGDE55XEGxqbmJsam1qaWJiYWSqJ8x5stQ4U
	EkhPLEnNTk0tSC2C6WPi4JRqYLRr28gyc9Ntsc2piw9Hf3+9Yd4J/rVfVA/fsT7geSXHn2mh
	6Lz+FJu6voLQC+/l/bVez5lu67HwtvasyMX7p3w8xrZ/1puCXexnWuRnM/6eL2/E6jPzVbBA
	/OS7lxb+swy60Ps6db1x3H8hk1tmEaf2T3+9vGWvwxOZCyL9rS5WcfNiVbbUvmxQYinOSDTU
	Yi4qTgQAQSXoQsACAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Murata Manufactures the NTC based thermistors. The vendor
name in the compatibility is preposed to change to "murata"

This patch uses the new compatibility string in exynos4412 based
Trats2 board.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
---
This patch is carried forward (tracking purpose) along with the other
dts changes in the patch set discussed
http://www.spinics.net/lists/linux-iio/msg13486.html

This patch was posted
http://www.spinics.net/lists/linux-samsung-soc/msg33037.html


 arch/arm/boot/dts/exynos4412-trats2.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 11967f4..d35755a 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -771,7 +771,7 @@
 	};
 
 	thermistor-ap@0 {
-		compatible = "ntc,ncp15wb473";
+		compatible = "murata,ncp15wb473";
 		pullup-uv = <1800000>;	 /* VCC_1.8V_AP */
 		pullup-ohm = <100000>;	 /* 100K */
 		pulldown-ohm = <100000>; /* 100K */
@@ -779,7 +779,7 @@
 	};
 
 	thermistor-battery@1 {
-		compatible = "ntc,ncp15wb473";
+		compatible = "murata,ncp15wb473";
 		pullup-uv = <1800000>;	 /* VCC_1.8V_AP */
 		pullup-ohm = <100000>;	 /* 100K */
 		pulldown-ohm = <100000>; /* 100K */
-- 
1.7.9.5

