Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915Ab3LEQAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 11:00:18 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:42161 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932880Ab3LEQAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 11:00:12 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <arm@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Yanis Moreno <yanis.moreno63@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91: remove redundant dependency
Date: Thu, 5 Dec 2013 17:00:08 +0100
Message-ID: <1386259208-2239-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1384932191-8967-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1384932191-8967-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yanis Moreno <yanis.moreno63@gmail.com>

This removes the "depends on SOC_SAM_V7" statement
in a Kconfig section that's under an "if SOC_SAM_V7"
condition (same parameter).

Signed-off-by: Yanis Moreno <yanis.moreno63@gmail.com>
Reviewed-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Hi Olof,

This is an additional patch for cleanup. I didn't include it in my previous
"cleanup" branch as I had wanted to keep it focused on the move to CCF.

As you said that you are okay with applying patches and that I have only one
related to "cleanup" for the moment, I send it to you.

Thanks, bye,
  Nicolas Ferre

 arch/arm/mach-at91/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index b4f7d6ffa30b..aac7814db4f9 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -82,7 +82,6 @@ comment "Atmel AT91 Processor"
 if SOC_SAM_V7
 config SOC_SAMA5D3
 	bool "SAMA5D3 family"
-	depends on SOC_SAM_V7
 	select SOC_SAMA5
 	select HAVE_FB_ATMEL
 	select HAVE_AT91_DBGU1
-- 
1.8.2.2

