Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934728AbaLLKcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 05:32:43 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:63561 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933474AbaLLKcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 05:32:39 -0500
X-AuditID: cbfee68e-f79b46d000002b74-f6-548ac4452210
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-input@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v6 2/2] ARM: dts: Add haptic node for exynos3250-rinato
Date: Fri, 12 Dec 2014 19:32:29 +0900
Message-id: <1418380349-32588-3-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1418380349-32588-1-git-send-email-jaewon02.kim@samsung.com>
References: <1418380349-32588-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsWyRsSkWNf1SFeIwc9LQhbXvzxntTi86AWj
	xY6GI6wWvQuuslnc/PSN1eLyrjlsFjPO72NyYPfYOesuu0ffllWMHp83yQUwR3HZpKTmZJal
	FunbJXBlPLwiVnCDtWJNTyt7A+NNli5GTg4JAROJ1v7l7BC2mMSFe+vZuhi5OIQEljJKPN1+
	kBWm6OzSeVCJRYwSO1Z3s0M4bUwSH141MoJUsQloS3xfvxisQ0QgVOLzhVnMIEXMAhsZJX49
	ugyU4OAQFnCXmNCWBlLDIqAq0TvjM9hqXgEPiSULDjOClEgIKEjMmWQDEuYU8JRY8mc7WIkQ
	UMn7fxvA9koIdLNLvJ26mQVijoDEt8mHWCB6ZSU2HWCGOFpS4uCKGywTGIUXMDKsYhRNLUgu
	KE5KLzLSK07MLS7NS9dLzs/dxAgM6NP/nvXtYLx5wPoQowAHoxIP74vUrhAh1sSy4srcQ4ym
	QBsmMkuJJucD4yavJN7Q2MzIwtTE1NjI3NJMSZw3QepnsJBAemJJanZqakFqUXxRaU5q8SFG
	Jg5OqQbGyZPq51Svmd7597hb93r+hKptd3z8dxSyrnr4xNVSjv/a1H/h+SduTyvbrXX3Z1L8
	iaUn0rdu0DBSO8v6x3pO3pdzuxzOX2+NKU/9a/N60ZdELvsVvMqG53/7rr0VKTnb+lPkdVOe
	3yyXKqy+5vfdzeh+5LdTdsOp76f8Qqe1hF345nGn5vEyLSWW4oxEQy3mouJEALTF2TFjAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsVy+t9jAV3XI10hBg+2cltc//Kc1eLwoheM
	FjsajrBa9C64ymZx89M3VovLu+awWcw4v4/Jgd1j56y77B59W1YxenzeJBfAHNXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmPHwiljBDdaKNT2t7A2MN1m6GDk5JARMJM4u
	nccGYYtJXLi3Hsjm4hASWMQosWN1NzuE08Yk8eFVIyNIFZuAtsT39YtZQWwRgVCJzxdmMYMU
	MQtsZJT49egyUIKDQ1jAXWJCWxpIDYuAqkTvjM/sIDavgIfEkgWHGUFKJAQUJOZMsgEJcwp4
	Siz5sx2sRAio5P2/DewTGHkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOl2dSOxhX
	NlgcYhTgYFTi4X2R2hUixJpYVlyZe4hRgoNZSYT3bxRQiDclsbIqtSg/vqg0J7X4EKMp0FET
	maVEk/OBsZxXEm9obGJmZGlkbmhhZGyuJM6rZN8WIiSQnliSmp2aWpBaBNPHxMEp1cAYkMp6
	nXemdOTblhlWx/if/Qp6efhHI9vNRkX29rllr5vjCo77n/pWPnWmpMq1vvMOEjVznk7bosUu
	8IpfUrbwAHOvVHrLlD0NX6WTzkj2uL+/a5utyJN6465JbN7L+59SIpyvPl3J6s2/exPTGvc9
	t/er7AqdJy14+Mi38Nstdu9yp4WwvWpUYinOSDTUYi4qTgQAEdRIqq0CAAA=
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

