Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965402Ab3DQQLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 12:11:44 -0400
Received: from sauhun.de ([89.238.76.85]:40898 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964788Ab3DQQLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 12:11:42 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH] MAINTAINERS: Ben Dooks is inactive regarding I2C
Date: Wed, 17 Apr 2013 18:10:56 +0200
Message-Id: <1366215056-27242-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben has done valuable work for the I2C subsystem, yet he has been
inactive for ~15 months. Let MAINTAINERS reflect that. He will be
most welcome if he wants to participate again.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: Ben Dooks <ben-linux@fluff.org>
---

Ben, please speak up if you want to continue co-maintaining I2C. My wish then
would be assistance in reviewing the patches.

Thanks for all the work so far,

   Wolfram


 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4cf5fd3..1b3c1f6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3858,7 +3858,6 @@ F:	drivers/i2c/i2c-stub.c
 
 I2C SUBSYSTEM
 M:	Wolfram Sang <wsa@the-dreams.de>
-M:	"Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
 L:	linux-i2c@vger.kernel.org
 W:	http://i2c.wiki.kernel.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git
-- 
1.7.10.4

