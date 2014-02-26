Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbaBZFIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 00:08:17 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:54579 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaBZFIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 00:08:13 -0500
X-AuditID: cbfee68e-b7f566d000002344-2e-530d76bc2cf7
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 3/3] ARM: S3C24XX: select COMMON_CLK_SAMSUNG for S3C24XX
Date: Wed, 26 Feb 2014 14:24:07 +0900
Message-id: <1393392247-6247-4-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393392247-6247-1-git-send-email-pankaj.dubey@samsung.com>
References: <1393392247-6247-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t8zY909ZbzBBquOM1lMWneAyaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd2B3aOluYfN4++qF8wem5fUe/RtWcXo8XmTXABr
	FJdNSmpOZllqkb5dAlfGgr8/mApucVR8O97N0sA4n72LkZNDQsBEovVkIyOELSZx4d56ti5G
	Lg4hgWWMEsfmr4Ir+nr/EStEYhGjxLSp7VBOG5PEoX8LwarYBHQlnryfywxiiwhkS1yadYsF
	pIhZYCajxKLVZ8ASwgIeEsd3HQCzWQRUJS5vns0CYvMKuEucON0INIgDaJ2CxJxJNiBhTqDy
	x11zwEqEgEquH9/IDDJTQmA6u8TWZTdZIOYISHybfIgFoldWYhPEeAkBSYmDK26wTGAUXsDI
	sIpRNLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMjJMj7djDePGB9iDEZaNxEZinR5HxglOSVxBsa
	mxlZmJqYGhuZW5qRJqwkzrvoYVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsbpGdn3wpwi
	TURORMYppL1kWszwK8bnrVZ11qaKI1/fL6yX+C2hpXTx1ayFG5nbHV/z2Dn4PI4VESk+8eh5
	1cHl739q7WqMPXKyxFS5x+OvT5jHBfnrahW7O16eKZZS/BDZu3WXIcPxDQu5/klN01Tzk7ql
	tXrbxdXzBMNXHb82g0kt4OHv1mQlluKMREMt5qLiRADjAB0NiAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jAd3dZbzBBpduWltMWneAyaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd2B3aOluYfN4++qF8wem5fUe/RtWcXo8XmTXABr
	VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QFUoK
	ZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjAV/fzAV3OKo+Ha8m6WBcT57
	FyMnh4SAicTX+49YIWwxiQv31rN1MXJxCAksYpSYNrWdFcJpY5I49G8hWAebgK7Ek/dzmUFs
	EYFsiUuzbrGAFDELzGSUWLT6DFhCWMBD4viuA2A2i4CqxOXNs1lAbF4Bd4kTpxuBBnEArVOQ
	mDPJBiTMCVT+uGsOWIkQUMn14xuZJzDyLmBkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kR
	HEPPpHcwrmqwOMQowMGoxMMbwMIbLMSaWFZcmXuIUYKDWUmEVzobKMSbklhZlVqUH19UmpNa
	fIgxGeioicxSosn5wPjOK4k3NDYxM7I0MrMwMjE3J01YSZz3YKt1oJBAemJJanZqakFqEcwW
	Jg5OqQbG5C9eelH7L0xdNfX5hxKdOf3O/oVe7U9N1frEag4w2OiFZxpVCxiqHOdtt1jzmjlj
	50WNVRc2np/4Z4vBc+GgaZsl/GOFbaVMaqf7u+wy2PXtzrvZG5l/q/1iD4quKY3RLVu6VuPl
	ppaKXKGF8eFPNawFbIWd/5+/qsl1jvXGMz2Z2xpiiZJKLMUZiYZazEXFiQAYkBl65QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Ben Dooks <ben-linux@fluff.org>
CC: Kukjin Kim <kgene.kim@samsung.com>
CC: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-s3c24xx/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
index 80373da..5cf82a1 100644
--- a/arch/arm/mach-s3c24xx/Kconfig
+++ b/arch/arm/mach-s3c24xx/Kconfig
@@ -40,6 +40,7 @@ config CPU_S3C2410
 config CPU_S3C2412
 	bool "SAMSUNG S3C2412"
 	select COMMON_CLK
+	select COMMON_CLK_SAMSUNG
 	select CPU_ARM926T
 	select CPU_LLSERIAL_S3C2440
 	select S3C2412_COMMON_CLK
@@ -51,6 +52,7 @@ config CPU_S3C2412
 config CPU_S3C2416
 	bool "SAMSUNG S3C2416/S3C2450"
 	select COMMON_CLK
+	select COMMON_CLK_SAMSUNG
 	select CPU_ARM926T
 	select CPU_LLSERIAL_S3C2440
 	select S3C2416_PM if PM
@@ -89,6 +91,7 @@ config CPU_S3C244X
 config CPU_S3C2443
 	bool "SAMSUNG S3C2443"
 	select COMMON_CLK
+	select COMMON_CLK_SAMSUNG
 	select CPU_ARM920T
 	select CPU_LLSERIAL_S3C2440
 	select S3C2443_COMMON_CLK
-- 
1.7.9.5

