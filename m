Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbaFPLGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 07:06:51 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:63099 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaFPLGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:06:49 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        chris@printf.net, ulf.hansson@linaro.org, jh80.chung@samsung.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH] mmc: core: Fix DT documentation of eMMC high-speed DDR 1.8/1.2V bindings.
Date: Mon, 16 Jun 2014 12:06:36 +0100
Message-Id: <1402916796-1450-1-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the documentation doesn't match the code in mmc_of_parse. This
patch rectifies this.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 Documentation/devicetree/bindings/mmc/mmc.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/mmc/mmc.txt b/Documentation/devicetree/bindings/mmc/mmc.txt
index 9dce540..9c96033 100644
--- a/Documentation/devicetree/bindings/mmc/mmc.txt
+++ b/Documentation/devicetree/bindings/mmc/mmc.txt
@@ -34,8 +34,8 @@ Optional properties:
 - cap-power-off-card: powering off the card is safe
 - cap-sdio-irq: enable SDIO IRQ signalling on this interface
 - full-pwr-cycle: full power cycle of the card is supported
-- mmc-highspeed-ddr-1_8v: eMMC high-speed DDR mode(1.8V I/O) is supported
-- mmc-highspeed-ddr-1_2v: eMMC high-speed DDR mode(1.2V I/O) is supported
+- mmc-ddr-1_8v: eMMC high-speed DDR mode(1.8V I/O) is supported
+- mmc-ddr-1_2v: eMMC high-speed DDR mode(1.2V I/O) is supported
 - mmc-hs200-1_8v: eMMC HS200 mode(1.8V I/O) is supported
 - mmc-hs200-1_2v: eMMC HS200 mode(1.2V I/O) is supported
 
-- 
1.9.1

