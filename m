Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbaDEPtq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 11:49:46 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:56453 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbaDEPtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 11:49:43 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Healy <cphealy@gmail.com>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] mfd: lpc_ich: Enable GPIO for Panther Point
Date: Sat,  5 Apr 2014 08:49:34 -0700
Message-Id: <1396712974-13853-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Panther Point PCH GPIO configuration is similar to V5 PCHs.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/mfd/lpc_ich.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index 37edf9e..d096cca 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -484,6 +484,7 @@ static struct lpc_ich_info lpc_chipset_info[] = {
 	[LPC_PPT] = {
 		.name = "Panther Point",
 		.iTCO_version = 2,
+		.gpio_version = ICH_V5_GPIO,
 	},
 	[LPC_LPT] = {
 		.name = "Lynx Point",
-- 
1.7.9.7

