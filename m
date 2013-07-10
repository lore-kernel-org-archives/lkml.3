Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab3GJLvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:51:37 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56493 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab3GJLvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:51:35 -0400
X-AuditID: cbfec7f5-b7f376d000001ec6-70-51dd4ac4df2e
From: Phil Carmody <phil.carmody@partner.samsung.com>
To: casey@schaufler-ca.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        jarkko.sakkinen@iki.fi,
        Phil Carmody <phil.carmody@partner.samsung.com>
Subject: [PATCH] smack: fix magic value
Date: Wed, 10 Jul 2013 14:51:13 +0300
Message-id: <1373457073-2571-1-git-send-email-phil.carmody@partner.samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJMWRmVeSWpSXmKPExsVy+t/xy7pHvO4GGnx4I2dxb9svNovnDT3M
	Fpd3zWGz+NDziM1i96ulrA6sHoe/LmTxOPhuD5PH0f2L2Dw+b5ILYInisklJzcksSy3St0vg
	yrhwajZbwWfWih0TPrM0ML5n6WLk5JAQMJGYtn8lG4QtJnHh3nogm4tDSGApo8Tajh5mCKeT
	SeLu3vdMIFVsAqYSU1Z8A7I5OEQEpCTWfRMHqWEWmMQocf/BPVaQGmEBdYmd146AbWARUJVY
	c3YTM4jNK+AvceNaHztIr4SAgsScSTYTGLkXMDKsYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/d
	xAgJg687GJceszrEKMDBqMTDe1DhTqAQa2JZcWXuIUYJDmYlEV51q7uBQrwpiZVVqUX58UWl
	OanFhxiZODilGhgTl6Tt3XtOqk83zuz15ZKsZUFfDfXFznPI8VytORniO3nf6TBx3RPz9fat
	FThnn1fU15b6pGbf2jufPboeTnOpzljPxJVxJL04JFij0TB7xr67j3kzLb982C612ymA/9Xv
	pt4H81efMtkU0+jP2+btp+goEv1xruN3c6egnbVxUmyGX6XmtimxFGckGmoxFxUnAgDqtXGt
	4QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

5d is ']', 'M' is 4d.

Signed-off-by: Phil Carmody <phil.carmody@partner.samsung.com>
---
 include/uapi/linux/magic.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index 2944278..5c1d878 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -11,7 +11,7 @@
 #define DEBUGFS_MAGIC          0x64626720
 #define SECURITYFS_MAGIC	0x73636673
 #define SELINUX_MAGIC		0xf97cff8c
-#define SMACK_MAGIC		0x43415d53	/* "SMAC" */
+#define SMACK_MAGIC		0x43414d53	/* "SMAC" */
 #define RAMFS_MAGIC		0x858458f6	/* some random number */
 #define TMPFS_MAGIC		0x01021994
 #define HUGETLBFS_MAGIC 	0x958458f6	/* some random number */
-- 
1.7.9.5

