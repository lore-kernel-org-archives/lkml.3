Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaL2AFM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 19:05:12 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:36389 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbaL2AEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 19:04:32 -0500
X-AuditID: cbfee68e-f79b46d000002b74-9e-54a09a871fba
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv6 9/9] ARM: dts: exynos: Add PPMU node for Exynos4412-based
 TRATS2 board
Date: Mon, 29 Dec 2014 09:04:13 +0900
Message-id: <1419811453-16160-10-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1419811453-16160-1-git-send-email-cw00.choi@samsung.com>
References: <1419811453-16160-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI2JSots+a0GIwfsvmhaP1yxmsrj+5Tmr
	xfwj51gtJt2fwGLx+oWhRe+Cq2wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8li6fWLTBa3
	G1ewWTxe8ZbdYtWuP4wO/B5r5q1h9Ng56y67x+I9L5k8Ni+p9+jbsorR4/MmuQC2KC6blNSc
	zLLUIn27BK6MrU+nsxb85ayYenQnUwNjE0cXIyeHhICJxO27NxghbDGJC/fWs3UxcnEICSxl
	lFjXf4oVpqjn63UmiMR0RonO10fYIZwmJom9W6aBVbEJaEnsf3GDDcQWEZCRuLpxOwtIEbNA
	I7PEl2X/gdo5OIQFoiSObMsDqWERUJVY/L+fDSTMK+AmMeWROsQyBYlly2eCjeQECu85cYMZ
	xBYScJU4//8gK8hICYF77BIP1u1lgZgjIPFt8iEWkDkSArISmw4wQ8yRlDi44gbLBEbhBYwM
	qxhFUwuSC4qT0ouM9IoTc4tL89L1kvNzNzECo+f0v2d9OxhvHrA+xCjAwajEwzvh2PwQIdbE
	suLK3EOMpkAbJjJLiSbnA2M0ryTe0NjMyMLUxNTYyNzSTEmcN0HqZ7CQQHpiSWp2ampBalF8
	UWlOavEhRiYOTqkGxrKLHLu3X5LW6k38s7T17Uxd/pzS1OqwIL7Kb6++uP/Rj574PNqLNXbt
	rAjVLe21N3ZUvN0jzHw7eluVr3ndz82zP8T8kWPtVN+wkG8bo0XNhr9qX5sNru499/Pm0W0C
	IasF1io/tmBq1Njrr92lxvbL9H1WqYlzpuqXI4K9LLl3k2YKnPCrVWIpzkg01GIuKk4EANsL
	GW6ZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t9jQd32WQtCDBZtUrR4vGYxk8X1L89Z
	LeYfOcdqMen+BBaL1y8MLXoXXGWzONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFqt2/WF04PdYM28No8fOWXfZPRbvecnksXlJvUffllWMHp83yQWwRTUw2mSk
	JqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAnaykUJaYUwoU
	CkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzNj6dDprwV/OiqlHdzI1MDZxdDFyckgI
	mEj0fL3OBGGLSVy4t56ti5GLQ0hgOqNE5+sj7BBOE5PE3i3TWEGq2AS0JPa/uMEGYosIyEhc
	3bidBaSIWaCRWeLLsv9Aozg4hAWiJI5sywOpYRFQlVj8v58NJMwr4CYx5ZE6xDIFiWXLZ4KN
	5AQK7zlxgxnEFhJwlTj//yDrBEbeBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCY/OZ
	9A7GVQ0WhxgFOBiVeHgnHJsfIsSaWFZcmXuIUYKDWUmE16hsQYgQb0piZVVqUX58UWlOavEh
	RlOgoyYyS4km5wPTRl5JvKGxiZmRpZG5oYWRsbmSOK+SfVuIkEB6YklqdmpqQWoRTB8TB6dU
	A2PCBfOWx/oXyg+kR0+wZtfybYmYeFIySlngyi7PKVqCqkx6R+3c+ub+ikr/u7i9+O9tvsB/
	op75+x6bbb8xWfW+UMsLtXulW/Zz6LX9P1AReYL5SemKdvW3cx68vnVxlf79vs0Xv1V1eVx8
	+V722PfKlXJPV7pJ7z6fELB1x+2y+xZPPDtYWo4qsRRnJBpqMRcVJwIANuY/yeMCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add dt node for PPMU_{DMC0|DMC1|LEFTBUS|RIGHTBUS} for
exynos4412-trats2 board. Each PPMU dt node includes one event of 'PPMU Count3'.

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

