Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbaLHJ4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:56:35 -0500
Received: from sauhun.de ([89.238.76.85]:39724 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927AbaLHJ4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:56:34 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH] MAINTAINERS: add I2C dt bindings also to I2C realm
Date: Mon,  8 Dec 2014 10:56:26 +0100
Message-Id: <1418032586-3778-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So get_maintainer.pl will add us when something gets updated there.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ea4d0058fd1b..794a8f0a31f6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4561,6 +4561,7 @@ W:	https://i2c.wiki.kernel.org/
 Q:	https://patchwork.ozlabs.org/project/linux-i2c/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git
 S:	Maintained
+F:	Documentation/devicetree/bindings/i2c/
 F:	Documentation/i2c/
 F:	drivers/i2c/
 F:	include/linux/i2c.h
-- 
2.1.3

