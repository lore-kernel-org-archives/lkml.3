Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750984AbaK1EGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 23:06:47 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:60949 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaK1EGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 23:06:46 -0500
From: Yao Dongdong <yaodongdong@huawei.com>
To: <paul@paul-moore.com>, <sds@tycho.nsa.gov>, <james.l.morris@oracle.com>,
        <serge@hallyn.com>
CC: <linux-security-module@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>
Subject: [PATCH] selinux: Remove security_ops extern
Date: Fri, 28 Nov 2014 04:25:35 +0000
Message-ID: <1417148735-13522-1-git-send-email-yaodongdong@huawei.com>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.189]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

security_ops is not used in this file.

Signed-off-by: Yao Dongdong <yaodongdong@huawei.com>
---
 security/selinux/hooks.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index c603b20..6da7532 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -95,8 +95,6 @@
 #include "audit.h"
 #include "avc_ss.h"
 
-extern struct security_operations *security_ops;
-
 /* SECMARK reference count */
 static atomic_t selinux_secmark_refcount = ATOMIC_INIT(0);
 
-- 
1.8.3.4

