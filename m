Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965439Ab3E2Jrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:47:32 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11988 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964948Ab3E2Jra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:47:30 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-45-51a5ceb1bdd9
From: Jingoo Han <jg1.han@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Praveen Paneri'" <p.paneri@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 1/2] ARM: dts: Add USB Host nodes to Exynos4210
Date: Wed, 29 May 2013 18:47:29 +0900
Message-id: <000101ce5c51$887309f0$99591dd0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5cUOVxxkwoXbRrRu+Br8EKrdezbg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zfd2N55YGGpy9LWPRduUgu8XlhZdY
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHF+SyeTxbEZSxgdODzuXNvD5rF5Sb1H35ZVjB6fN8kF
	sERx2aSk5mSWpRbp2yVwZRyb94W94DZ7xe7vc1gbGKeydTFyckgImEic7/vPDGGLSVy4tx4o
	zsUhJLCMUeJt41ommKINsw5AJRYxSixq3sICkhAS+MUoceS2FojNJqAm8eXLYXYQW0TAU+LD
	+RPMIA3MAh8YJSY+/sEIkhAWsJfYt+sF2GoWAVWJx6vPgcV5BSwlzhydwwZhC0r8mHwPbAGz
	gJbE+p3HmSBseYnNa95CnaogsePsa0aIZXoS3zZPYIaoEZHY9+IdI0TNJXaJFScqIXYJSHyb
	fAhoJgdQXFZi0wGoMZISB1fcYJnAKDYLyeZZSDbPQrJ5FpINCxhZVjGKphYkFxQnpReZ6BUn
	5haX5qXrJefnbmKEROOEHYz3DlgfYkwGWj+RWUo0OR8YzXkl8YbGZkYWpiamxkbmlmakCSuJ
	86q3WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYNSuULAUOF5/LeFQdHkE327ty6xWxyTt
	Hv17v//HCmnpV4ElN32Uvy3c//b3xklNnZbXz0/7nRwb9GqajMhqI7kF89MP6S1/5aTPz/aq
	h2XKU5vECX58c+eu1GXjCrN/4p0Tdqf6S7Tg84l/Gni/WHZu11twWPFQrIJP84KsVdb7nKe+
	8Wb71qXEUpyRaKjFXFScCABj8Rwh3AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jAd2N55YGGszcIWHRduUgu8XlhZdY
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHF+SyeTxbEZSxgdODzuXNvD5rF5Sb1H35ZVjB6fN8kF
	sEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAJ2h
	pFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8w4Nu8Le8Ft9ord3+ewNjBO
	Zeti5OSQEDCR2DDrAJQtJnHh3nogm4tDSGARo8Si5i0sIAkhgV+MEkdua4HYbAJqEl++HGYH
	sUUEPCU+nD/BDNLALPCBUWLi4x+MIAlhAXuJfbtegE1lEVCVeLz6HFicV8BS4szROWwQtqDE
	j8n3wBYwC2hJrN95nAnClpfYvOYtM8RFChI7zr5mhFimJ/Ft8wRmiBoRiX0v3jFOYBSYhWTU
	LCSjZiEZNQtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwdH+TGoH48oGi0OMAhyM
	Sjy8DL+WBAqxJpYVV+YeYpTgYFYS4U0VXBooxJuSWFmVWpQfX1Sak1p8iDEZ6NOJzFKiyfnA
	RJRXEm9obGJmZGlkZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYyr3ad8EVW7
	myzvdlJ3yplwDkapB+ukY96zmSXvLA+qsbm0edeUX8auB6eyq5tfcf6z4svv03sqWU6lHvqw
	P+b4pJ7ut6fijtprnl4ht0ZvQ+PdNTcNtEOlV33kq2Bhuc7J4PVI+j1r7pPoKSJJ/09OaNwa
	PVE5XVha/cBx9XAvHl4d474vkruVWIozEg21mIuKEwEQp/vlOgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device nodes for USB Host EHCI and OHCI controllers to Exynos4210.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Tested on Exynos4210.

 arch/arm/boot/dts/exynos4210.dtsi |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index 366795a..3c173c7 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -117,6 +117,24 @@
 		status = "disabled";
 	};
 
+	usb@12580000 {
+		compatible = "samsung,exynos4210-ehci";
+		reg = <0x12580000 0x100>;
+		interrupts = <0 70 0>;
+
+		clocks = <&clock 304>;
+		clock-names = "usbhost";
+	};
+
+	usb@12590000 {
+		compatible = "samsung,exynos4210-ohci";
+		reg = <0x12590000 0x100>;
+		interrupts = <0 70 0>;
+
+		clocks = <&clock 304>;
+		clock-names = "usbhost";
+	};
+
 	g2d@12800000 {
 		compatible = "samsung,s5pv210-g2d";
 		reg = <0x12800000 0x1000>;
-- 
1.7.10.4


