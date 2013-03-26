Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933338Ab3CZJ7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 05:59:10 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:60063 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755029Ab3CZJ7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 05:59:09 -0400
Message-ID: <1364291944.1390.321.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] sound: Remove stray pluses from Kconfig file
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 26 Mar 2013 10:59:04 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2013 09:59:04.0283 (UTC) FILETIME=[8C5552B0:01CE2A08]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
The kconfig parsing code just ignores these stray pluses. I've stopped
wondering about that parser. It's just really liberal.

 sound/soc/ux500/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/ux500/Kconfig b/sound/soc/ux500/Kconfig
index 069330d..6b799c0 100644
--- a/sound/soc/ux500/Kconfig
+++ b/sound/soc/ux500/Kconfig
@@ -20,8 +20,8 @@ config SND_SOC_UX500_PLAT_DMA
 	help
 		Say Y if you want to enable the Ux500 platform-driver.
 
-+config SND_SOC_UX500_MACH_MOP500
-+	tristate "Machine - MOP500 (Ux500 + AB8500)"
+config SND_SOC_UX500_MACH_MOP500
+	tristate "Machine - MOP500 (Ux500 + AB8500)"
 	depends on AB8500_CORE && AB8500_GPADC && SND_SOC_UX500
 	select SND_SOC_AB8500_CODEC
 	select SND_SOC_UX500_PLAT_MSP_I2S
-- 
1.7.11.7

