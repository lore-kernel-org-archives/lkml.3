Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaJFFK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 01:10:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbaJFFJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 01:09:24 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        aviro@redhat.com, pmoore@redhat.com, arozansk@redhat.com,
        ebiederm@xmission.com, serge@hallyn.com
Subject: [PATCH V5 08/13] sched: add a macro to ref all CLONE_NEW* flags
Date: Mon,  6 Oct 2014 01:08:33 -0400
Message-Id: <958367f30fb7eddaa406487e63ec1889138ef54f.1412543112.git.rgb@redhat.com>
In-Reply-To: <cover.1412543112.git.rgb@redhat.com>
References: <cover.1412543112.git.rgb@redhat.com>
In-Reply-To: <cover.1412543112.git.rgb@redhat.com>
References: <cover.1412543112.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 include/uapi/linux/sched.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index 34f9d73..5aceba2 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -28,6 +28,12 @@
 #define CLONE_NEWUSER		0x10000000	/* New user namespace */
 #define CLONE_NEWPID		0x20000000	/* New pid namespace */
 #define CLONE_NEWNET		0x40000000	/* New network namespace */
+#define CLONE_NEW_MASK	( CLONE_NEWNS \
+			| CLONE_NEWUTS \
+			| CLONE_NEWIPC \
+			| CLONE_NEWUSER \
+			| CLONE_NEWPID \
+			| CLONE_NEWNET)	/* mask of all namespace type flags */
 #define CLONE_IO		0x80000000	/* Clone io context */
 
 /*
-- 
1.7.1

