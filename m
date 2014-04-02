Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbaDBHq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:46:28 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:34232 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757954AbaDBHqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:46:22 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-69-533bc02a5a66
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        chow.kim@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH 1/3] ARM: dts: Add PMU reg node to exynos4210
Date: Wed, 02 Apr 2014 17:02:56 +0900
Message-id: <1396425778-4379-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396425778-4379-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396425778-4379-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t8zY12tA9bBBpfe61gsm3SXzWL+kXOs
	Fv1vFrJanHu1ktGid8FVNotNj6+xWlzeNYfNYsb5fUwWty/zWiy9fpHJYtHWL+wWE6avZbFo
	3XuE3YHXY828NYweLc09bB6X+3qZPFYu/8LmsWlVJ5vH5iX1Hn1bVjF6fN4kF8ARxWWTkpqT
	WZZapG+XwJVx/Pkq9oIGtoqpL/ewNjD+Zuli5OCQEDCRmHMrq4uRE8gUk7hwbz1bFyMXh5DA
	MkaJf1uesEIkTCR+LX7GCJGYzijx5cxqZginjUli+feDTCBVbAK6Ek/ezwVLiAi0M0o8ubwO
	rIVZ4CWjxNdfE8GqhAVsJd5fOAFmswioSlzufsMOcgevgLvEwVUSECcpSMyZZANSwSngIfFs
	yVGwaiGgiheL7rCDjJQQuMcu8eTbc1aIMQIS3yYfgnpHVmLTAWaIqyUlDq64wTKBUXgBI8Mq
	RtHUguSC4qT0IkO94sTc4tK8dL3k/NxNjJDo6d3BePuA9SHGZKBxE5mlRJPzgdGXVxJvaGxm
	ZGFqYmpsZG5pRpqwkjhv0sOkICGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MB8Lf19+/LuNk
	+bIy94NH77QLilMml/M9Vq/1ZogRP5Z4m2VtTcaj5lDXFa3GqgKHltzQvO8kYP5iv8T8+4YG
	8/w8d0kv37shuHHBFdW13/xUL69svaTUut0wUvKDlU2Wv9CjzU1/pMqPz5jZP+Pv877Ovxt7
	+hMPnblut6nZ8ebK9U81wx9sUGIpzkg01GIuKk4EABqJVHe0AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t9jQV2tA9bBBuf/q1ssm3SXzWL+kXOs
	Fv1vFrJanHu1ktGid8FVNotNj6+xWlzeNYfNYsb5fUwWty/zWiy9fpHJYtHWL+wWE6avZbFo
	3XuE3YHXY828NYweLc09bB6X+3qZPFYu/8LmsWlVJ5vH5iX1Hn1bVjF6fN4kF8AR1cBok5Ga
	mJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0spJCWWJOKVAo
	ILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4/jzVewFDWwVU1/uYW1g/M3SxcjJISFg
	IvFr8TNGCFtM4sK99WxdjFwcQgLTGSW+nFnNDOG0MUks/36QCaSKTUBX4sn7uWAJEYF2Rokn
	l9cxgjjMAi8ZJb7+mghWJSxgK/H+wgkwm0VAVeJy9xv2LkYODl4Bd4mDqyRATAkBBYk5k2xA
	KjgFPCSeLTkKVi0EVPFi0R32CYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIER+cz
	6R2MqxosDjEKcDAq8fAeOG8VLMSaWFZcmXuIUYKDWUmEl3OSdbAQb0piZVVqUX58UWlOavEh
	xmSgmyYyS4km5wMTR15JvKGxiZmRpZGZhZGJuTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBx
	cEo1MBqJePSnr/ld5md7YOv7GdVT4mfpHTx02L2fUTfE67gkjzz7y9063RKmDPlWD5sVnlx9
	f0A0ZcqSZ8ym3Qcc/zbPLPNxnbhi/2nL6+5Ra2Y5Xu5MYXDyWmsueNNZ7ePx75/f8KrYLLFM
	ilXbpZCRFG3N7G+hMk1jBdPN3+W3Nbj8npkEslz2V2Ipzkg01GIuKk4EAB9EjGwSAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds pmu regnode to exynos4210 dtsi to handle
PMU register access via DT.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/boot/dts/exynos4210.dtsi |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index cacf614..0a2c0fe 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -81,6 +81,11 @@
 		interrupts = <2 2>, <3 2>;
 	};
 
+	pmu_system_controller: system-controller@10020000 {
+		compatible = "samsung,exynos4210-pmu", "syscon";
+		reg = <0x10020000 0x5000>;
+	};
+
 	pinctrl_0: pinctrl@11400000 {
 		compatible = "samsung,exynos4210-pinctrl";
 		reg = <0x11400000 0x1000>;
-- 
1.7.10.4

