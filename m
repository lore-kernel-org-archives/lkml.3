Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab3GVVPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:15:32 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44339 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756918Ab3GVVPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:15:31 -0400
Message-ID: <1374527730.2061.66.camel@joe-AO722>
Subject: [TRIVIAL PATCH 2/2] treewide: Remove typedef ctl_table
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 22 Jul 2013 14:15:30 -0700
In-Reply-To: <1374527638.2061.63.camel@joe-AO722>
References: <1374527638.2061.63.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove this now unused typedef.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/sysctl.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 14a8ff2..b7361f8 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -34,8 +34,6 @@ struct ctl_table_root;
 struct ctl_table_header;
 struct ctl_dir;
 
-typedef struct ctl_table ctl_table;
-
 typedef int proc_handler (struct ctl_table *ctl, int write,
 			  void __user *buffer, size_t *lenp, loff_t *ppos);
 


