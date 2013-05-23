Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab3EWIcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 04:32:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43051 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756862Ab3EWIct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 04:32:49 -0400
X-IronPort-AV: E=Sophos;i="4.87,726,1363104000"; 
   d="scan'208";a="7343536"
Message-ID: <519DD397.6060301@cn.fujitsu.com>
Date: Thu, 23 May 2013 16:30:15 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: vgoyal@redhat.com, hbabu@us.ibm.com, rob@landley.net,
        Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Documentation/kdump: Remove TODO in this document
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/23 16:31:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/23 16:31:28,
	Serialize complete at 2013/05/23 16:31:28
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have already had the relocatable kernel, so just remove
the TODO in the kdump document.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 Documentation/kdump/kdump.txt |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
index 9c7fd98..a8b291d 100644
--- a/Documentation/kdump/kdump.txt
+++ b/Documentation/kdump/kdump.txt
@@ -461,14 +461,6 @@ format. Crash is available on Dave Anderson's site at the following URL:
    http://people.redhat.com/~anderson/
 
 
-To Do
-=====
-
-1) Provide relocatable kernels for all architectures to help in maintaining
-   multiple kernels for crash_dump, and the same kernel as the system kernel
-   can be used to capture the dump.
-
-
 Contact
 =======
 
-- 
1.7.1
