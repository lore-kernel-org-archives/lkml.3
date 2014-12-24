Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbaLXFqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 00:46:24 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:63636 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaLXFpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 00:45:43 -0500
X-AuditID: cbfee68f-f791c6d000004834-80-549a5300853d
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v2 3/4] ARM: dts: Enable USB node for exynos3250-rinato
Date: Wed, 24 Dec 2014 14:45:32 +0900
Message-id: <1419399933-3707-4-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1419399933-3707-1-git-send-email-jaewon02.kim@samsung.com>
References: <1419399933-3707-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWyRsSkWJcxeFaIQd86RovrX56zWuxoOMJq
	0f/4NbPF5V1z2CxmnN/HZLFoWSuzxdojd9kd2D02repk8+jbsorR4/MmuQDmKC6blNSczLLU
	In27BK6MPTt2MhUcYq1ovXSOpYHxCEsXIyeHhICJxIs9G9kgbDGJC/fWg9lCAksZJeZsNoSp
	mbl9BlCcCyi+iFHiyeFtUEVtTBLLZnqD2GwC2hLf1y9m7WLk4BAR8JNY9lIXpJ5ZYD2jxI4N
	t8DqhQXcJVYt2sUIYrMIqEpc/buHGcTmBYrPmriZBaRXQkBBYs4kG5Awp4CHxNOtBxkhVrlL
	/Fz7gBVkpoRAP7vE1xVLWCDmCEh8m3wIqldWYtMBZoibJSUOrrjBMoFReAEjwypG0dSC5ILi
	pPQiY73ixNzi0rx0veT83E2MwHA+/e9Z/w7GuwesDzEKcDAq8fAuODMjRIg1say4MvcQoynQ
	honMUqLJ+cCoySuJNzQ2M7IwNTE1NjK3NFMS510o9TNYSCA9sSQ1OzW1ILUovqg0J7X4ECMT
	B6dUA2ONtd9bKef1npe2ta7+1P72Zevphonq35Nu37+/36okrdIwh2fy4Sn/VqRe4AwV0l+v
	YlA1Wyr4yfflVlPm2jA9t0g2+rlR4ivnJcf5osfPKTJ/32a8y+3uTI777xdKJPziPtx9QkSf
	52eDY8uTCdfvOWkf0DyvkT1BOrFktsSMKVJvi/cZlBxUYinOSDTUYi4qTgQAn9UdmGICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsVy+t9jAV2G4FkhBof3mVtc//Kc1WJHwxFW
	i/7Hr5ktLu+aw2Yx4/w+JotFy1qZLdYeucvuwO6xaVUnm0ffllWMHp83yQUwRzUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZuzZsZOp4BBrReulcywNjEdYuhg5OSQETCRm
	bp/BBmGLSVy4tx7I5uIQEljEKPHk8DawhJBAG5PEspneIDabgLbE9/WLWbsYOThEBPwklr3U
	BalnFljPKLFjwy2wemEBd4lVi3YxgtgsAqoSV//uYQaxeYHisyZuZgHplRBQkJgzyQYkzCng
	IfF060FGiFXuEj/XPmCdwMi7gJFhFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwvDyT3sG4
	qsHiEKMAB6MSD++CMzNChFgTy4orcw8xSnAwK4nw6tyYGSLEm5JYWZValB9fVJqTWnyI0RTo
	qInMUqLJ+cBYziuJNzQ2MTOyNDI3tDAyNlcS51WybwsREkhPLEnNTk0tSC2C6WPi4JRqYJRJ
	UbZcqFSayv3YW/PatQ0eStOmt/6USHhzM0ZDOM9wzcIFfCf+/byic3xGfuxp0ycHf2799Cnh
	synn7QPXt31Ru+LIvtTM/URxVXBIgHV7ycek8mzed8VK7OpLtn6c23/+/bbf91fomllyKqzn
	CQmfcnbPii6P6f9zOm1ZPGpPJTg+DDy4yUSJpTgj0VCLuag4EQBpp2EGrQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables hsotg and usbphy node to use USB 2.0 Device.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
---
 arch/arm/boot/dts/exynos3250-rinato.dts |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index 80aa8b4..bf4c17b 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -125,6 +125,16 @@
 	};
 };
 
+&exynos_usbphy {
+	status = "okay";
+};
+
+&hsotg {
+	vusb_d-supply = <&ldo15_reg>;
+	vusb_a-supply = <&ldo12_reg>;
+	status = "okay";
+};
+
 &i2c_0 {
 	#address-cells = <1>;
 	#size-cells = <0>;
-- 
1.7.9.5

