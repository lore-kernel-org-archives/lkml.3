Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760388Ab3HOGC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 02:02:58 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:45043 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760356Ab3HOGC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 02:02:56 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v4 5/5] ARM: davinci: da850: add OF_DEV_AUXDATA entry for eth0.
Date: Thu, 15 Aug 2013 11:31:37 +0530
Message-Id: <1376546497-26931-6-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376546497-26931-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1376546497-26931-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Add OF_DEV_AUXDATA for eth0  driver in da850 board dt
file to use emac clock.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 Changes for V2: none
 Changes for V3: none
 Changes for v4: none

 arch/arm/mach-davinci/da8xx-dt.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-davinci/da8xx-dt.c b/arch/arm/mach-davinci/da8xx-dt.c
index d172563..caa9202 100644
--- a/arch/arm/mach-davinci/da8xx-dt.c
+++ b/arch/arm/mach-davinci/da8xx-dt.c
@@ -44,6 +44,9 @@ static struct of_dev_auxdata da850_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("ns16550a", 0x01d0c000, "serial8250.1", NULL),
 	OF_DEV_AUXDATA("ns16550a", 0x01d0d000, "serial8250.2", NULL),
 	OF_DEV_AUXDATA("ti,davinci_mdio", 0x01e24000, "davinci_mdio.0", NULL),
+	OF_DEV_AUXDATA("ti,davinci-dm6467-emac", 0x01e20000, "davinci_emac.1",
+		       NULL),
+
 	{}
 };
 
-- 
1.7.9.5

