Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964807Ab3CTJXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:23:55 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:47347 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab3CTJXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:23:52 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: ben@decadent.org.uk, noelamac@gmail.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, andi@firstfloor.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 12/30] compat: embrace LINUX_BACKPORT() for v2.6.34
Date: Wed, 20 Mar 2013 02:22:37 -0700
Message-Id: <1363771375-31715-13-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363771375-31715-1-git-send-email-mcgrof@do-not-panic.com>
References: <1363771375-31715-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

1   2.6.24              [  OK  ]
2   2.6.25              [  OK  ]
3   2.6.26              [  OK  ]
4   2.6.27              [  OK  ]
5   2.6.28              [  OK  ]
6   2.6.29              [  OK  ]
7   2.6.30              [  OK  ]
8   2.6.31              [  OK  ]
9   2.6.32              [  OK  ]
10  2.6.33              [  OK  ]
11  2.6.34              [  OK  ]
12  2.6.35              [  OK  ]
13  2.6.36              [  OK  ]
14  2.6.37              [  OK  ]
15  2.6.38              [  OK  ]
16  2.6.39              [  OK  ]
17  3.0.65              [  OK  ]
18  3.1.10              [  OK  ]
19  3.2.38              [  OK  ]
20  3.3.8               [  OK  ]
21  3.4.32              [  OK  ]
22  3.5.7               [  OK  ]
23  3.6.11              [  OK  ]
24  3.7.9               [  OK  ]
25  3.8.0               [  OK  ]
26  3.9-rc1             [  OK  ]

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 include/linux/compat-2.6.34.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
index eb22865..c206633 100644
--- a/include/linux/compat-2.6.34.h
+++ b/include/linux/compat-2.6.34.h
@@ -326,9 +326,11 @@ static inline int lockdep_rtnl_is_held(void)
 }
 #endif /* #ifdef CONFIG_PROVE_LOCKING */
 
+#define seq_hlist_start_head LINUX_BACKPORT(seq_hlist_start_head)
 extern struct hlist_node *seq_hlist_start_head(struct hlist_head *head,
 					       loff_t pos);
 
+#define seq_hlist_next LINUX_BACKPORT(seq_hlist_next)
 extern struct hlist_node *seq_hlist_next(void *v, struct hlist_head *head,
 					 loff_t *ppos);
 
-- 
1.7.10.4

