Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbaGILLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:11:32 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25379 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbaGILK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:10:28 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-44-53bd231d8f4a
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH -next 19/21] arm: Kconfig: enable kernel address sanitizer
Date: Wed, 09 Jul 2014 15:01:16 +0400
Message-id: <1404903678-8257-20-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
References: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJMWRmVeSWpSXmKPExsVy+t/xy7qyynuDDa4eU7DY9usRm8XlXXPY
	HJg8+rasYvT4vEkugCmKyyYlNSezLLVI3y6BK+PGxXfMBX9YKp5NXcTWwNjP0sXIySEhYCJx
	5+tqNghbTOLCvfVANheHkMBSRomNCxtYIZw+JomNG3ezglSxCehJ/Ju1HaxDREBBYnPvM7A4
	s4COxMZrrUwgtrCAn8TT7rfsIDaLgKrEyb5GsHpeATeJZy9mMUNsU5BYtnwmWC8nULynZwFY
	r5CAq8Tqz9sYJzDyLmBkWMUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kREgZfdzAuPWZ1iFGA
	g1GJh/fF7j3BQqyJZcWVuYcYJTiYlUR4bUX3BgvxpiRWVqUW5ccXleakFh9iZOLglGpgPGE0
	71+ruX5Lb5I+r9YlcYbSC3PmSbxiV+aqCAoJ3Ki56Eavwf8nR/f5ySndOfbDPHLNy4OnznU6
	bTjfU5It+7+we/k7CS7NRclF2dbFVYEbJgi23pJx/a13Ztrnh+rXNWa4v1z1g8tgX4D3gphP
	r8tevngl9znhU8O54Jknj8T9e7ROxHKVhRJLcUaioRZzUXEiAJ7YTU3hAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now everything in x86 code is ready for kasan. Enable it.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 arch/arm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c52d1ca..c62db6c 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -26,6 +26,7 @@ config ARM
 	select HARDIRQS_SW_RESEND
 	select HAVE_ARCH_AUDITSYSCALL if (AEABI && !OABI_COMPAT)
 	select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL
+	select HAVE_ARCH_KASAN
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_SECCOMP_FILTER if (AEABI && !OABI_COMPAT)
 	select HAVE_ARCH_TRACEHOOK
-- 
1.8.5.5

