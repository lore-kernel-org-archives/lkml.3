Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab3CELsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 06:48:08 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:64529 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab3CELsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 06:48:01 -0500
X-AuditID: 9c93016f-b7b46ae000000e4b-73-5135db7085ca
From: Kyungsik Lee <kyungsik.lee@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        x86@kernel.org, celinux-dev@lists.celinuxforum.org
Cc: Nicolas Pitre <nico@fluxnic.net>, David Sterba <dsterba@suse.cz>,
        Nitin Gupta <nitingupta910@gmail.com>,
        Joe Millenbach <jmillenbach@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Michal Marek <mmarek@suse.cz>,
        hyojun.im@lge.com, chan.jeong@lge.com, raphael.andy.lee@gmail.com,
        Kyungsik Lee <kyungsik.lee@lge.com>
Subject: [PATCH v3 -next 5/5] Kconfig: Make x86 and arm kernels default to the LZ4-compressed
Date: Tue,  5 Mar 2013 20:47:36 +0900
Message-Id: <1362484056-9778-6-git-send-email-kyungsik.lee@lge.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1362484056-9778-1-git-send-email-kyungsik.lee@lge.com>
References: <1362484056-9778-1-git-send-email-kyungsik.lee@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes x86 and arm kernels default to the LZ4-compressed
to test new LZ4 code in the linux-next. This is requested by
Andrew Morton.

Signed-off-by: Kyungsik Lee <kyungsik.lee@lge.com>
---
 init/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index fc8eb1f..de3cb00 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -138,7 +138,7 @@ config HAVE_KERNEL_LZ4
 
 choice
 	prompt "Kernel compression mode"
-	default KERNEL_GZIP
+	default KERNEL_LZ4
 	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA || HAVE_KERNEL_XZ || HAVE_KERNEL_LZO || HAVE_KERNEL_LZ4
 	help
 	  The linux kernel is a kind of self-extracting executable.
-- 
1.8.1.1

