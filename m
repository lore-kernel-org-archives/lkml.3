Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760296Ab3HOGCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 02:02:42 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:50587 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab3HOGCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 02:02:40 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v4 3/5] ARM: davinci: da850: add OF_DEV_AUXDATA entry for mdio.
Date: Thu, 15 Aug 2013 11:31:35 +0530
Message-Id: <1376546497-26931-4-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376546497-26931-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1376546497-26931-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Add OF_DEV_AUXDATA for mdio driver in da850 board dt
file to use mdio clock.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 Changes for v2: none
 Changes for v3: none
 Changes for v4: none

 arch/arm/mach-davinci/da8xx-dt.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-davinci/da8xx-dt.c b/arch/arm/mach-davinci/da8xx-dt.c
index 9683cbd..d172563 100644
--- a/arch/arm/mach-davinci/da8xx-dt.c
+++ b/arch/arm/mach-davinci/da8xx-dt.c
@@ -43,6 +43,7 @@ static struct of_dev_auxdata da850_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("ns16550a", 0x01c42000, "serial8250.0", NULL),
 	OF_DEV_AUXDATA("ns16550a", 0x01d0c000, "serial8250.1", NULL),
 	OF_DEV_AUXDATA("ns16550a", 0x01d0d000, "serial8250.2", NULL),
+	OF_DEV_AUXDATA("ti,davinci_mdio", 0x01e24000, "davinci_mdio.0", NULL),
 	{}
 };
 
-- 
1.7.9.5

