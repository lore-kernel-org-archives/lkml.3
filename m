Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbaLWDTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 22:19:33 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:20492 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbaLWDS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 22:18:28 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-69-5498defcc056
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv5 9/9] ARM: dts: exynos: Add PPMU_CPU/DMC0/DMC1 node for
 Exynos4412-based TRATS2 board
Date: Tue, 23 Dec 2014 12:18:17 +0900
Message-id: <1419304697-14789-10-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1419304697-14789-1-git-send-email-cw00.choi@samsung.com>
References: <1419304697-14789-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSrPvn3owQg8YPHBaP1yxmsrj+5Tmr
	xfwj51gtJt2fwGLx+oWhRe+Cq2wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8li6fWLTBa3
	G1ewWTxe8ZbdYtWuP4wO/B5r5q1h9Ng56y67x+I9L5k8Ni+p9+jbsorR4/MmuQC2KC6blNSc
	zLLUIn27BK6MR0+WsRbs4qi4fvgEewPjE7YuRk4OCQETif//rzBB2GISF+6tB4pzcQgJLGWU
	WN/2ihGm6Nvpb6wQiUWMEv+WbmGBcJqYJP4e+grWziagJbH/xQ2wsSICMhJXN24HK2IWaGSW
	+LLsP1iRsECGxIQ/M8CKWARUJeZdm8sMYvMKuEks/vUM6g4FiWXLZ7KC2JxA8T/znoLZQgKu
	EhM7rkPVXGKX2HqWB2KOgMS3yYeAlnEAxWUlNh1ghiiRlDi44gbLBEbhBYwMqxhFUwuSC4qT
	0otM9IoTc4tL89L1kvNzNzEC4+f0v2cTdjDeO2B9iFGAg1GJh3fhmRkhQqyJZcWVuYcYTYE2
	TGSWEk3OB0ZpXkm8obGZkYWpiamxkbmlmZI472upn8FCAumJJanZqakFqUXxRaU5qcWHGJk4
	OKUaGIsr1t36/ImvtIgp+/d2kcqEL/5HZwSxzG6TsKtPy0nZnlc/b1/ptjmhnP0BrnprTN4l
	Mi4RO50pknXFsGMeo/FS3hvPl2068CaJa+Vz4atlwr//Gz+Zbbq7OcJ1msmL/fLMX65xsk/r
	FxFq8vuq0BUi/umWlP66W7P+3Fd+rjR/t+jHwowsFyWW4oxEQy3mouJEADkXJqOaAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jAd0/92aEGLwys3i8ZjGTxfUvz1kt
	5h85x2ox6f4EFovXLwwtehdcZbM42/SG3WLT42usFpd3zWGz+Nx7hNFixvl9TBZLr19ksrjd
	uILN4vGKt+wWq3b9YXTg91gzbw2jx85Zd9k9Fu95yeSxeUm9R9+WVYwenzfJBbBFNTDaZKQm
	pqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gBdrKRQlphTChQK
	SCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMePRkGWvBLo6K64dPsDcwPmHrYuTkkBAw
	kfh2+hsrhC0mceHeeqA4F4eQwCJGiX9Lt7BAOE1MEn8PfWUCqWIT0JLY/+IGWLeIgIzE1Y3b
	wYqYBRqZJb4s+w9WJCyQITHhzwywIhYBVYl51+Yyg9i8Am4Si389Y4JYpyCxbPlMsNWcQPE/
	856C2UICrhITO64zTWDkXcDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjODqfSe9gXNVg
	cYhRgINRiYd3wZkZIUKsiWXFlbmHGCU4mJVEeNVbgUK8KYmVValF+fFFpTmpxYcYTYGumsgs
	JZqcD0wceSXxhsYmZkaWRuaGFkbG5krivEr2bSFCAumJJanZqakFqUUwfUwcnFINjI2hQavD
	21fPY9sQ3LtLtT+6XNHu7a2+5fl7roXp88yWmBvhdXatnpiSQU7HgmK7qk791mKvNdv08mZL
	SDV/eGR+5feDBcctWa8a5y7rku9rOvKSN2xNxc2QaZHHN5kbTlwv+X+5bRCLzxsXR64tfz0u
	HgoI0V51ptRXeE7Tk4ucSZamto+slFiKMxINtZiLihMBacf7d+QCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add dt node for PPMU_CPU/DMC0/DMC1 for exynos4412-trats2 board.
Each PPMU dt node includes one event of 'PPMU Count 3'

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index dd9ac66..9b98258 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -811,6 +811,36 @@
 	};
 };
 
+&ppmu_cpu {
+	status = "okay";
+
+	events {
+		ppmu_cpu_3: ppmu-event3-cpu {
+			event-name = "ppmu-event3-cpu";
+		};
+	};
+};
+
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
 &pinctrl_0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&sleep0>;
-- 
1.8.5.5

