Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaHORZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 13:25:00 -0400
Received: from kanga.kvack.org ([205.233.56.17]:34769 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbaHORY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 13:24:59 -0400
Date: Fri, 15 Aug 2014 13:24:58 -0400
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] aio: remove the needless registration of ring file's private_data
Message-ID: <b53f1f82fbde8dcf34ab7d731c2a9ae6f0d8d2e2.1408122224.git.bcrl@kvack.org>
References: <cover.1408122224.git.bcrl@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1408122224.git.bcrl@kvack.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the registration of ring file's private_data, we do not use
it.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
---
 fs/aio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index 9ce9e8e..55e03a8 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -192,7 +192,6 @@ static struct file *aio_private_file(struct kioctx *ctx, loff_t nr_pages)
 	}
 
 	file->f_flags = O_RDWR;
-	file->private_data = ctx;
 	return file;
 }
 
-- 
1.8.2.1


-- 
"Thought is the essence of where you are now."
