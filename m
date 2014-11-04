Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbaKDK0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:26:46 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50284 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaKDK0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:26:44 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] MAINTAINERS: add maintainer for CODA video4linux mem2mem driver
Date: Tue,  4 Nov 2014 11:26:35 +0100
Message-Id: <1415096795-15440-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.1.1
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add myself as maintainer for the CODA V4L2 mem2mem driver.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3c64271..34d3671 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2487,6 +2487,13 @@ F:	fs/coda/
 F:	include/linux/coda*.h
 F:	include/uapi/linux/coda*.h
 
+CODA V4L2 MEM2MEM DRIVER
+M:	Philipp Zabel <p.zabel@pengutronix.de>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/media/coda.txt
+F:	drivers/media/platform/coda/
+
 COMMON CLK FRAMEWORK
 M:	Mike Turquette <mturquette@linaro.org>
 L:	linux-kernel@vger.kernel.org
-- 
2.1.1

