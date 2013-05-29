Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab3E2QTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 12:19:16 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:41591 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab3E2QS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 12:18:58 -0400
From: John Kacur <jkacur@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: lkml <linux-kernel@vger.kernel.org>, John Kacur <jkacur@redhat.com>
Subject: [PATCH trace-cmd 2/2] git-housekeeping: Add the .gitattributes file
Date: Wed, 29 May 2013 18:18:48 +0200
Message-Id: <1369844328-30582-2-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1369844328-30582-1-git-send-email-jkacur@redhat.com>
References: <1369844328-30582-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By adding the .gitattributes file, git-archive can be informed not to
includes files such as .gitignore and ironically .gitattributes

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 .gitattributes | 2 ++
 1 file changed, 2 insertions(+)
 create mode 100644 .gitattributes

diff --git a/.gitattributes b/.gitattributes
new file mode 100644
index 0000000..5966153
--- /dev/null
+++ b/.gitattributes
@@ -0,0 +1,2 @@
+.gitattributes export-ignore
+.gitignore export-ignore
-- 
1.7.11.7

