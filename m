Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbaFZMXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 08:23:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20186 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844AbaFZMXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 08:23:05 -0400
X-AuditID: cbfee690-b7fb56d000003439-fd-53ac10a77999
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, cpgs@samsung.com
Subject: [PATCH 2/3] ARM: DTS: Add NTC thermistor nodes to Exynos5250 based Snow
Date: Thu, 26 Jun 2014 17:49:07 +0530
Message-id: <1403785148-20792-3-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1403785148-20792-1-git-send-email-ch.naveen@samsung.com>
References: <1403785148-20792-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWyRsSkTne5wJpgg5kbVCxeHtK0mH/kHKvF
	2WUH2SyaF69ns5h35B2LxeVdc9gsZpzfx2SxaNt/ZgcOj9kNF1k8ds66y+6xf+4ado++LasY
	PT5vkgtgjeKySUnNySxLLdK3S+DK2HjqAlvBSr6KBUc6mRsY13B3MXJySAiYSNzumsgCYYtJ
	XLi3nq2LkYtDSGApo8Trr2fYYIpmPv/ODpGYzihx5cVnoAQHkNPPJDFDEaSGTcBM4uCi1ewg
	toiAo8SOOf+YQOqZBRYwSrTuWs0EkhAWCJDYf+Ur2DYWAVWJmd9bwWxeAVeJxV19zCAzJQQU
	JOZMsgEJcwq4SbR8OMACscpV4tpFeZCREgKL2CXezF/NDDFGQOLb5EMsEK2yEpsOMEOcLClx
	cMUNlgmMwgsYGVYxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525iBIb66X/PJuxgvHfA+hBjMtC4
	icxSosn5wFjJK4k3NDYzsjA1MTU2Mrc0I01YSZxX7VFSkJBAemJJanZqakFqUXxRaU5q8SFG
	Jg5OqQbG5YwPVFpqq8K5S9xi8sLr2kNc+vfoN9/adfFwmVJ+Bd+9JdZzdu6+vWs57wQR5RJW
	/xJftqc3JnBwaOyu+xF64dPvK3Z+SQrMstOXtnBM6yybIauWHKbwUrVyTmyhaEjQY4/mx8Gt
	JU2CdS33HQpNFGdwHuucfN36rpiDXItyXOdC+w6L+UosxRmJhlrMRcWJAGiAgJGLAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsVy+t9jQd3lAmuCDV4dkrZ4eUjTYv6Rc6wW
	Z5cdZLNoXryezWLekXcsFpd3zWGzmHF+H5PFom3/mR04PGY3XGTx2DnrLrvH/rlr2D36tqxi
	9Pi8SS6ANaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DX
	LTMH6BYlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8bGUxfYClbyVSw4
	0sncwLiGu4uRk0NCwERi5vPv7BC2mMSFe+vZuhi5OIQEpjNKXHnxGcjhAHL6mSRmKILUsAmY
	SRxctBqsXkTAUWLHnH9MIPXMAgsYJVp3rWYCSQgLBEjsv/KVBcRmEVCVmPm9FczmFXCVWNzV
	xwwyU0JAQWLOJBuQMKeAm0TLhwMsEKtcJa5dlJ/AyLuAkWEVo2hqQXJBcVJ6rqFecWJucWle
	ul5yfu4mRnAkPZPawbiyweIQowAHoxIP74fHq4KFWBPLiitzDzFKcDArifCK/F4dLMSbklhZ
	lVqUH19UmpNafIjRFOimicxSosn5wCjPK4k3NDYxNzU2tTSxMDGzVBLnPdBqHSgkkJ5Ykpqd
	mlqQWgTTx8TBKdXAuHFNfFpB7/eId3OPcWsttArlK/Vq7dGzmjSnIaf187bJ7Ps5tN8J9e0J
	Xzpj6ZmSwLof/Trfnnbtn2az5vHWfQf88pdvWy3/b/2CZ0pcJ+esf+B7/8vqYMaf81vSxFeJ
	pda9nGV7y1d2QtNq+5L0q1Pe5YpvLW8Os3nx9t7blZKmAYohqryS6UosxRmJhlrMRcWJAA42
	aOq6AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos5250 based Snow board has 4 NTC thermistors to measure
temperatures at various points on the board.

IIO based ADC becomes the parent and NTC thermistors are the childs,
via the HWMON interface.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
Posted earlier by Doug Anderson @ https://lkml.org/lkml/2013/3/27/453

This patch depends on (1/4 and 2/4 patches of) patchset posted 
http://www.spinics.net/lists/linux-iio/msg13486.html
Which were applied on to Guenter Roeck's tree.

cat sysfs entries exported by hwmon for 4 thermistors
and verified the values on Snow.

 arch/arm/boot/dts/exynos5250-snow.dts |   34 +++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index 7bd2df1..0fa7067 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -20,6 +20,40 @@
 		i2c104 = &i2c_104;
 	};
 
+	adc@12D10000 {
+		status = "okay";
+		vdd-supply = <&buck5_reg>;
+
+		ncp15wb473@3 {
+			compatible = "murata,ncp15wb473";
+			pullup-uv = <1800000>;
+			pullup-ohm = <47000>;
+			pulldown-ohm = <0>;
+			io-channels = <&adc 3>;
+		};
+		ncp15wb473@4 {
+			compatible = "murata,ncp15wb473";
+			pullup-uv = <1800000>;
+			pullup-ohm = <47000>;
+			pulldown-ohm = <0>;
+			io-channels = <&adc 4>;
+		};
+		ncp15wb473@5 {
+			compatible = "murata,ncp15wb473";
+			pullup-uv = <1800000>;
+			pullup-ohm = <47000>;
+			pulldown-ohm = <0>;
+			io-channels = <&adc 5>;
+		};
+		ncp15wb473@6 {
+			compatible = "murata,ncp15wb473";
+			pullup-uv = <1800000>;
+			pullup-ohm = <47000>;
+			pulldown-ohm = <0>;
+			io-channels = <&adc 6>;
+		};
+	};
+
 	rtc@101E0000 {
 		status = "okay";
 	};
-- 
1.7.9.5

