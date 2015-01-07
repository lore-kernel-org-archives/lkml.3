Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbbAGXwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:52:11 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:16978 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990AbbAGXv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:51:27 -0500
X-AuditID: cbfee68d-f79296d000004278-4e-54adc6785493
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv7 10/10] ARM: dts: exynos: Add PPMU node for Exynos4412-based
 TRATS2 board
Date: Thu, 08 Jan 2015 08:51:17 +0900
Message-id: <1420674677-3077-11-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1420674677-3077-1-git-send-email-cw00.choi@samsung.com>
References: <1420674677-3077-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWyRsSkWLfi2NoQgwnnZCwer1nMZLFxxnpW
	i+tfnrNaTLo/gcXi9QtDi/7Hr5ktzja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27ReveI+wWq3b9YXQQ8Fgzbw2jx85Zd9k9Fu95yeSxaVUnm8fmJfUefVtWMXp8
	3iQXwB7FZZOSmpNZllqkb5fAlXFwz1LWgj9cFf9O9DI3MH7i6GLk5JAQMJFYffQqK4QtJnHh
	3nq2LkYuDiGBpYwSH29OYoUpuv/oEzNEYhGjRG/fNCYIp4lJomXKVrAqNgEtif0vbrCB2CIC
	ehKdx/awg9jMAn+YJJo2sXQxcnAIC8RIbFjlDRJmEVCV+HbgGFg5r4CrxMIHEK0SAgoSy5bP
	BBvJCRRfunkhM4gtJOAi8bLnFyPIXgmBt+wSd09tYoUYJCDxbfIhsPkSArISmw4wQ8yRlDi4
	4gbLBEbhBYwMqxhFUwuSC4qT0osM9YoTc4tL89L1kvNzNzECI+r0v2e9OxhvH7A+xCjAwajE
	w1vQtyZEiDWxrLgy9xCjKdCGicxSosn5wLjNK4k3NDYzsjA1MTU2Mrc0UxLnVZT6GSwkkJ5Y
	kpqdmlqQWhRfVJqTWnyIkYmDU6qBkWNFpGLC5TqZuUelHQy1PDmzJsl5BM3Ucs5YbRC2cUpi
	x56mu+eLbgj2r1hkkSD/TOGhfoP6gfkLgjXWOd278KWNJ/5/16sZrVdPTqgsj7t88+Bxw6/P
	5vFoxCq+vqDYFSF+ZX/U3WslNf+r4mdxyTKLvV7voxpf1GFU7N18KCmtMrdI9HyFEktxRqKh
	FnNRcSIAxUhtaKMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jAd2KY2tDDO5tFLF4vGYxk8XGGetZ
	La5/ec5qMen+BBaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFq17j7BbrNr1h9FBwGPNvDWMHjtn3WX3WLznJZPHplWdbB6bl9R79G1Zxejx
	eZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtDxSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMg3uWshb84ar4d6KX
	uYHxE0cXIyeHhICJxP1Hn5ghbDGJC/fWs3UxcnEICSxilOjtm8YE4TQxSbRM2coKUsUmoCWx
	/8UNNhBbREBPovPYHnYQm1ngD5NE0yaWLkYODmGBGIkNq7xBwiwCqhLfDhwDK+cVcJVY+ACi
	VUJAQWLZ8plgIzmB4ks3LwQ7QkjAReJlzy/GCYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXr
	JefnbmIEx+sz6R2MqxosDjEKcDAq8fAW9K0JEWJNLCuuzD3EKMHBrCTCu7ZtbYgQb0piZVVq
	UX58UWlOavEhRlOgqyYyS4km5wNTSV5JvKGxiZmRpZG5oYWRsbmSOK+SfVuIkEB6Yklqdmpq
	QWoRTB8TB6dUA2OFkvx8+2vh821SuNIO33v0jcdsZSn/59f9C6/GhDSbZviZuapMc7a6vDh6
	189jWTfy/dneKiw/u3y1aLGCdC77c2sVJfaZUf/V1h3RPVLNNumI1dSi59mLQ1xunXvae3n/
	M/9lxybLnuM9lTYnqO5Ts9SvAy9djpWYT49UPeJcYNRkF1w4/4YSS3FGoqEWc1FxIgBypZbU
	7QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add dt node for PPMU_{DMC0|DMC1|LEFTBUS|RIGHTBUS} for
exynos4412-trats2 board. Each PPMU dt node includes one event of 'PPMU Count3'.

Cc: Kukjin Kim <kgene@kernel.org>
Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts | 40 +++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index c9b70b6..bee0eed 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -877,6 +877,46 @@
 	};
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
 &pinctrl_0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&sleep0>;
-- 
1.8.5.5

