Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbaI2FR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 01:17:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:31737 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaI2FRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 01:17:25 -0400
X-AuditID: cbfee691-f79b86d000004a5a-68-5428eb63e25a
From: Abhilash Kesavan <a.kesavan@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, gregkh@linuxfoundation.org, jslaby@suse.cz,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH] serial: samsung: Fix serial config dependencies for exynos7
Date: Mon, 29 Sep 2014 10:46:57 +0530
Message-id: <1411967817-8423-1-git-send-email-a.kesavan@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsWyRsSkTjf5tUaIwYujMhZ/Jx1jt2hevJ7N
	4vPvXawWmx5fY7W4vGsOm8WM8/uYLBZt/cLuwO7x+9ckRo/9c9ewe2xeUu/Rt2UVo8eZBUfY
	PT5vkgtgi+KySUnNySxLLdK3S+DKuN/5iq3gNm/FwW8HWRsYN3N3MXJySAiYSPR/2cEGYYtJ
	XLi3HswWEljKKPFiojBMzfwn51m7GLmA4osYJSY3fIVy+pgk+o8dZQKpYhPQk1jw7ysziC0i
	oCExpesxO0gRs8BqRollXSfAxgoL+Ej0TzwCVsQioCrxblsTWDOvgIvEifbdQA0cQOsUJOZM
	soHY3M0u0f0hG6JcQOLb5EMsECWyEpsOMEOUSEocXHGDZQKj4AJGhlWMoqkFyQXFSelFpnrF
	ibnFpXnpesn5uZsYgcF7+t+ziTsY7x+wPsQowMGoxMPLsUIjRIg1say4MvcQoynQhonMUqLJ
	+cAYySuJNzQ2M7IwNTE1NjK3NFMS59WR/hksJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgXGy
	85q5No/z8lqiF07cVXfueBGLdFZotTaz7epHbP9mx5n+4nuwNPFBz+znMz6Kpz3buWT+/1zv
	yV41e7x0Tq60DXHaKKp69GhPWrTbH//pMa5x1e/qAz5eCTr9cNd19t9OlV+VZkoyCjdnf9/q
	cJGpNSvXOUzOaGfHDu6LMieMDin+f/khyEGJpTgj0VCLuag4EQAf6FPDWQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t9jAd3k1xohBg/Pi1j8nXSM3aJ58Xo2
	i8+/d7FabHp8jdXi8q45bBYzzu9jsli09Qu7A7vH71+TGD32z13D7rF5Sb1H35ZVjB5nFhxh
	9/i8SS6ALaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DX
	LTMH6BYlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8b9zldsBbd5Kw5+
	O8jawLiZu4uRk0NCwERi/pPzrBC2mMSFe+vZuhi5OIQEFjFKTG74ygrh9DFJ9B87ygRSxSag
	J7Hg31dmEFtEQENiStdjdpAiZoHVjBLLuk6wgSSEBXwk+iceAStiEVCVeLetCayZV8BF4kT7
	bqAGDqB1ChJzJtlMYORewMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Pp5J72Bc1WBx
	iFGAg1GJh5djhUaIEGtiWXFl7iFGCQ5mJRFehdfqIUK8KYmVValF+fFFpTmpxYcYTYGWT2SW
	Ek3OB8ZuXkm8obGJuamxqaWJhYmZpZI478FW60AhgfTEktTs1NSC1CKYPiYOTqkGxvUvT0ga
	XJDp7Q3L+HMlZX/RTbVFB6XNGX9KpHW+Cj2lqu/8YwVLofHDQ1YLYooS7j4NYlUNtlpmaqzr
	Wvp+eqC+d9fx3f4r3z+fFHvMfXW5Lpvx8kUqt1QX//mtffrsueY1i++5vX3vHlHWcHrxiz1v
	1jhvZP3eedA8+M3bNxf/JBhUnzDbyqDEUpyRaKjFXFScCACJFOB6pQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pankaj Dubey <pankaj.dubey@samsung.com>

Exynos7 has a similar serial controller to that present in older Samsung
SoCs. To re-use the existing serial driver on Exynos7 we need to have
SERIAL_SAMSUNG_UARTS_4 and SERIAL_SAMSUNG_UARTS selected. This is not
possible because these symbols are dependent on PLAT_SAMSUNG which is
not present for the ARMv8 based exynos7.

Change the dependency of these symbols from PLAT_SAMSUNG to the serial
driver thus making it available on exynos7. As the existing platform
specific code making use of these symbols is related to uart driver this
change in dependency should not cause any issues.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Build tested with s3c6400_defconfig, exynos_defconfig and arm64's defconfig
with and without the serial driver enabled.

 drivers/tty/serial/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 81f6ee7..e6c0bcb 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -249,14 +249,14 @@ config SERIAL_SAMSUNG
 
 config SERIAL_SAMSUNG_UARTS_4
 	bool
-	depends on PLAT_SAMSUNG
+	depends on SERIAL_SAMSUNG
 	default y if !(CPU_S3C2410 || CPU_S3C2412 || CPU_S3C2440 || CPU_S3C2442)
 	help
 	  Internal node for the common case of 4 Samsung compatible UARTs
 
 config SERIAL_SAMSUNG_UARTS
 	int
-	depends on PLAT_SAMSUNG
+	depends on SERIAL_SAMSUNG
 	default 4 if SERIAL_SAMSUNG_UARTS_4 || CPU_S3C2416
 	default 3
 	help
-- 
1.7.9.5

