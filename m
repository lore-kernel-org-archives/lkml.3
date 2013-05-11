Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab3EKHm4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 03:42:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:64791 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab3EKHmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 03:42:54 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-66-518df67c4202
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Doug Anderson'" <dianders@chromium.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ARM: dts: add DP clock reference to exynos5250 device tree
Date: Sat, 11 May 2013 16:42:52 +0900
Message-id: <003001ce4e1b$24a28fc0$6de7af40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5OGthhKW49i064RfeZCehr9b1uyg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t8zfd2ab72BBhtXalmcXXaQzeLywkus
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsjh1/TObxbEZSxgdODxmN1xk8bhzbQ+bx+Yl9R5XTjSx
	evRtWcXo8XmTXABbFJdNSmpOZllqkb5dAlfGsxvlBV1sFQsWTWRsYPzG0sXIySEhYCKx8MFm
	RghbTOLCvfVsXYxcHEICyxglvv6/zA5TtPPyVBaIxCJGiad9rYwQzi9GiV/njjCBVLEJqEl8
	+XIYrENEQEPi6e4jYEXMAt1MEkePbGUDSQgL+Essf74fzGYRUJXofNsItptXwFLi5p15TBC2
	oMSPyffA7mMW0JJYv/M4E4QtL7F5zVtmiJMUJHacfc0IsUxP4v26FYwQNSIS+168A1ssIXCL
	XeL7nVfsEMsEJL5NPgQ0lAMoISux6QDUHEmJgytusExgFJuFZPUsJKtnIVk9C8mKBYwsqxhF
	UwuSC4qT0ouM9IoTc4tL89L1kvNzNzFCYrRvB+PNA9aHGJOB1k9klhJNzgfGeF5JvKGxmZGF
	qYmpsZG5pRlpwkrivGot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGMua6ja3xK9IuDWr
	57BRT0+T3hQ/tncbbh6O3bP1Y6SI4/zH921PvD317NKV8pPTvgYHqDJf+3+qWTLMddKad3GG
	vJUS9kxCXMnte0Jbu55yPwua2TTp/OQ5wt5XU6OWzOvdqaZWbKM76+K7oANlrjem7k7SmrWQ
	t4lT+fnuX8uY9pXE/hR406XEUpyRaKjFXFScCABSzfIj5wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t9jAd2ab72BBt8a1CzOLjvIZnF54SVW
	i94FV9ksNj2+xmpxedccNosZ5/cxWZy6/pnN4tiMJYwOHB6zGy6yeNy5tofNY/OSeo8rJ5pY
	Pfq2rGL0+LxJLoAtqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxrMb5QVd
	bBULFk1kbGD8xtLFyMkhIWAisfPyVChbTOLCvfVsXYxcHEICixglnva1MkI4vxglfp07wgRS
	xSagJvHly2F2EFtEQEPi6e4jYEXMAt1MEkePbGUDSQgL+Essf74fzGYRUJXofNvICGLzClhK
	3LwzjwnCFpT4Mfke2GpmAS2J9TuPM0HY8hKb17xlhjhJQWLH2deMEMv0JN6vW8EIUSMise/F
	O8YJjAKzkIyahWTULCSjZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOAE8k97B
	uKrB4hCjAAejEg9vhVBvoBBrYllxZe4hRgkOZiUR3mcPgEK8KYmVValF+fFFpTmpxYcYk4E+
	ncgsJZqcD0xOeSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXA
	uIXvqGpTo9OLWcf8Zl8LYJlZsbtzblLFH2/brQayATxnO5K3MCn7fE3//1Lz4UpTwaabThPf
	9dhnP9Xd3Z9p+e7x0/lRequFgpnMMpX1PDvLljMX6DjrNhfe3jpzyceoPnX7vGc/li7oUd28
	c8P9C3Gmj19U3Tt4R/KKbt4pzV07Hx90lDEOUGIpzkg01GIuKk4EADgkkExEAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The transition to common clock happened; however, DP (Display Port)
clock node was not added. Thus, DP (Display Port) clock node should
be added to the device tree.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Tested on Exynos5250

 arch/arm/boot/dts/exynos5250.dtsi |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 9dfc6de..8b1f9b6 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -651,6 +651,8 @@
 		reg = <0x145b0000 0x1000>;
 		interrupts = <10 3>;
 		interrupt-parent = <&combiner>;
+		clocks = <&clock 342>;
+		clock-names = "dp";
 		#address-cells = <1>;
 		#size-cells = <0>;
 
-- 
1.7.2.5


