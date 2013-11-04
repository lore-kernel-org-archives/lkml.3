Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab3KDB4m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 20:56:42 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:12982 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3KDB4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 20:56:09 -0500
X-AuditID: cbfee690-b7f3d6d000001c4a-39-5276feb70924
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 3/3] ARM: dts: exynos4x12: Add gps_alive power domain for
 exynos4x12
Date: Mon, 04 Nov 2013 10:56:01 +0900
Message-id: <1383530161-24080-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1383530161-24080-1-git-send-email-cw00.choi@samsung.com>
References: <1383530161-24080-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsWyRsSkUHf7v7Igg9ubtS2uf3nOajH/yDlW
	i3OvVjJa9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaL25d5LZZev8hkMWH6WhaLwysOMFm8
	OtjGYrF+xmsWBz6PNfPWMHq0NPeweSz4fIXdY+XyL2wem5fUe/RtWcXo8XmTnMfGuaEBHFFc
	NimpOZllqUX6dglcGRf2bmIvaGKr6Nl9ga2BsZ21i5GTQ0LAROL/0n5mCFtM4sK99WxdjFwc
	QgJLGSVW3GmFK5p6eScjRGI6o8TaG3dZIJxGJolpHYvBqtgEtCT2v7jBBmKLCOhKTJl5hxWk
	iFngPpPEj+OrwBLCAhES/U/WMoHYLAKqEpeW/wGL8wq4SjzrvskOsU5O4sOeR2A2p4CbxL/z
	B8BsIaCau83XwM6QELjHLtH67Ds7xCABiW+TDwGdxAGUkJXYdADqH0mJgytusExgFF7AyLCK
	UTS1ILmgOCm9yESvODG3uDQvXS85P3cTIzCSTv97NmEH470D1ocYk4HGTWSWEk3OB0ZiXkm8
	obGZkYWpiamxkbmlGWnCSuK8ao+SgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwLglxsv+1
	YNejZ27ftfTWr4zb9vSDKWv5FRWzOBW7DSXfSs0jtu1eqraKQZClck5P3pqC4y/OrT5/7Ynq
	C7FTQXnb1OKP738uwqi+9cznhQ3/Kzu+TfU89rDjxp9qx4LwA1Jqv9ZlsQlFH3hZyPbvW7Pc
	1QtWV/v1F709Ib394+37i1zt737wl1FiKc5INNRiLipOBADwKMopugIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+xoO72f2VBBidvKVtc//Kc1WL+kXOs
	FuderWS06F1wlc3ibNMbdotNj6+xWlzeNYfNYsb5fUwWty/zWiy9fpHJYsL0tSwWh1ccYLJ4
	dbCNxWL9jNcsDnwea+atYfRoae5h81jw+Qq7x8rlX9g8Ni+p9+jbsorR4/MmOY+Nc0MDOKIa
	GG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgM5WUihL
	zCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGZc2LuJvaCJraJn9wW2BsZ21i5G
	Tg4JAROJqZd3MkLYYhIX7q1n62Lk4hASmM4osfbGXRYIp5FJYlrHYrAONgEtif0vbrCB2CIC
	uhJTZt5hBSliFrjPJPHj+CqwhLBAhET/k7VMIDaLgKrEpeV/wOK8Aq4Sz7pvskOsk5P4sOcR
	mM0p4Cbx7/wBMFsIqOZu8zXGCYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEx+kz
	qR2MKxssDjEKcDAq8fBKXC4LEmJNLCuuzD3EKMHBrCTC63wOKMSbklhZlVqUH19UmpNafIgx
	GeiqicxSosn5wBSSVxJvaGxiZmRpZG5oYWRsTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTByc
	Ug2MpvM193oLtBj6Onm/qL9zZNrhU9s55/D6cOycOfmNneAi74iW7vPzqpgbsp+987RayGdf
	o9t4amrmq22V+sXWfLySQafm3rZ9+oxFN/W8gJOR34JPDQ4z16woDZU9Yua7mCO55InzLp79
	fnbcxw7McLKqZiiUZ45xfZcxYTVf8H4tce9FK+OUWIozEg21mIuKEwFPkDlzFwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch gps_alive power domain to exynos4x12.dtsi.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos4x12.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index ad531fe..3f5b416 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -35,6 +35,11 @@
 		reg = <0x10023CA0 0x20>;
 	};
 
+	pd_gps_alive: gps-alive-power-domain@10023D00 {
+		compatible = "samsung,exynos4210-pd";
+		reg = <0x10023D00 0x20>;
+	};
+
 	clock: clock-controller@10030000 {
 		compatible = "samsung,exynos4412-clock";
 		reg = <0x10030000 0x20000>;
-- 
1.8.0

