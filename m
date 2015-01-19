Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbbASK23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 05:28:29 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:56889 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbbASK21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 05:28:27 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: MAINTAINERS: add git tree reference
Date: Mon, 19 Jan 2015 11:28:19 +0100
Message-Id: <1421663299-7391-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reference my pinctrl GIT tree @kernel.org

Reported-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3589d67437f8..cdc238c3d8cc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7400,6 +7400,7 @@ F:	drivers/crypto/picoxcell*
 PIN CONTROL SUBSYSTEM
 M:	Linus Walleij <linus.walleij@linaro.org>
 L:	linux-gpio@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
 S:	Maintained
 F:	drivers/pinctrl/
 F:	include/linux/pinctrl/
-- 
1.9.3

