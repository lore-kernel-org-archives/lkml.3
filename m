Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbaKXOv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:51:58 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:42540 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbaKXOvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:51:53 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-48-547346069709
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>, Dan Murphy <dmurphy@ti.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Hyunhee Kim <hyunhee.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v2 2/2] ARM: dts: Add regulator-haptic device node for
 exynos3250-rinato
Date: Mon, 24 Nov 2014 23:50:51 +0900
Message-id: <1416840651-17141-3-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416840651-17141-1-git-send-email-jaewon02.kim@samsung.com>
References: <1416840651-17141-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWyRsSkUJfdrTjEoHMdi8X1L89ZLQ4vesFo
	0X16C6vF5w8t7BY7Go6wWvQuuMpmcfPTN1aLy7vmsFnMOL+PyWLR1i/sDlweO2fdZffo27KK
	0eP4je1MHp83yQWwRHHZpKTmZJalFunbJXBlLDwdW7CUteLZjiWsDYyrWboYOTkkBEwkrv2Y
	xghhi0lcuLeerYuRi0NIYCmjxM7Zq1lhii787WeCSCxilNg85R87hNPGJHFo9mZmkCo2AW2J
	7+sXg3WICLxhlPi6ORykiFlgPqNE99T5YAlhgSiJVf0XwGwWAVWJE0f6wHbzCnhInPvXDzSV
	A2idgsScSTYgYU4BT4mODcfA5gsBlbx5OwPsCgmBVewSl6Z3s0PMEZD4NvkQC0SvrMSmA8wQ
	V0tKHFxxg2UCo/ACRoZVjKKpBckFxUnpRSZ6xYm5xaV56XrJ+bmbGIGhf/rfswk7GO8dsD7E
	KMDBqMTD+2FjUYgQa2JZcWXuIUZToA0TmaVEk/OBEZZXEm9obGZkYWpiamxkbmmmJM77Wupn
	sJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZG3jteU3ZEec46vNnjKf+hJp3Ukn2W+8L8zTrb
	rws9Kot81rfGLmOuR/j3v5M0H1wqf8Zf3vu8dttEk1dsMgd5lrWbm53ieVLnPichwCop8HjO
	3dv6BxfdYz257LjCCXb1JzypG659rvd7JTB5Rx/TrVeLAyu2h/2udN6e3LAg8Iz9BI2nGzcV
	K7EUZyQaajEXFScCAF05cyR4AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t9jAV02t+IQg/N7rCyuf3nOanF40QtG
	i+7TW1gtPn9oYbfY0XCE1aJ3wVU2i5ufvrFaXN41h81ixvl9TBaLtn5hd+Dy2DnrLrtH35ZV
	jB7Hb2xn8vi8SS6AJaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfV
	VsnFJ0DXLTMH6CIlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8bC07EF
	S1krnu1YwtrAuJqli5GTQ0LAROLC334mCFtM4sK99WxdjFwcQgKLGCU2T/nHDuG0MUkcmr2Z
	GaSKTUBb4vv6xawgtojAG0aJr5vDQYqYBeYzSnRPnQ+WEBaIkljVfwHMZhFQlThxpI8RxOYV
	8JA4968faCoH0DoFiTmTbEDCnAKeEh0bjoHNFwIqefN2BtMERt4FjAyrGEVTC5ILipPSc430
	ihNzi0vz0vWS83M3MYIj65n0DsZVDRaHGAU4GJV4eGesLwoRYk0sK67MPcQowcGsJMIrJlYc
	IsSbklhZlVqUH19UmpNafIjRFOioicxSosn5wKjPK4k3NDYxM7I0Mje0MDI2VxLnvXEzN0RI
	ID2xJDU7NbUgtQimj4mDU6qBUSY5YF5oWtXvhOqb9ZMu/bx80MxWr8E79xOj3sfCiAecBhIu
	vCumd9/TDf0vce/VX60eFrOeSpXd0bOqwydrtYtKLbDmmMqrEyUVMqt9gWf18S0BkzJPF4Tk
	zpnFPIf7riBvr3T9V4HD+m7THwSe9TBYvTCXabFGUiy35pKZbIavxVawpporsRRnJBpqMRcV
	JwIApNmLQMICAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds regulator-haptic device node controlled by regulator.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
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

