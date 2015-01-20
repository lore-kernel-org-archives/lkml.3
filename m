Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbbATHLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:11:18 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:8291 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbbATHKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:10:38 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-08-54bdff56644d
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v9 6/7] ARM: dts: exynos: Add PPMU node for Exynos3250-based
 Rinato/Monk board
Date: Tue, 20 Jan 2015 16:10:08 +0900
Message-id: <1421737809-4010-7-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1421737809-4010-1-git-send-email-cw00.choi@samsung.com>
References: <1421737809-4010-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42JZI2JSpBv2f2+Iwfc+E4vHaxYzWWycsZ7V
	4vqX56wWk+5PYLF4/cLQov/xa2aLs01v2C02Pb7GanF51xw2i8+9RxgtZpzfx2Sx9PpFJovb
	jSvYLB6veMtu0br3CLvFql1/GB0EPNbMW8PosXPWXXaPxXteMnlsWtXJ5rF5Sb1H35ZVjB6f
	N8kFsEdx2aSk5mSWpRbp2yVwZUzoWsBSsE+o4tR1swbG13xdjJwcEgImEhueLWCDsMUkLtxb
	D2RzcQgJLGWUuLHpBzNMUc+8h2BFQgKLGCUerQyDKGpikjgw8x5Ygk1AS2L/ixtgtoiAnkTn
	sT3sIDazwB8miaZNLCC2sECCxLxfX5lAbBYBVYnty7vBbF4BF4kbS1tYIZYpSCxbPhPM5hRw
	ldi+5TIjxGIXiebP75lAFksI3GOX2DTxPRvEIAGJb5MPAS3gAErISmw6AHW0pMTBFTdYJjAK
	L2BkWMUomlqQXFCclF5kolecmFtcmpeul5yfu4kRGE+n/z2bsIPx3gHrQ4wCHIxKPLwvVu0N
	EWJNLCuuzD3EaAq0YSKzlGhyPjBq80riDY3NjCxMTUyNjcwtzZTEeV9L/QwWEkhPLEnNTk0t
	SC2KLyrNSS0+xMjEwSnVwJj46ahdnFuo7OfUgmNnXSIv+pl3xf/2OMzSFHFg262FqVlOn3eZ
	H/4qdribvbC1vC8vov8Sv8x+qWrBiVbMO359Wy/hb/mmwduhevnirgiT0NnPHPYL1R6c0Oeq
	92bTw4yEYpYuMaPO2/Xr56SGWN1/Y69mql+0TLXR86B13ZYrKzodlyrcUmIpzkg01GIuKk4E
	ACOjs0WiAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t9jAd2w/3tDDD5c0rZ4vGYxk8XGGetZ
	La5/ec5qMen+BBaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFq17j7BbrNr1h9FBwGPNvDWMHjtn3WX3WLznJZPHplWdbB6bl9R79G1Zxejx
	eZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtDxSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMCV0LWAr2CVWcum7W
	wPiar4uRk0NCwESiZ95DNghbTOLCvfVgtpDAIkaJRyvDuhi5gOwmJokDM++BJdgEtCT2v7gB
	ZosI6El0HtvDDmIzC/xhkmjaxAJiCwskSMz79ZUJxGYRUJXYvrwbzOYVcJG4sbSFFWKZgsSy
	5TPBbE4BV4ntWy4zQix2kWj+/J5pAiPvAkaGVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjB
	0fpMagfjygaLQ4wCHIxKPLwOa/eGCLEmlhVX5h5ilOBgVhLhnfAUKMSbklhZlVqUH19UmpNa
	fIjRFOiqicxSosn5wESSVxJvaGxiZmRpZG5oYWRsriTOq2TfFiIkkJ5YkpqdmlqQWgTTx8TB
	KdXAOIExNTlfPeJg7GSRKHdfnntGb/RsLbLKPm90u3snUPv7lS8CKWZKzRl/j50zn3ffyK/n
	gdWe9rlsIYrpSg8bNUTvHN7bNOelWwmnRsSfYOHEiUHn2C//eRMsm3Xd4oxN0RSWGY9DjXbZ
	5L1dyN3m+b8namv05f8x0v6bXe54LoltKhBp3iapxFKckWioxVxUnAgA8RppLOwCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add PPMU dt node to Exynos3250-base Rinato/Monk board. The PPMU node
is used to get the utilization of DMC0/DMC1/LEFTBUS/RIGHTBUS Block.

Cc: Kukjin Kim <kgene@kernel.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250-monk.dts   | 40 +++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos3250-rinato.dts | 40 +++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-monk.dts b/arch/arm/boot/dts/exynos3250-monk.dts
index 24822aa..fcceb59 100644
--- a/arch/arm/boot/dts/exynos3250-monk.dts
+++ b/arch/arm/boot/dts/exynos3250-monk.dts
@@ -420,6 +420,46 @@
 	status = "okay";
 };
 
+&ppmu_dmc0 {
+	status = "okay";
+
+	events {
+		ppmu_dmc0_3: ppmu-event3-dmc0 {
+			event-name = "ppmu-event3-dmc0";
+		};
+	};
+};
+
+&ppmu_dmc1 {
+	status = "okay";
+
+	events {
+		ppmu_dmc1_3: ppmu-event3-dmc1 {
+			event-name = "ppmu-event3-dmc1";
+		};
+	};
+};
+
+&ppmu_leftbus {
+	status = "okay";
+
+	events {
+		ppmu_leftbus_3: ppmu-event3-leftbus {
+			event-name = "ppmu-event3-leftbus";
+		};
+	};
+};
+
+&ppmu_rightbus {
+	status = "okay";
+
+	events {
+		ppmu_rightbus_3: ppmu-event3-rightbus {
+			event-name = "ppmu-event3-rightbus";
+		};
+	};
+};
+
 &xusbxti {
 	clock-frequency = <24000000>;
 };
diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index 7cc52b5..9dd1ce1 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -595,6 +595,46 @@
 	status = "okay";
 };
 
+&ppmu_dmc0 {
+	status = "okay";
+
+	events {
+		ppmu_dmc0_3: ppmu-event3-dmc0 {
+			event-name = "ppmu-event3-dmc0";
+		};
+	};
+};
+
+&ppmu_dmc1 {
+	status = "okay";
+
+	events {
+		ppmu_dmc1_3: ppmu-event3-dmc1 {
+			event-name = "ppmu-event3-dmc1";
+		};
+	};
+};
+
+&ppmu_leftbus {
+	status = "okay";
+
+	events {
+		ppmu_leftbus_3: ppmu-event3-leftbus {
+			event-name = "ppmu-event3-leftbus";
+		};
+	};
+};
+
+&ppmu_rightbus {
+	status = "okay";
+
+	events {
+		ppmu_rightbus_3: ppmu-event3-rightbus {
+			event-name = "ppmu-event3-rightbus";
+		};
+	};
+};
+
 &xusbxti {
 	clock-frequency = <24000000>;
 };
-- 
1.8.5.5

