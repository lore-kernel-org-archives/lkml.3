Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaE0N6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:58:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57405 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaE0N6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:58:12 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Olof Johansson <olof@lixom.net>, Andrew Morton <akpm@linux-foundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] MAINTAINERS: Add reset controller framework entry
Date: Tue, 27 May 2014 15:58:09 +0200
Message-Id: <1401199089-28244-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.0.0.rc2
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e67ea24..51b2cb2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7392,6 +7392,14 @@ F:	drivers/rpmsg/
 F:	Documentation/rpmsg.txt
 F:	include/linux/rpmsg.h
 
+RESET CONTROLLER FRAMEWORK
+M:	Philipp Zabel <p.zabel@pengutronix.de>
+S:	Maintained
+F:	drivers/reset/
+F:	Documentation/devicetree/bindings/reset/
+F:	include/linux/reset.h
+F:	include/linux/reset-controller.h
+
 RFKILL
 M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linux-wireless@vger.kernel.org
-- 
2.0.0.rc2

