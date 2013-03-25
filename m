Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab3CYIuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 04:50:00 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:39352 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436Ab3CYIt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 04:49:57 -0400
Message-ID: <1364201391.3867.2.camel@phoenix>
Subject: [PATCH] regulator: maintainers: Update email address for Liam
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 25 Mar 2013 16:49:51 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Liam sent a patch[1] to update his email, but it only updates the
maintainer entry for ASoC. This patch updates the entry for regulator subsystem
to ensure get_maintainer.pl returns correct email address for maintainers.

[1] https://lkml.org/lkml/2013/1/15/344

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 36f5973..d42a6e2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8760,7 +8760,7 @@ F:	drivers/scsi/vmw_pvscsi.c
 F:	drivers/scsi/vmw_pvscsi.h
 
 VOLTAGE AND CURRENT REGULATOR FRAMEWORK
-M:	Liam Girdwood <lrg@ti.com>
+M:	Liam Girdwood <lgirdwood@gmail.com>
 M:	Mark Brown <broonie@opensource.wolfsonmicro.com>
 W:	http://opensource.wolfsonmicro.com/node/15
 W:	http://www.slimlogic.co.uk/?p=48
-- 
1.7.10.4



