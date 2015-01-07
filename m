Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbbAGOCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:02:34 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:36467 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbbAGOCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:02:00 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-5d-54ad3c55050d
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene@kernel.org>
Cc: linux-samsung-soc@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        linux-kernel@vger.kernel.org, Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH RESEND 2/2] ARM: dts: exynos3250-monk: Add regulator-haptic
 node for haptics
Date: Wed, 07 Jan 2015 23:01:53 +0900
Message-id: <1420639313-897-3-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420639313-897-1-git-send-email-jaewon02.kim@samsung.com>
References: <1420639313-897-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsWyRsSkQDfUZm2IQetnOYvrX56zWuxoOMJq
	0f/4NbPF5V1z2CxmnN/H5MDqsWlVJ5tH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZfy99ZC9
	4Bxrxbdpy9gbGM+zdDFyckgImEhsfDOVEcIWk7hwbz1bFyMXh5DAUkaJibOuMcIUbf10jQnE
	FhKYzijx4xcHRFEbk8Tsw/OYQRJsAtoS39cvZu1i5OAQEVCU2LxAAaSGWWASo8SNeytYQWqE
	BeIkXq+4zgZSwyKgKtH5QRIkzCvgJnH7y2SwsISAgsScSTYgYU4Bd4nPV1awQKx1k3iwaxcj
	yEgJgf9sEgdXbAVbyyIgIPFt8iEWiF5ZiU0HmCFOlgQqucEygVF4ASPDKkbR1ILkguKk9CIT
	veLE3OLSvHS95PzcTYzA0D3979mEHYz3DlgfYhTgYFTi4S3oWxMixJpYVlyZe4jRFGjDRGYp
	0eR8YITklcQbGpsZWZiamBobmVuaKYnzvpb6GSwkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB
	UfOL4B7bnl1fHiqqL0pn5p41JWziucC5t/e5mk/M2uPAcLc59PCe7QE/7GKlWerqm8/MUE5e
	+DRGv+ZEKMvpirbaBIalOStChG9+PGUmp5blLu77XmGusamFw86vRpWOF6bP6lD6d19u3ge3
	pTtNungsizdOm71B/dhXzt0/15pITp/+cFpYlBJLcUaioRZzUXEiAO0rCPNYAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42I5/e+xoG6ozdoQg817JCyuf3nOarGj4Qir
	Rf/j18wWl3fNYbOYcX4fkwOrx6ZVnWwefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZdu
	q+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RTSaEsMacUKBSQWFyspG+HaUJoiJuu
	BUxjhK5vSBBcj5EBGkhYw5jx99ZD9oJzrBXfpi1jb2A8z9LFyMkhIWAisfXTNSYIW0ziwr31
	bCC2kMB0Rokfvzi6GLmA7DYmidmH5zGDJNgEtCW+r1/M2sXIwSEioCixeYECSA2zwCRGiRv3
	VrCC1AgLxEm8XnGdDaSGRUBVovODJEiYV8BN4vaXyWBhCQEFiTmTbEDCnALuEp+vrGCBWOsm
	8WDXLsYJjLwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRHxjPpHYyrGiwOMQpwMCrx
	8Bb0rQkRYk0sK67MPcQowcGsJML75hdQiDclsbIqtSg/vqg0J7X4EKMp0E0TmaVEk/OBUZtX
	Em9obGJmZGlkbmhhZGyuJM6rZN8WIiSQnliSmp2aWpBaBNPHxMEp1cDY8vubTZ52RYftvCeV
	j+Q4uJfVfHmws+nq2WUlZvMnORVazZphbdlcMrFsqkqtzMv1XzwOWYcWT1906Nb7u5M9+577
	vn3/m0ss6oTd0gqfT2Z1D4wmibIt37Vtr3R4idv7Va8Kdk8PWKk8MTy8IrTpWk5+r3sN63TV
	561SSpcKsuqjck3+Rc1VYinOSDTUYi4qTgQAY6JQAKICAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds regulator-haptic device node controlled by regulator.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 arch/arm/boot/dts/exynos3250-monk.dts |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-monk.dts b/arch/arm/boot/dts/exynos3250-monk.dts
index 24822aa..7102d88 100644
--- a/arch/arm/boot/dts/exynos3250-monk.dts
+++ b/arch/arm/boot/dts/exynos3250-monk.dts
@@ -109,6 +109,13 @@
 			};
 		};
 	};
+
+	haptics {
+		compatible = "regulator-haptic";
+		haptic-supply = <&motor_reg>;
+		min-microvolt = <1100000>;
+		max-microvolt = <2700000>;
+	};
 };
 
 &adc {
-- 
1.7.9.5

