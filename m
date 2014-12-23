Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbaLWDTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 22:19:54 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:20492 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626AbaLWDS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 22:18:27 -0500
X-AuditID: cbfee68e-f79b46d000002b74-5a-5498defb114a
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv5 8/9] ARM: dts: exynos: Add PPMU node to Exynos3250-based
 Rinato board
Date: Tue, 23 Dec 2014 12:18:16 +0900
Message-id: <1419304697-14789-9-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1419304697-14789-1-git-send-email-cw00.choi@samsung.com>
References: <1419304697-14789-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42JZI2JSpPvn3owQg1VNzBaP1yxmsrj+5Tmr
	xfwj51gtJt2fwGLx+oWhRe+Cq2wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8li6fWLTBa3
	G1ewWTxe8ZbdYtWuP4wO/B5r5q1h9Ng56y67x+I9L5k8Ni+p9+jbsorR4/MmuQC2KC6blNSc
	zLLUIn27BK6Mi6ejC65yVTy8foCtgfEcRxcjB4eEgInEtL1lXYycQKaYxIV769m6GLk4hASW
	Mko0PZjEClNz+ZIZRHwRo8SZWRvYIZwmJom/h74ygXSzCWhJ7H9xgw3EFhGQkbi6cTsLSBGz
	QCOzxJdl/8GKhAUiJV537GMEsVkEVCWuz3jACmLzCrhKNN74xgpxhoLEsuUzwWxOATeJP/Oe
	gtlCQDUTO64zgQyVELjFLjF/+kZmiEECEt8mH2KBOFVWYtMBZog5khIHV9xgmcAovICRYRWj
	aGpBckFxUnqRkV5xYm5xaV66XnJ+7iZGYOyc/vesbwfjzQPWhxgFOBiVeHh/npsRIsSaWFZc
	mXuI0RRow0RmKdHkfGCE5pXEGxqbGVmYmpgaG5lbmimJ8yZI/QwWEkhPLEnNTk0tSC2KLyrN
	SS0+xMjEwSnVwMji9P7AHv+ku6IVmbs+XDjjf+rTcoldK1YIbrYM2n517XLrj8tvL3j+Pbs2
	T5jtc7clozSD64HTSbwHJwoUbM+dw+PivsvuY7SRkWe/ipfZvHI9h2t6yjejE92+ZGzoEV3C
	e+GzSuUG/piMvUmme+Z+Phr5wOB74+uT0Qtr+f5khrP3PuKa/VCJpTgj0VCLuag4EQC2eqGV
	mAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t9jAd3f92aEGMxca27xeM1iJovrX56z
	Wsw/co7VYtL9CSwWr18YWvQuuMpmcbbpDbvFpsfXWC0u75rDZvG59wijxYzz+5gsll6/yGRx
	u3EFm8XjFW/ZLVbt+sPowO+xZt4aRo+ds+6yeyze85LJY/OSeo++LasYPT5vkgtgi2pgtMlI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOllJoSwxpxQo
	FJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmHHxdHTBVa6Kh9cPsDUwnuPoYuTgkBAw
	kbh8yayLkRPIFJO4cG89WxcjF4eQwCJGiTOzNrBDOE1MEn8PfWUCqWIT0JLY/+IGG4gtIiAj
	cXXjdhaQImaBRmaJL8v+gxUJC0RKvO7YxwhiswioSlyf8YAVxOYVcJVovPGNFWKdgsSy5TPB
	bE4BN4k/856C2UJANRM7rjNNYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Np9J
	72Bc1WBxiFGAg1GJh3fBmRkhQqyJZcWVuYcYJTiYlUR41VuBQrwpiZVVqUX58UWlOanFhxhN
	ga6ayCwlmpwPTBt5JfGGxiZmRpZG5oYWRsbmSuK8SvZtIUIC6YklqdmpqQWpRTB9TBycUg2M
	ySnHp5xZtUa4oGz/aZ/FandOZMgpHdQ8vvisjN1z61evvhkkJIgusQrVOKs1MS3vl0S/6wJ+
	rVNvrh81a2bQT5nPu+i05WG293tjpqZYc2ULCGnGKrZHByoH2uQIWv1mqKmsujPFrpe5hHlt
	QdC9T8HLJT/u9WDNFlHVtL5VyBx4a/IBHQslluKMREMt5qLiRADKLImQ4wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add PPMU dt node to Exynos3250-base Rinato board. The PPMU dt node
is used to get the utilization of DMC0/DMC1/LEFTBUS/RIGHTBUS Block.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250-rinato.dts | 40 +++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index 7789442..11942b0 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -542,6 +542,46 @@
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

