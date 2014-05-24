Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303AbaEXKcz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 06:32:55 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:63382 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751AbaEXKcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 06:32:54 -0400
Message-ID: <1400927573.31526.92.camel@x220>
Subject: [PATCH] [TRIVIAL] Remove obsolete preprocessor define
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Sat, 24 May 2014 12:32:53 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 May 2014 10:32:53.0730 (UTC) FILETIME=[85205C20:01CF773B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
This is just a remnant of the previous aic7xxx driver. And for that
driver it hadn't even been possible to configure AIC7XXX_PROC_STATS
since v2.4.3.

Compile tested.

 drivers/scsi/aic7xxx/aic7xxx_osm.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index c0c62583b542..114ff0c6e311 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -145,16 +145,6 @@ static struct scsi_transport_template *ahc_linux_transport_template = NULL;
 #endif
 
 /*
- * Control collection of SCSI transfer statistics for the /proc filesystem.
- *
- * NOTE: Do NOT enable this when running on kernels version 1.2.x and below.
- * NOTE: This does affect performance since it has to maintain statistics.
- */
-#ifdef CONFIG_AIC7XXX_PROC_STATS
-#define AIC7XXX_PROC_STATS
-#endif
-
-/*
  * To change the default number of tagged transactions allowed per-device,
  * add a line to the lilo.conf file like:
  * append="aic7xxx=verbose,tag_info:{{32,32,32,32},{32,32,32,32}}"
-- 
1.9.0



