Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaI0QNG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 12:13:06 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:3452 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753015AbaI0QNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 12:13:04 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqISANjgJlRXQy06/2dsb2JhbABfgw62CwUBcppRBAJ9FwF7hGAjgRo3iEIBryePe4YSigwdhDUFkT2La4xAiR2DZTsvgkoBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Petr Vandrovec <petr@vandrovec.name>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1 linux-next] fs/ncpfs/dir.c: remove redundant sys_tz declaration
Date: Sat, 27 Sep 2014 18:12:59 +0200
Message-Id: <1411834379-17458-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_tz is already declared in include/linux/time.h

Cc: Petr Vandrovec <petr@vandrovec.name>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ncpfs/dir.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index 08b8ea8..1beb761 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -1182,9 +1182,6 @@ static int day_n[] =
 {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 0, 0, 0, 0};
 /* Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec */
 
-
-extern struct timezone sys_tz;
-
 static int utc2local(int time)
 {
 	return time - sys_tz.tz_minuteswest * 60;
-- 
1.9.3

