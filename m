Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbbAGOIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:08:43 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:10368 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbbAGOIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:08:34 -0500
X-AuditID: cbfee68d-f79296d000004278-1c-54ad3ddaf113
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene@kernel.org>
Cc: linux-samsung-soc@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        linux-kernel@vger.kernel.org, Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH RESEND v2 4/4] ARM: dts: Enable USB node for exynos3250-monk
Date: Wed, 07 Jan 2015 23:08:21 +0900
Message-id: <1420639701-1524-5-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420639701-1524-1-git-send-email-jaewon02.kim@samsung.com>
References: <1420639701-1524-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsWyRsSkUPeW7doQg8PfjC2uf3nOarGj4Qir
	Rf/j18wWl3fNYbOYcX4fkwOrx6ZVnWwefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfHiYX3B
	PtaKxoPcDYz7WboYOTkkBEwkvly7yQxhi0lcuLeerYuRi0NIYCmjRPP0VkaYov3tM5kgEtMZ
	Jd51r2OBcNqYJA5euA7WziagLfF9/WLWLkYODhEBRYnNCxRAapgFJjFK3Li3ghWkRljAR+LX
	1y+MIDUsAqoSi/57g5i8Au4ST1/pg5gSAgoScybZgBRzCnhI7P1zFOwEIaCKP89usYJMlBD4
	zSbRd+YU2EQWAQGJb5MPsUD0ykpsOgD1i6TEwRU3WCYwCi9gZFjFKJpakFxQnJReZKhXnJhb
	XJqXrpecn7uJERi2p/89693BePuA9SFGAQ5GJR7egr41IUKsiWXFlbmHGE2BNkxklhJNzgdG
	R15JvKGxmZGFqYmpsZG5pZmSOK+i1M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYyBUkpK
	99qSOLUYpjkzxOY+8OJ/XMh/o7Z8XvMhjfnCKgZ7DP8or1/MH5IrZcFytyTift/V5YsZk7zL
	V11IyPXTL9BYOOm1zyo239ebO3L+PV0dsuVU576UmSXek86Hzts05cDLLYwzNf8tMPp6dfHP
	Lw5pcb11jGV1kebx0dvOXvl+9Ei3lL8SS3FGoqEWc1FxIgA4Nzo9VgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e+xoO4t27UhBl879Syuf3nOarGj4Qir
	Rf/j18wWl3fNYbOYcX4fkwOrx6ZVnWwefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZdu
	q+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RTSaEsMacUKBSQWFyspG+HaUJoiJuu
	BUxjhK5vSBBcj5EBGkhYw5jx4mF9wT7WisaD3A2M+1m6GDk5JARMJPa3z2SCsMUkLtxbz9bF
	yMUhJDCdUeJd9zoWCKeNSeLghevMIFVsAtoS39cvZu1i5OAQEVCU2LxAAaSGWWASo8SNeytY
	QWqEBXwkfn39wghSwyKgKrHovzeIySvgLvH0lT6IKSGgIDFnkg1IMaeAh8TeP0cZQWwhoIo/
	z26xTmDkXcDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOCqeSe1gXNlgcYhRgINRiYe3
	oG9NiBBrYllxZe4hRgkOZiUR3je/gEK8KYmVValF+fFFpTmpxYcYTYFOmsgsJZqcD4zYvJJ4
	Q2MTMyNLI3NDCyNjcyVxXiX7thAhgfTEktTs1NSC1CKYPiYOTqkGxt79cfkXzp1YOqO7VYzT
	pqmh+sFbi8XCd0tzk+rn/JVk/HVLlu87r+6O3CZuobjVSjZ81/5rMwe1nZ2+IzeytNDe//vy
	ks/uvtplomF2x/+mTPTfsum6nlPFD8HrZsX96/vnaHqdFo5b6mtq2bPR18X0/3GbTtkO3feN
	u9jcrZSEFA4vDfumxFKckWioxVxUnAgAHlyniaACAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree node for hsotg to control USB 2.0 Device.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
---
 arch/arm/boot/dts/exynos3250-monk.dts |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-monk.dts b/arch/arm/boot/dts/exynos3250-monk.dts
index 7102d88..3f18b21 100644
--- a/arch/arm/boot/dts/exynos3250-monk.dts
+++ b/arch/arm/boot/dts/exynos3250-monk.dts
@@ -141,6 +141,16 @@
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

