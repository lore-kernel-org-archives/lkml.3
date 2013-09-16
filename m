Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab3IPNqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 09:46:52 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:45883 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980Ab3IPNo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 09:44:28 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 17/24] Staging: winbond: wb35reg_s: deleted space before tabulation
Date: Mon, 16 Sep 2013 15:43:37 +0200
Message-Id: <1379339024-12157-18-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379339024-12157-1-git-send-email-ikerpedrosam@gmail.com>
References: <1379339024-12157-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deleted an space before a tabulation.

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/wb35reg_s.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/winbond/wb35reg_s.h b/drivers/staging/winbond/wb35reg_s.h
index dc79faa..cdbbf35 100644
--- a/drivers/staging/winbond/wb35reg_s.h
+++ b/drivers/staging/winbond/wb35reg_s.h
@@ -12,7 +12,7 @@ struct hw_data;
  *			HAL setting function
  *
  *		========================================
- *		|Uxx| 	|Dxx|	|Mxx|	|BB|	|RF|
+ *		|Uxx|	|Dxx|	|Mxx|	|BB|	|RF|
  *		========================================
  *			|					|
  *		Wb35Reg_Read		Wb35Reg_Write
-- 
1.8.1.2

