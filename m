Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934241Ab3FSDQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 23:16:39 -0400
Received: from intranet.asianux.com ([58.214.24.6]:16087 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934021Ab3FSDQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 23:16:38 -0400
X-Spam-Score: -100.8
Message-ID: <51C12262.9040308@asianux.com>
Date: Wed, 19 Jun 2013 11:15:46 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "'Jiri Kosina'" <trivial@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] include/linux/spinlock_api_smp.h: beautify code, correct
 the related comments.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Correct the related comments for '#ifdef ... #endif'.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 include/linux/spinlock_api_smp.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
index 51df117..bdb9993 100644
--- a/include/linux/spinlock_api_smp.h
+++ b/include/linux/spinlock_api_smp.h
@@ -144,7 +144,7 @@ static inline void __raw_spin_lock(raw_spinlock_t *lock)
 	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
 }
 
-#endif /* CONFIG_PREEMPT */
+#endif /* !CONFIG_GENERIC_LOCKBREAK || CONFIG_DEBUG_LOCK_ALLOC */
 
 static inline void __raw_spin_unlock(raw_spinlock_t *lock)
 {
-- 
1.7.7.6
