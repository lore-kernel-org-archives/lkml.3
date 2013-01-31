Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab3AaH4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 02:56:06 -0500
Received: from chrocht.moloch.sk ([62.176.169.44]:60209 "EHLO mail.moloch.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755101Ab3AaH4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 02:56:05 -0500
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jan 2013 02:56:04 EST
From: Martin Sustrik <sustrik@250bpm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Sha Zhengju <handai.szj@taobao.com>, linux-kernel@vger.kernel.org
Cc: Martin Sustrik <sustrik@250bpm.com>
Subject: [PATCH 1/1] eventfd: fix incorrect filename is a comment
Date: Thu, 31 Jan 2013 08:49:30 +0100
Message-Id: <1359618570-30380-1-git-send-email-sustrik@250bpm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comment in eventfd.h referred to 'include/asm-generic/fcntl.h'
while the correct path is 'include/uapi/asm-generic/fcntl.h'.

Signed-off-by: Martin Sustrik <sustrik@250bpm.com>
---
 include/linux/eventfd.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index 3c3ef19..cf5d2af 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -13,7 +13,7 @@
 #include <linux/wait.h>
 
 /*
- * CAREFUL: Check include/asm-generic/fcntl.h when defining
+ * CAREFUL: Check include/uapi/asm-generic/fcntl.h when defining
  * new flags, since they might collide with O_* ones. We want
  * to re-use O_* flags that couldn't possibly have a meaning
  * from eventfd, in order to leave a free define-space for
-- 
1.7.4.1

