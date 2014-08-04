Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaHDUFC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 16:05:02 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:55351 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaHDUE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 16:04:59 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: m.chehab@samsung.com, dan.carpenter@oracle.com, mkrufky@linuxtv.org,
        dcb314@hotmail.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH] drivers/media/dvb-frontends/stv0900_sw.c: Fix break placement
Date: Mon,  4 Aug 2014 23:04:52 +0300
Message-Id: <1407182692-1234-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=81621
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 drivers/media/dvb-frontends/stv0900_sw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/stv0900_sw.c b/drivers/media/dvb-frontends/stv0900_sw.c
index 4ce1d26..a0a7b16 100644
--- a/drivers/media/dvb-frontends/stv0900_sw.c
+++ b/drivers/media/dvb-frontends/stv0900_sw.c
@@ -1733,9 +1733,10 @@ static void stv0900_set_search_standard(struct stv0900_internal *intp,
 		break;
 	case STV0900_SEARCH_DSS:
 		dprintk("Search Standard = DSS\n");
-	case STV0900_SEARCH_DVBS2:
 		break;
+	case STV0900_SEARCH_DVBS2:
 		dprintk("Search Standard = DVBS2\n");
+		break;
 	case STV0900_AUTO_SEARCH:
 	default:
 		dprintk("Search Standard = AUTO\n");
-- 
1.8.5.5

