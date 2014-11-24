Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbaKXFsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 00:48:13 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:11935 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbaKXFsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 00:48:10 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-3e-5472c697f6a4
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: kgene.kim@samsung.com, dri-devel@lists.freedesktop.org,
        javier.martinez@collabora.co.uk, jg1.han@samsung.com,
        ajaykumar.rs@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>,
        Kukjin Kim <kgene@kernel.org>
Subject: [PATCH V2 RESEND] arm: dts: Exynos5: Use pmu_system_controller phandle
 for dp phy
Date: Mon, 24 Nov 2014 11:11:23 +0530
Message-id: <1416807683-2257-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsWyRsSkTnf6saIQg3M3lCwOvD/IYjH/yDlW
	iytf37NZtF05yG5x9HeBxeWFl1gtehdcZbPof/ya2eLyrjlsFjPO72Ny4PL4+/w6i8emVZ1s
	Hve7jzN59G1ZxejxeZNcAGsUl01Kak5mWWqRvl0CV8aTs6uZCr5yVRzbf4qxgXEWZxcjJ4eE
	gIlE25nPTBC2mMSFe+vZuhi5OIQEljJK3DjxmwWm6OmjB8wQiUWMErsfd7NDOBOYJM7euM4M
	UsUmoCvR9HYXI4gtIpAocerwUbCxzAI3GCUaLol1MXJwCAvESBzeXw0SZhFQldjTdhushFfA
	XWLH/WWsICUSAgoScybZgIyXEJjOLvG5qY0Vol5A4tvkQywQNbISmw4wQ9wmKXFwxQ2WCYyC
	CxgZVjGKphYkFxQnpReZ6BUn5haX5qXrJefnbmIEBvTpf88m7GC8d8D6EKMAB6MSD++HjUUh
	QqyJZcWVuYcYTYE2TGSWEk3OB8ZNXkm8obGZkYWpiamxkbmlmZI472upn8FCAumJJanZqakF
	qUXxRaU5qcWHGJk4OKUaGGtjtKxrZgVEc3ZM5pXNSZ19afm5Q7end12aOXXpyV7mD+b5vyfo
	1nk1tP7f+sjv9GK1m8oFUbtMZ91YJJfI5fWxvtI73/Nspb/X53sazhsnr2C5WSQ2bY1I9JK9
	fLt+u3/3+Pm87aDJlQyPe9W/dpY82Srxorva8IbfvE+Hxb4ySSt1/jgr7KXEUpyRaKjFXFSc
	CAAfr+TAYwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsVy+t9jAd3px4pCDGZtkLY48P4gi8X8I+dY
	La58fc9m0XblILvF0d8FFpcXXmK16F1wlc2i//FrZovLu+awWcw4v4/Jgcvj7/PrLB6bVnWy
	edzvPs7k0bdlFaPH501yAaxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koK
	eYm5qbZKLj4Bum6ZOUBXKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgz
	npxdzVTwlavi2P5TjA2Mszi7GDk5JARMJJ4+esAMYYtJXLi3nq2LkYtDSGARo8Tux93sEM4E
	JomzN66DVbEJ6Eo0vd3FCGKLCCRKnDp8lAnEZha4wSjRcEmsi5GDQ1ggRuLw/mqQMIuAqsSe
	tttgJbwC7hI77i9jBSmREFCQmDPJZgIj9wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsY
	wfHyTGoH48oGi0OMAhyMSjy8HzYWhQixJpYVV+YeYpTgYFYS4T37rzBEiDclsbIqtSg/vqg0
	J7X4EKMp0PKJzFKiyfnAWM4riTc0NjE3NTa1NLEwMbNUEue9cTM3REggPbEkNTs1tSC1CKaP
	iYNTqoFRRerWBQ0zDkW72YLi67cYfJv4peH8wvr7JZoh4T7+/SIzQ31Sfl8PvXFWzGDJJTse
	vf1nLnoHrXA8ubHcec3xxORn6+OTxXR+bJU49sippsD/848I3fJTEf9aql6mhBtJLZz1+prX
	DOuNyi9K3O6e7DbVlHbuznZhWi3y42TRw/kV/HHqHZlKLMUZiYZazEXFiQCChSxxrQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DP PHY now require pmu-system-controller to handle PMU register
to control PHY's power isolation. Adding the same to dp-phy
node.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Reviewed-by: Jingoo Han <jg1.han@samsung.com>
Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene@kernel.org>
---
 arch/arm/boot/dts/exynos5250.dtsi |    2 +-
 arch/arm/boot/dts/exynos5420.dtsi |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 0a588b4..bebd099 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -732,7 +732,7 @@
 
 	dp_phy: video-phy@10040720 {
 		compatible = "samsung,exynos5250-dp-video-phy";
-		reg = <0x10040720 4>;
+		samsung,pmu-syscon = <&pmu_system_controller>;
 		#phy-cells = <0>;
 	};
 
diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 8617a03..1353a09 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -503,8 +503,8 @@
 	};
 
 	dp_phy: video-phy@10040728 {
-		compatible = "samsung,exynos5250-dp-video-phy";
-		reg = <0x10040728 4>;
+		compatible = "samsung,exynos5420-dp-video-phy";
+		samsung,pmu-syscon = <&pmu_system_controller>;
 		#phy-cells = <0>;
 	};
 
-- 
1.7.10.4

