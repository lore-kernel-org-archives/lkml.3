Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbaFPTt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 15:49:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498AbaFPTtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 15:49:24 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH] Documentation: corrected sub-chapter number
Date: Mon, 16 Jun 2014 15:48:23 -0400
Message-Id: <1537cb738c6d4998106c5b91626b69f742d2b47d.1402946960.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The index is correct, but there are two sections tagged 3.7.  Fix.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 Documentation/filesystems/proc.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index f00bee1..68e3a76 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1648,7 +1648,7 @@ pids, so one need to either stop or freeze processes being inspected
 if precise results are needed.
 
 
-3.7	/proc/<pid>/fdinfo/<fd> - Information about opened file
+3.8	/proc/<pid>/fdinfo/<fd> - Information about opened file
 ---------------------------------------------------------------
 This file provides information associated with an opened file. The regular
 files have at least two fields -- 'pos' and 'flags'. The 'pos' represents
-- 
1.7.1

