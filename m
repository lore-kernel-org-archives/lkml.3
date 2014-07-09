Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194AbaGILTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:19:37 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61610 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbaGILKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:10:19 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-33-53bd2319ce36
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH -next 07/21] x86: Kconfig: enable kernel address sanitizer
Date: Wed, 09 Jul 2014 15:01:04 +0400
Message-id: <1404903678-8257-8-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
References: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJMWRmVeSWpSXmKPExsVy+t/xy7qSynuDDf40Clps+/WIzeLyrjls
	DkwefVtWMXp83iQXwBTFZZOSmpNZllqkb5fAlXF2ZQdjwSSWisdtVxkbGDcxdzFyckgImEis
	W/+XCcIWk7hwbz1bFyMXh5DAUkaJhp87WCGcPiaJhfPfsoJUsQnoSfybtZ0NxBYRUJDY3PsM
	LM4soCOx8Vor2CRhAT+JmRu/sIPYLAKqEvfv9jGC2LwCrhKbFn6E2qYgsWz5TLBeTgE3iZ6e
	BWBxIaCa1Z+3MU5g5F3AyLCKUTS1NLmgOCk910ivODG3uDQvXS85P3cTIyQMvu5gXHrM6hCj
	AAejEg/vi917goVYE8uKK3MPMUpwMCuJ8NqK7g0W4k1JrKxKLcqPLyrNSS0+xMjEwSnVwMgf
	mKSbWhc+/aaRL6vr6b2OGbemPjt/49GH644yk1nur2iOP9vV8bX5ucOu9e+f7Fix+OWGOb4c
	4u4bXq4QvdxnLrFuu2OpcvGM5MzDp2aV+1q677qdmz2NNUpBhMfL31Tj/mrpeYoXC5ftW3bV
	31/qtqLpnzRdDoW/LvxyjBsmRItKxbVHhSmxFGckGmoxFxUnAgATunU64QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now everything in x86 code is ready for kasan. Enable it.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8657c06..f9863b3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -132,6 +132,7 @@ config X86
 	select HAVE_CC_STACKPROTECTOR
 	select GENERIC_CPU_AUTOPROBE
 	select HAVE_ARCH_AUDITSYSCALL
+	select HAVE_ARCH_KASAN
 
 config INSTRUCTION_DECODER
 	def_bool y
-- 
1.8.5.5

