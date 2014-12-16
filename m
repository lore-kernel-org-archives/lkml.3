Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbaLPX3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 18:29:14 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:50157 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbaLPX1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 18:27:07 -0500
X-AuditID: cbfee68d-f79296d000004278-79-5490bfc51660
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv4 8/8] ARM: dts: exynos: Add PPMU dt node to Exynos3250-based
 Rinato board
Date: Wed, 17 Dec 2014 08:26:57 +0900
Message-id: <1418772417-5164-9-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1418772417-5164-1-git-send-email-cw00.choi@samsung.com>
References: <1418772417-5164-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI2JSqHt0/4QQg6mtphaP1yxmsrj+5Tmr
	xfwj51gtJt2fwGLx+oWhRe+Cq2wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8li6fWLTBa3
	G1ewWTxe8ZbdYtWuP4wO/B5r5q1h9Ng56y67x+I9L5k8Ni+p9+jbsorR4/MmuQC2KC6blNSc
	zLLUIn27BK6Mi6ejC65yVTy8foCtgfEcRxcjJ4eEgInEhNuL2CBsMYkL99YD2VwcQgJLGSUe
	7/nMAlN0/NIeZojEIkaJ/RfmMYEkhASamCRuX1cGsdkEtCT2v7gBNklEQEbi6sbtLCANzAKN
	zBJflv0HaxAWiJFYPPkqWBGLgKrE+mk3wDbwCrhIPL+zkR1im4LEsuUzWUFsTgFXiZYbq6GW
	uUh0Xt3JCjJUQuAWu8Sv2Y/ZIQYJSHybfAhoEAdQQlZi0wFmiDmSEgdX3GCZwCi8gJFhFaNo
	akFyQXFSepGhXnFibnFpXrpecn7uJkZg9Jz+96x3B+PtA9aHGAU4GJV4eH/k9YcIsSaWFVfm
	HmI0BdowkVlKNDkfGKN5JfGGxmZGFqYmpsZG5pZmSuK8ilI/g4UE0hNLUrNTUwtSi+KLSnNS
	iw8xMnFwSjUw1njVPCrbM7dU+5YFSy/HjejXfhk6vm566hcuy/YYVnd+8Kx8fy82TMrxupDd
	Nf+ibcsZ4xmn5DrrLCszecRu7Manvp43Z4/M202W3x9dzJfvnPn3OuvzWdnzPqc92tz74Mjy
	BB7vOO/PSg4uYt5XO7hkdVj8W2Z9Tzi7c9q/eI+WV3cSFjgpsRRnJBpqMRcVJwIAr6kzNpkC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t9jAd2j+yeEGDzs17F4vGYxk8X1L89Z
	LeYfOcdqMen+BBaL1y8MLXoXXGWzONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFqt2/WF04PdYM28No8fOWXfZPRbvecnksXlJvUffllWMHp83yQWwRTUw2mSk
	JqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAnaykUJaYUwoU
	CkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzLh4OrrgKlfFw+sH2BoYz3F0MXJySAiY
	SBy/tIcZwhaTuHBvPVsXIxeHkMAiRon9F+YxgSSEBJqYJG5fVwax2QS0JPa/uMEGYosIyEhc
	3bidBaSBWaCRWeLLsv9gDcICMRKLJ18FK2IRUJVYP+0GC4jNK+Ai8fzORnaIbQoSy5bPZAWx
	OQVcJVpurIZa5iLReXUn6wRG3gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgmPzmfQO
	xlUNFocYBTgYlXh4Awv7Q4RYE8uKK3MPMUpwMCuJ8FosmhAixJuSWFmVWpQfX1Sak1p8iNEU
	6KqJzFKiyfnAtJFXEm9obGJmZGlkbmhhZGyuJM6rZN8WIiSQnliSmp2aWpBaBNPHxMEp1cDI
	f+pB5avtp+ffe7z41r/smAVRh/+nBq2rrVe/qdge+XsqE0/wxw0ifw/m7qyra4uaZ39c1nXL
	3TcLHjO+KrCyPP3HWGbVqfySvRsPrYh8cWK5fqR6DftvF9kn97kfcMn0PN0te1dbaOrq5Bnf
	5rxW0Jm2ZW56wz1XregUg6olfL3z18hNici7q8RSnJFoqMVcVJwIAJhsvBPjAgAA
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

