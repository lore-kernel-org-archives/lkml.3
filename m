Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbaEaK0N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 06:26:13 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:45947 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbaEaK0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 06:26:11 -0400
Date: Sat, 31 May 2014 06:26:01 -0400
From: Niv Yehezkel <executerx@gmail.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [PATCH] power: fixed typo in comment
Message-ID: <20140531102601.GA11021@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed a trivial comment typo (s/mam/map) in kernel/power/swap.c.

Signed-off-by: Niv Yehezkel <executerx@gmail.com>
---
 kernel/power/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 8c9a481..aaa3261 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -567,7 +567,7 @@ static int lzo_compress_threadfn(void *data)
 
 /**
  * save_image_lzo - Save the suspend image data compressed with LZO.
- * @handle: Swap mam handle to use for saving the image.
+ * @handle: Swap map handle to use for saving the image.
  * @snapshot: Image to read data from.
  * @nr_to_write: Number of pages to save.
  */
-- 
1.7.10.4

