Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbaBGFZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 00:25:16 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:57179 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaBGFZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 00:25:13 -0500
X-AuditID: cbfee68e-b7f566d000002344-07-52f46e3813eb
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 6/9 v6] ARM: dts: exynos5250/5420: add dt node for sss module
Date: Fri, 07 Feb 2014 10:54:55 +0530
Message-id: <1391750695-27447-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389095509-14357-6-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-6-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWyRsSkTtci70uQwZmDqhYvD2ladL+Ssehd
	cJXN4v69n0wWl3fNYbOYcX4fk8Wibf+ZLc7OOcTkwOGxc9Zddo9tB1Q9+rasYvT4vEkugCWK
	yyYlNSezLLVI3y6BK2NRyzf2gpU8FVsnr2FsYJzH1cXIySEhYCLx+esEFghbTOLCvfVsXYxc
	HEICSxkl1jzazQxT9KrlJjtEYhGjxJZNM6GcfiaJ509fg7WzCZhJHFy0mh3EFhFwlvjdvIYV
	xGYWWMkosWitDYgtLOAr8WbtdbA4i4CqRN/hHrBeXgFXiR9XtwLZHEDbFCTmTAIr5xRwk5jV
	9Y8VJCwEVDLjfDrIWgmB6ewSn5fcYoYYIyDxbfIhqFZZiU0HoG6WlDi44gbLBEbhBYwMqxhF
	UwuSC4qT0ouM9IoTc4tL89L1kvNzNzECw/v0v2d9OxhvHrA+xJgMNG4is5Rocj4wPvJK4g2N
	zYwsTE1MjY3MLc1IE1YS5130MClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2Pmh8Phv3am
	Motn+h45Ivhi2ro1f26pfNj8UOpJ7kFpH/WNk1/G3DrwueD9iZO/pE+lbJl87eWX/Yqbdh08
	cD3Z2mHnpoC7qj6VXSsMVx2V2DHvidOtynlPOq6/t3l1JNqg/+Ifnxs6CwzqXjX3H3jxZZ27
	0e4j/ycFfPOPP/dpZytH19JyPQ8rZSWW4oxEQy3mouJEANqGvhaFAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t9jAV2LvC9BBq0LZC1eHtK06H4lY9G7
	4Cqbxf17P5ksLu+aw2Yx4/w+JotF2/4zW5ydc4jJgcNj56y77B7bDqh69G1ZxejxeZNcAEtU
	A6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtARSgpl
	iTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMRS3f2AtW8lRsnbyGsYFxHlcX
	IyeHhICJxKuWm+wQtpjEhXvr2boYuTiEBBYxSmzZNJMdwulnknj+9DULSBWbgJnEwUWrwTpE
	BJwlfjevYQWxmQVWMkosWmsDYgsL+Eq8WXsdLM4ioCrRd7gHrJdXwFXix9WtQDYH0DYFiTmT
	wMo5BdwkZnX9YwUJCwGVzDifPoGRdwEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Oh5
	Jr2DcVWDxSFGAQ5GJR7eE0s/BwmxJpYVV+YeYpTgYFYS4eVO+BIkxJuSWFmVWpQfX1Sak1p8
	iDEZ6KaJzFKiyfnAyM4riTc0NjE3NTa1NLEwMbMkTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYm
	Dk6pBkbZ0DPv/d6W6nwL+/3UyLXn4epd2w7939685CjvpJhjy79PsvFmuX68b/WugvM5ahZ1
	Tfu6dpucWiTZc3ez89Ka0wfOyi3ac/4lv6DrPLeojUpymZda1zqynV9+sqfK/vncgP6w18kN
	lR/bzrJpt8vdvlQa9bXv3nUhO3E9sXksgWLb2DK5WL8psRRnJBpqMRcVJwIA1oycV+ICAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the device tree node for SSS module
found on Exynos5420 and Exynos5250

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
TO: <linux-samsung-soc@vger.kernel.org>
CC: Kukjin Kim <kgene.kim@samsung.com>
CC: <linux-crypto@vger.kernel.org>
---
changes since v5:
1. Added Reviewed-by: Tomasz Figa <t.figa@samsung.com>

 arch/arm/boot/dts/exynos5250.dtsi |    8 ++++++++
 arch/arm/boot/dts/exynos5420.dtsi |   10 ++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index b7dec41..46b04e8 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -706,4 +706,12 @@
 		io-channel-ranges;
 		status = "disabled";
 	};
+
+	sss@10830000 {
+		compatible = "samsung,exynos4210-secss";
+		reg = <0x10830000 0x10000>;
+		interrupts = <0 112 0>;
+		clocks = <&clock 348>;
+		clock-names = "secss";
+	};
 };
diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 8db792b..b503e96 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -652,4 +652,14 @@
 		clocks = <&clock 319>, <&clock 318>;
 		clock-names = "tmu_apbif", "tmu_triminfo_apbif";
 	};
+
+	sss@10830000 {
+		compatible = "samsung,exynos4210-secss";
+		reg = <0x10830000 0x10000>;
+		interrupts = <0 112 0>;
+		clocks = <&clock 471>;
+		clock-names = "secss";
+		samsung,power-domain = <&g2d_pd>;
+	};
+
 };
-- 
1.7.9.5

