Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbaHEM15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:27:57 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52103 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbaHEM1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:27:54 -0400
X-AuditID: cbfee690-b7f526d000003627-92-53e0cdc8fcf2
From: Chanwoo Choi <cw00.choi@samsung.com>
To: a.zummo@towertech.it
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 5/5] ARM: dts: Fix wrong compatible string of Exynos3250 RTC dt
 node
Date: Tue, 05 Aug 2014 21:27:46 +0900
Message-id: <1407241666-17835-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1407241666-17835-1-git-send-email-cw00.choi@samsung.com>
References: <1407241666-17835-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWyRsSkWPfE2QfBBtNmi1ksuXiV3eL6l+es
	Fr0LrrJZnG16w25xedccNosZ5/cxWezv7GB0YPfYM/Ekm0ffllWMHtPn/WTy+LxJLoAlissm
	JTUnsyy1SN8ugSuj5cFtloIPrBW7O74zNzA+Z+li5OSQEDCR+Hr3PTuELSZx4d56ti5GLg4h
	gaWMElu3P2ODKbq68jdUYjqjxLHprYwQThOTxKQ1X1hBqtgEtCT2v7gB1iEiICGxZM4dsCJm
	gd2MEpPXvATbJywQJnH2yzOwfSwCqhJ3Vr4DKuLg4BVwlfi9KgJim5zEhz2PwEo4BdwkJj2e
	BmYLAZU0b/8DNlNCoJ9dYvmFVYwQcwQkvk0+xAIyR0JAVmLTAWaIOZISB1fcYJnAKLyAkWEV
	o2hqQXJBcVJ6kYlecWJucWleul5yfu4mRmB4n/73bMIOxnsHrA8xJgONm8gsJZqcD4yPvJJ4
	Q2MzIwtTE1NjI3NLM9KElcR51R4lBQkJpCeWpGanphakFsUXleakFh9iZOLglGpg9C1uNRO4
	8Uaq1Y3bK+JnwPETa6RFHwqUXDj98l2KrP+GS7YLTy4yYdCYvb7sZ88e88hgA93dk5fWad7+
	lmdbnaF0rHtloqFAaNkvm6DPsYG7tuxdGj+bg+/1+mUmFi5P+VNZam59vtN/fMmHhcXM33L6
	ozicvlR3C9w9/Kp8ydTYVmaGfu5ZSizFGYmGWsxFxYkAFHkz0YUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQd0TZx8EG8z5yWex5OJVdovrX56z
	WvQuuMpmcbbpDbvF5V1z2CxmnN/HZLG/s4PRgd1jz8STbB59W1Yxekyf95PJ4/MmuQCWqAZG
	m4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygE5QUyhJz
	SoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGS0PbrMUfGCt2N3xnbmB8TlLFyMn
	h4SAicTVlb/ZIGwxiQv31gPZXBxCAtMZJY5Nb2WEcJqYJCat+cIKUsUmoCWx/8UNsA4RAQmJ
	JXPugBUxC+xmlJi85iXYWGGBMImzX56xg9gsAqoSd1a+Ayri4OAVcJX4vSoCYpucxIc9j8BK
	OAXcJCY9ngZmCwGVNG//wziBkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjODoeSa9
	g3FVg8UhRgEORiUeXgG1+8FCrIllxZW5hxglOJiVRHif7noQLMSbklhZlVqUH19UmpNafIjR
	FOioicxSosn5wMjOK4k3NDYxM7I0Mje0MDI2VxLnPdhqHSgkkJ5YkpqdmlqQWgTTx8TBKdXA
	uFhtzgkXsSOXE/+cYzKzUe/70vj0nkaZ8L1tv+KPL9u8ol770WyNHaeDFdikGN5mG08MrTF5
	qC7MYWotfjdRbdEk3kONhZItCwxPf+qtdT/7QuXp7Af7Nv7Y7vDqo8LMGYqt7nvmFP0S/uGa
	dU2+XtMtrzIgM/9NwiZN/7lt3+J0Jre/37ppjxJLcUaioRZzUXEiABorOs60AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix wrong compatible string of Exynos3250 RTC (Real-Time Clock) dt
node. The RTC of Exynos3250 must need additional source clock (XrtcXTI).

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index abd6eb3..a04540e 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -162,7 +162,7 @@
 		};
 
 		rtc: rtc@10070000 {
-			compatible = "samsung,s3c6410-rtc";
+			compatible = "samsung,exynos3250-rtc";
 			reg = <0x10070000 0x100>;
 			interrupts = <0 73 0>, <0 74 0>;
 			status = "disabled";
-- 
1.8.0

