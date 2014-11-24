Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbaKXR21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:28:27 -0500
Received: from mout.web.de ([212.227.17.11]:51484 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbaKXR20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:28:26 -0500
Message-ID: <54736AA9.9020305@users.sourceforge.net>
Date: Mon, 24 Nov 2014 18:28:09 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
CC: kernel-janitors@vger.kernel.org, trivial@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/6] video: fbdev-MMP: Fix a typo for the word "destroyed"
References: <54736422.90409@users.sourceforge.net>
In-Reply-To: <54736422.90409@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:gFuYTNnAUhTOBlisIQ8O7T2uKBWGoW0ud2PpqnIHdJK5mLiC5Dl
 lmKTSBjYI2gfesFOXHeSuIYn6I4WGpoIdAOKzee4oXXw+eOfAs3yGZrTxQcE5t+nG58ZCvW
 +L4Tqfx/ce6vS8JmkgN5vZ4xrRQAQarVH8/c1ncAoeOSjbLbnVMA7n4mOdStkB0Dqw8W61b
 vYRyjSxyUhvlqJ0wS9tzA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 24 Nov 2014 15:55:23 +0100

A word was corrected in the description for a parameter of
the mmp_unregister_path() function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/video/fbdev/mmp/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/mmp/core.c b/drivers/video/fbdev/mmp/core.c
index 43ed576..a0f4960 100644
--- a/drivers/video/fbdev/mmp/core.c
+++ b/drivers/video/fbdev/mmp/core.c
@@ -224,7 +224,7 @@ EXPORT_SYMBOL_GPL(mmp_register_path);
 
 /*
  * mmp_unregister_path - unregister and destroy path
- * @p: path to be destoried.
+ * @p: path to be destroyed.
  *
  * this function registers path and destroys it.
  */
-- 
2.1.3

