Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab3AVPZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 10:25:19 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:63511 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab3AVPZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 10:25:11 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-ac-50feaf562edf
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, kgene.kim@samsung.com,
        grant.likely@secretlab.ca, dianders@chromium.org, balbi@ti.com,
        thomas.abraham@linaro.org, sylvester.nawrocki@gmail.com,
        tomasz.figa@gmail.com, p.paneri@samsung.com
Subject: [PATCH v2 2/2] ARM: Exynos5250: Enabling samsung-usb3-phy driver
Date: Tue, 22 Jan 2013 21:01:20 +0530
Message-id: <1358868680-5757-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1358868680-5757-1-git-send-email-gautam.vivek@samsung.com>
References: <1358868680-5757-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsWyRsSkSjds/b8Ag83NUhaXd81hs5hxfh+T
	xaJlrcwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZWw89JutYCJ7xbWjOxkbGO+wdjFyckgImEj8
	23iUCcIWk7hwbz1bFyMXh5DAUkaJO2fOscMUbWjtY4ZITGeUWPH9DQtIQkhgMpPE+lXFIDab
	gK5E09tdjCC2iICqxOe2BewgDcwCi5kk7m6cCZTg4BAW8JS4/TcCpIYFqGbW9rPMIGFeAXeJ
	c41lELsUJN7cfsYMYnMKeEgc3PSHFWKVu8TWhZdYQUZKCDxnk7i2by8bxBwBiW+TD7GAzJEQ
	kJXYdIAZYo6kxMEVN1gmMAovYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREYlKf/PZPe
	wbiqweIQowAHoxIP74P7fwOEWBPLiitzDzFKcDArifDq1v8LEOJNSaysSi3Kjy8qzUktPsSY
	DLR8IrOUaHI+MGLySuINjU3MTY1NLY2MzExNSRNWEudlPPUkQEggPbEkNTs1tSC1CGYLEwen
	VANjKKfSjhzxxX9c/79996PmerzoYo2X1n4LLLO2dT7W/bVo1XObnOMs0kIzWAJPy/zQPL9r
	Y714yCnl56q86q9fzlCx883rlRINnO5TUzB33tyNS5W2barfzSPiwd+49Y3UfomJSx8qXNn+
	+JnwdKN6p3uz1zmf+zW3NPRe9NOK9fOFz0dZnc5RU2Ipzkg01GIuKk4EAK28VQ+OAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t9jQd2w9f8CDBYv4La4vGsOm8WM8/uY
	LBYta2V2YPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFj46Hf
	bAUT2SuuHd3J2MB4h7WLkZNDQsBEYkNrHzOELSZx4d56ti5GLg4hgemMEiu+v2EBSQgJTGaS
	WL+qGMRmE9CVaHq7ixHEFhFQlfjctoAdpIFZYDGTxN2NM4ESHBzCAp4St/9GgNSwANXM2n6W
	GSTMK+Auca6xDGKXgsSb28/A9nIKeEgc3PSHFWKVu8TWhZdYJzDyLmBkWMUomlqQXFCclJ5r
	pFecmFtcmpeul5yfu4kRHPLPpHcwrmqwOMQowMGoxMP74P7fACHWxLLiytxDjBIczEoivLr1
	/wKEeFMSK6tSi/Lji0pzUosPMSYDHTWRWUo0OR8Yj3kl8YbGJuamxqaWJhYmZpakCSuJ8zKe
	ehIgJJCeWJKanZpakFoEs4WJg1OqgbHC4sEihtiezM8b69jZjDflqIaa1075Zrg/JSt3qtfW
	5TvKeC7z7dLzF1vidXXCs2irsOTcxAUBQntaJk7/r6G65L9CfbXs37OO3SlXVrTfe1wjsjl8
	ydJ3fTlhvEdYD+2a7rHq4cd5wuFb/PbJJSne+PambEHDnvOfvefsvatQrvFa0CXr3AklluKM
	REMt5qLiRAAxFL0evQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding usb3.0 phy node for Exynos5250 along with the
necessary device data to be parsed.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/boot/dts/exynos5250.dtsi |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 610e338..018a70d 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -275,6 +275,19 @@
 		#size-cells = <0>;
 	};
 
+	usbphy@12100000 {
+		compatible = "samsung,exynos5250-usb3-phy";
+		reg = <0x12100000 0x100>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		usbphy-sys {
+			      /* USB device and host PHY_CONTROL registers */
+			reg = <0x10040704 0x8>;
+		};
+	};
+
 	usbphy@12130000 {
 		compatible = "samsung,exynos5250-usbphy";
 		reg = <0x12130000 0x100>;
-- 
1.7.6.5

