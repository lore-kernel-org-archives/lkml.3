Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab3LALlN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 06:41:13 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:63459 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab3LALlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 06:41:12 -0500
Message-ID: <1385898066.5613.0.camel@phoenix>
Subject: [PATCH] pinctrl: abx500: Fix header file include guard
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Patrice Chotard <patrice.chotard@st.com>, linux-kernel@vger.kernel.org
Date: Sun, 01 Dec 2013 19:41:06 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a trivial typo.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-abx500.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-abx500.h b/drivers/pinctrl/pinctrl-abx500.h
index eeca8f9..8229380 100644
--- a/drivers/pinctrl/pinctrl-abx500.h
+++ b/drivers/pinctrl/pinctrl-abx500.h
@@ -1,4 +1,4 @@
-#ifndef PINCTRL_PINCTRL_ABx5O0_H
+#ifndef PINCTRL_PINCTRL_ABx500_H
 #define PINCTRL_PINCTRL_ABx500_H
 
 /* Package definitions */
-- 
1.8.1.2



