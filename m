Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761090AbaGYPnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:43:42 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57538 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760690AbaGYPnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:43:39 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCH] Staging: vt6655: removed redundant comments from country.h
Date: Fri, 25 Jul 2014 18:43:22 +0300
Message-Id: <1406303002-31132-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant comments from country.h header file

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
 drivers/staging/vt6655/country.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/vt6655/country.h b/drivers/staging/vt6655/country.h
index 415e767..2365fb1 100644
--- a/drivers/staging/vt6655/country.h
+++ b/drivers/staging/vt6655/country.h
@@ -32,7 +32,6 @@
 
 #include "ttype.h"
 
-/*---------------------  Export Definitions -------------------------*/
 /************************************************************************
  * The definition here should be complied with the INF country order
  * Please check with VNWL.inf/VNWL64.inf/VNWL*.inf
-- 
1.7.9.5

