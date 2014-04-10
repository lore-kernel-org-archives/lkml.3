Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965702AbaDJKGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:06:40 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:42818 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965677AbaDJKGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:06:35 -0400
X-AuditID: cbfee690-b7f266d00000287c-ee-53466d28d940
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 27/27] ARM: dts: exynos3250: Add CPUs dt node for Exynos3250
Date: Thu, 10 Apr 2014 19:06:17 +0900
Message-id: <1397124377-16969-19-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkSFcj1y3YoOG/ucX1L89ZLT5/aGG3
	mHR/AotF74KrbBZnm96wW2x6fI3V4vKuOWwWM87vY7KYMfklm8X6Ga9ZLPbunMzowO2xeUm9
	R9+WVYwenzfJBTBHcdmkpOZklqUW6dslcGXcv/WfuaCFvWLpvp9MDYzHWLsYOTkkBEwkWmZc
	YoawxSQu3FvP1sXIxSEksJRRYuHsCUwwRb/7OsGKhAQWMUo8mpQLYTcxSdw9mQhiswloSex/
	cYMNxBYRCJD4cfwdmM0scJNR4tj7MBBbWMBH4sDtRywgNouAqsTS3lZ2EJtXwE2i+fgZRohd
	chIf9jwCi3MCxWcuOskGsctVoufRRWaQ4yQEFrFLnDvxmRVikIDEt8mHgIZyACVkJTYdgHpG
	UuLgihssExiFFzAyrGIUTS1ILihOSi8y0StOzC0uzUvXS87P3cQIDPvT/55N2MF474D1IcZk
	oHETmaVEk/OBcZNXEm9obGZkYWpiamxkbmlGmrCSOK/ao6QgIYH0xJLU7NTUgtSi+KLSnNTi
	Q4xMHJxSDYzRj08onXz6bm3nc3b397NnnwnZ8rnbL0d/56ev+9Jnn13Krulxcwo/58aOj28v
	vQn9v/Np1VEhnh+bZepCwrTvP7tUzS85UVDqcJRpv3+HFmdue8n7Ca+2ai368cr+q/7p37+N
	Zx5a/kH51XSfVV3PJ+yL/h0wp8zaZJlJ3fRlUj6W8usvbynpUWIpzkg01GIuKk4EADM0NumR	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jAV2NXLdgg/P3DSyuf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26PzUvq
	Pfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxv1b/5kL
	Wtgrlu77ydTAeIy1i5GTQ0LAROJ3XyczhC0mceHeejYQW0hgEaPEo0m5EHYTk8Tdk4kgNpuA
	lsT+FzfAakQEAiR+HH8HZjML3GSUOPY+DMQWFvCROHD7EQuIzSKgKrG0t5UdxOYVcJNoPn6G
	EWKXnMSHPY/A4pxA8ZmLTkLtdZXoeXSReQIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5
	uZsYwVH1THoH46oGi0OMAhyMSjy8B5a5BguxJpYVV+YeYpTgYFYS4d2d6RYsxJuSWFmVWpQf
	X1Sak1p8iDEZ6KqJzFKiyfnAiM8riTc0NjEzsjQyN7QwMjYnTVhJnPdgq3WgkEB6Yklqdmpq
	QWoRzBYmDk6pBkaL89UBLkaTP3cZBMYxfk+d7vvitt2h8zezwx2X1TwWLKnaI76KdUnKsk6f
	02tOHOoU2ZW6cKem7zS3y3fWR+Qo8+b9C9rpvm7XlOrq6PY5EpfZ1z6wNZjz9u9Zu7JQc/to
	j0PHnXUfMN6eeXCt66kHf78/n3Ryqtz/JWWF7L/4V0/zn6MrY1qjxFKckWioxVxUnAgA3mZa
	Fu4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add CPUs dt node for Exynos3250 which uses the Cortex-A7 dual core.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 192770a..cb87087 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -42,6 +42,23 @@
 		i2c7 = &i2c_7;
 	};
 
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a7";
+			reg = <0>;
+		};
+	
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a7";
+			reg = <1>;
+		};
+	};
+
 	fixed-rate-clocks {
 		compatible = "simple-bus";
 		#address-cells = <1>;
-- 
1.8.0

