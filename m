Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbaKQOxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 09:53:44 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:54493 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaKQOxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 09:53:43 -0500
Message-ID: <546A0BEC.7070601@linaro.org>
Date: Mon, 17 Nov 2014 14:53:32 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: Fwd: [PATCH v13 1/9] arm: cnx3xxx: Remove spurious default for DEBUG_CNS3xxx
References: <1416235750-4766-2-git-send-email-daniel.thompson@linaro.org>
In-Reply-To: <1416235750-4766-2-git-send-email-daniel.thompson@linaro.org>
X-Forwarded-Message-Id: <1416235750-4766-2-git-send-email-daniel.thompson@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending to get proper archiving of the mailing list. The original
message didn't make it past the the spam filters (due to multiple
capital X characters).


-------- Forwarded Message --------
Subject: [PATCH v13 1/9] arm: cnx3xxxx: Remove spurious default for
DEBUG_CNS3XXX
Date: Mon, 17 Nov 2014 14:49:02 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
CC: Daniel Thompson <daniel.thompson@linaro.org>,
linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
spear-devel@list.st.com, Paul Bolle <pebolle@tiscali.nl>, Srinivas
Kandagatla <srinivas.kandagatla@linaro.org>, John Stultz
<john.stultz@linaro.org>, Sumit Semwal <sumit.semwal@linaro.org>,
patches@linaro.org, linaro-kernel@lists.linaro.org

The default value for DEBUG_CNS3XXX appears twice. This patch removes
the one with the wrong sort order.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 arch/arm/Kconfig.debug | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index d8f6a2ec3d4e..c1a5fa3ec0a7 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -1134,7 +1134,6 @@ config DEBUG_UART_PHYS
 				DEBUG_S3C2410_UART2)
 	default 0x78000000 if DEBUG_CNS3XXX
 	default 0x7c0003f8 if FOOTBRIDGE
-	default 0x78000000 if DEBUG_CNS3XXX
 	default 0x80070000 if DEBUG_IMX23_UART
 	default 0x80074000 if DEBUG_IMX28_UART
 	default 0x80230000 if DEBUG_PICOXCELL_UART
-- 
1.9.3



