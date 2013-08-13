Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702Ab3HMTar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 15:30:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:37415 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758052Ab3HMTaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 15:30:46 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Jiri Kosina <trivial@kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH-trivial] samples/hidraw: add .gitignore file
Date: Tue, 13 Aug 2013 15:30:39 -0400
Message-ID: <1376422239-23134-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To fix:

 # Untracked files:
 #   (use "git add <file>..." to include in what will be committed)
 #
 #	samples/hidraw/hid-example

as seen in git status output after an allyesconfig build.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 samples/hidraw/.gitignore | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 samples/hidraw/.gitignore

diff --git a/samples/hidraw/.gitignore b/samples/hidraw/.gitignore
new file mode 100644
index 0000000..05e51a6
--- /dev/null
+++ b/samples/hidraw/.gitignore
@@ -0,0 +1 @@
+hid-example
-- 
1.8.1.2

