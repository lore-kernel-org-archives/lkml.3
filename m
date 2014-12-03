Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbaLCTOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 14:14:06 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:64199 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaLCTOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 14:14:04 -0500
From: Bryan Wu <cooloney@gmail.com>
To: jg1.han@samsung.com, lee.jones@linaro.org, linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: remove my name from Backlight subsystem
Date: Wed,  3 Dec 2014 11:14:00 -0800
Message-Id: <1417634040-11791-1-git-send-email-cooloney@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <cooloney@gmail.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ea4d005..1cb460f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1862,7 +1862,6 @@ F:	drivers/net/wireless/b43legacy/
 
 BACKLIGHT CLASS/SUBSYSTEM
 M:	Jingoo Han <jg1.han@samsung.com>
-M:	Bryan Wu <cooloney@gmail.com>
 M:	Lee Jones <lee.jones@linaro.org>
 S:	Maintained
 F:	drivers/video/backlight/
-- 
1.9.1

