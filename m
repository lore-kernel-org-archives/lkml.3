Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409AbaGJQ6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 12:58:21 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:59274 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaGJQ6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 12:58:20 -0400
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH] MAINTAINERS: Add thunderbolt driver
Date: Thu, 10 Jul 2014 18:58:04 +0200
Message-Id: <1405011484-2573-1-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 MAINTAINERS | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 134483f..3e34995 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7791,6 +7791,11 @@ S:	Maintained
 F:	include/linux/mmc/dw_mmc.h
 F:	drivers/mmc/host/dw_mmc*
 
+THUNDERBOLT DRIVER
+M:	Andreas Noever <andreas.noever@gmail.com>
+S:	Maintained
+F:	drivers/thunderbolt/
+
 TIMEKEEPING, CLOCKSOURCE CORE, NTP
 M:	John Stultz <john.stultz@linaro.org>
 M:	Thomas Gleixner <tglx@linutronix.de>
-- 
2.0.0

