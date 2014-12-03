Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaLCHzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:55:55 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:23377 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbaLCHzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:55:51 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-1d-547ec1f337cc
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-input@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v5 2/2] ARM: dts: Add haptics node for exynos3250-rinato
Date: Wed, 03 Dec 2014 16:55:28 +0900
Message-id: <1417593328-8223-3-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417593328-8223-1-git-send-email-jaewon02.kim@samsung.com>
References: <1417593328-8223-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsWyRsSkWPfzwboQg9YeC4vrX56zWhxe9ILR
	YkfDEVaL3gVX2SxufvrGanF51xw2ixnn9zE5sHvsnHWX3aNvyypGj8+b5AKYo7hsUlJzMstS
	i/TtErgyHl4RK7jBWrGmp5W9gfEmSxcjJ4eEgInE4TfHGCFsMYkL99azdTFycQgJLGWU6Np1
	CCjBAVbUvNgKIr6IUeLInneMEE4bk8TZndeZQbrZBLQlvq9fzApiiwiESny+MIsZpIhZYCOj
	xK9Hl8ESwgIeEt17fzGB2CwCqhJ7Pk8Di/MKuEts6d8FtU1BYs4kGxCTE6j8zuwgEFMIqOLe
	OVmQiRIC7ewSS1ffh5oiIPFt8iEWiE5ZiU0HmCF+kZQ4uOIGywRG4QWMDKsYRVMLkguKk9KL
	TPSKE3OLS/PS9ZLzczcxAoP59L9nE3Yw3jtgfYhRgINRiYfXIq4uRIg1say4MvcQoynQhonM
	UqLJ+cCYySuJNzQ2M7IwNTE1NjK3NFMS530t9TNYSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dU
	A6PTzvOntPeK1242++52o6eFJeHCrGvZDlurVBx+Juy+un6H7mzZ5/eWLyh/tVWyMMKFd7bq
	CaVnpbnXzp2cZvry1WHHI71Na2vYf7++frNSNjp+8tTbm3adn7s4ZKszz4LrRouS3qhJ22pM
	Nb9WrJfBwiO82lyddc3swMLpQv0sab7fHk40XrJDiaU4I9FQi7moOBEASn5esmECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsVy+t9jAd3PB+tCDGbsMbS4/uU5q8XhRS8Y
	LXY0HGG16F1wlc3i5qdvrBaXd81hs5hxfh+TA7vHzll32T36tqxi9Pi8SS6AOaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMePhFbGCG6wVa3pa2RsYb7J0MXJwSAiYSDQv
	tupi5AQyxSQu3FvP1sXIxSEksIhR4sied4wQThuTxNmd15lBqtgEtCW+r1/MCmKLCIRKfL4w
	ixmkiFlgI6PEr0eXwRLCAh4S3Xt/MYHYLAKqEns+TwOL8wq4S2zp38UIsVlBYs4kGxCTE6j8
	zuwgEFMIqOLeOdkJjLwLGBlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgTHyjOpHYwrGywO
	MQpwMCrx8FrE1YUIsSaWFVfmHmKU4GBWEuFdtgMoxJuSWFmVWpQfX1Sak1p8iNEU6KSJzFKi
	yfnAOM4riTc0NjEzsjQyN7QwMjZXEue9cTM3REggPbEkNTs1tSC1CKaPiYNTqoGxZW3Zp/UO
	bzo+nZtaWzYj53tk84kj6wTMUvR1fs5xEd05/cnZvyFr/ZW4XCc2MT+uTa3NfdZsEhx3Y9Lq
	8LyIk9eazpjWFjz+smsfQ+HCP0dLV307urVzV9adM53PPGW6O5P/OG54N2njHjWvSM7XKswa
	1yb6sZVsDfUPrLWMmzE/sr3Z4FSQEktxRqKhFnNRcSIANOKpyKsCAAA=
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
 arch/arm/boot/dts/exynos3250-rinato.dts |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index 84380fa..da03005 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -104,6 +104,13 @@
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

