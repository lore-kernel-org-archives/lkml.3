Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbaI0QPB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 12:15:01 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:43881 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753015AbaI0QPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 12:15:00 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqISAIfhJlRXQy06/2dsb2JhbABfgw62CwUBcppRBAJ9FwF7hGAjgRo3iEIBrymPe4YSigwdhDUFnSiMQIkdg2U7L4JKAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jan Kara <jack@suse.cz>
Subject: [PATCH 1/1 linux-next] udf: remove redundant sys_tz declaration
Date: Sat, 27 Sep 2014 18:14:47 +0200
Message-Id: <1411834487-17547-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_tz is already declared in include/linux/time.h

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/udf/udftime.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/udf/udftime.c b/fs/udf/udftime.c
index 1f11483..77c331f 100644
--- a/fs/udf/udftime.c
+++ b/fs/udf/udftime.c
@@ -81,8 +81,6 @@ static time_t year_seconds[MAX_YEAR_SECONDS] = {
 /*2038*/ SPY(68, 17, 0)
 };
 
-extern struct timezone sys_tz;
-
 #define SECS_PER_HOUR	(60 * 60)
 #define SECS_PER_DAY	(SECS_PER_HOUR * 24)
 
-- 
1.9.3

