Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaDCNr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 09:47:59 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:50310 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbaDCNr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 09:47:58 -0400
Message-ID: <1396532873.15484.5.camel@phoenix>
Subject: [PATCH] pinctrl: lantiq: Fix header file include guard
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: John Crispin <blogic@openwrt.org>, linux-kernel@vger.kernel.org
Date: Thu, 03 Apr 2014 21:47:53 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define __PINCTRL_LANTIQ_H to prevent multiple inclusion.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-lantiq.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-lantiq.h b/drivers/pinctrl/pinctrl-lantiq.h
index 6d07f02..c7cfad5 100644
--- a/drivers/pinctrl/pinctrl-lantiq.h
+++ b/drivers/pinctrl/pinctrl-lantiq.h
@@ -10,6 +10,7 @@
  */
 
 #ifndef __PINCTRL_LANTIQ_H
+#define __PINCTRL_LANTIQ_H
 
 #include <linux/clkdev.h>
 #include <linux/pinctrl/pinctrl.h>
-- 
1.8.1.2



