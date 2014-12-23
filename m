Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbaLWMrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 07:47:22 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:17765 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981AbaLWMq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 07:46:57 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-28-5499642ff114
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene@kernel.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH 3/4] ARM: dts: Enable USB node for exynos3250-rinato
Date: Tue, 23 Dec 2014 21:46:31 +0900
Message-id: <1419338792-22853-4-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1419338792-22853-1-git-send-email-jaewon02.kim@samsung.com>
References: <1419338792-22853-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWyRsSkRFc/ZWaIwek9ghbXvzxntdjRcITV
	ov/xa2aLy7vmsFnMOL+PyWLRslZmBzaPTas62Tz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr
	Y8+OnUwFh1grWi+dY2lgPMLSxcjJISFgIrFny2xmCFtM4sK99WxdjFwcQgJLGSW2zT7BCFN0
	qX06K0RiOqPE1pcz2CGcNiaJX6svg41iE9CW+L5+MVAVB4eIgKLE5gUKIDXMAusZJXZsuMUG
	UiMs4CJx5vFzsHUsAqoSfb3n2EFsXgEPiTk7v7GD9EoIKEjMmWQDYnIKeEos3KkHUiEEVLFp
	ySSwtRIC7ewSs+YeYIIYIyDxbfIhFohWWYlNB6CekZQ4uOIGywRG4QWMDKsYRVMLkguKk9KL
	TPSKE3OLS/PS9ZLzczcxAsP49L9nE3Yw3jtgfYhRgINRiYd34ZkZIUKsiWXFlbmHGE2BNkxk
	lhJNzgdGS15JvKGxmZGFqYmpsZG5pZmSOO9rqZ/BQgLpiSWp2ampBalF8UWlOanFhxiZODil
	Ghgt5+tmq8nsVP9jrh10Re9WyoHrl1wPGH6YdVad92SnMusHuRxNlreNAXwdjVaSNbe79s/Z
	zlW0Vmiavv7yPY1ex792RawUYFdly1r+8rLa39nX4s/zMs887xnV1vv/SLeHiqXFkxb5V8Gy
	V1+9/qq2VPKs/VWDi15dP7WCVh4U3mtxXIfz+G8lluKMREMt5qLiRAAkBvu3XgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jQV39lJkhBt3d3BbXvzxntdjRcITV
	ov/xa2aLy7vmsFnMOL+PyWLRslZmBzaPTas62Tz6tqxi9Pi8SS6AOaqB0SYjNTEltUghNS85
	PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLGSQlliTilQKCCxuFhJ3w7T
	hNAQN10LmMYIXd+QILgeIwM0kLCGMWPPjp1MBYdYK1ovnWNpYDzC0sXIySEhYCJxqX06K4Qt
	JnHh3nq2LkYuDiGB6YwSW1/OYIdw2pgkfq2+DNbBJqAt8X39YqAODg4RAUWJzQsUQGqYBdYz
	SuzYcIsNpEZYwEXizOPnzCA2i4CqRF/vOXYQm1fAQ2LOzm/sIL0SAgoScybZgJicAp4SC3fq
	gVQIAVVsWjKJfQIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwVHyTHoH46oGi0OM
	AhyMSjy8C87MCBFiTSwrrsw9xCjBwawkwqscODNEiDclsbIqtSg/vqg0J7X4EKMp0E0TmaVE
	k/OBEZxXEm9obGJmZGlkbmhhZGyuJM6rZN8WIiSQnliSmp2aWpBaBNPHxMEp1cA4zaWn2fJS
	5Ko2I5GpnAfM1hy+sMj1fPy1wplrnU+KnI3i632T4aGbE+DhNOvenfmqkwU15fyPXj9n2p3k
	9Jd96ed6TtFVS52mVIv+WjBVK7ejuWKTVVTemq+d5jUh0/40mAldm+llwd71oV5q8it/Ua6t
	jkdj49yDN+qVvu97nfD1q899xu9KLMUZiYZazEXFiQAFig9CqAIAAA==
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

