Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbaKXRUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:20:21 -0500
Received: from mout.web.de ([212.227.17.12]:63434 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274AbaKXRUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:20:15 -0500
Message-ID: <547368BB.2050401@users.sourceforge.net>
Date: Mon, 24 Nov 2014 18:19:55 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
CC: kernel-janitors@vger.kernel.org, trivial@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/6] video: fbdev-MMP: Fix typos for the word "destroy"
References: <54736422.90409@users.sourceforge.net>
In-Reply-To: <54736422.90409@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:Mk8s0u2xy3th85Zlo/ofd/ClCBSivyDtS/cJSZTRAo4ClJtpPS2
 hzCYtO45Ypp/cmy5B5lNRaE6skIp3q04gu5aYYMGS8X6Lvk7B1T/deZXTBveAumiYvzjQPd
 QU51gYZ9pHkMxfXgplulb6RvG1kAjEAvkWZdGL4G8gGCmOCTO/Q7KjeEW3K2Z4B6LZRVCCk
 wx6cOy+42t9sN1WXXJIrw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 24 Nov 2014 15:50:15 +0100

Two mistyped words were corrected in the description for
the mmp_unregister_path() function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/video/fbdev/mmp/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/mmp/core.c b/drivers/video/fbdev/mmp/core.c
index b563b92..43ed576 100644
--- a/drivers/video/fbdev/mmp/core.c
+++ b/drivers/video/fbdev/mmp/core.c
@@ -223,10 +223,10 @@ struct mmp_path *mmp_register_path(struct mmp_path_info *info)
 EXPORT_SYMBOL_GPL(mmp_register_path);
 
 /*
- * mmp_unregister_path - unregister and destory path
+ * mmp_unregister_path - unregister and destroy path
  * @p: path to be destoried.
  *
- * this function registers path and destorys it.
+ * this function registers path and destroys it.
  */
 void mmp_unregister_path(struct mmp_path *path)
 {
-- 
2.1.3

