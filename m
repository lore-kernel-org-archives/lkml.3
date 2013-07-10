Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab3GJLAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:00:50 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:38132 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab3GJLAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:00:48 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH] virtio tools: add .gitignore
Date: Wed, 10 Jul 2013 16:27:00 +0530
Message-Id: <1373453820-22517-3-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.2.736.g869de25
In-Reply-To: <1373453820-22517-1-git-send-email-artagnon@gmail.com>
References: <1373453820-22517-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/virtio/.gitignore | 3 +++
 1 file changed, 3 insertions(+)
 create mode 100644 tools/virtio/.gitignore

diff --git a/tools/virtio/.gitignore b/tools/virtio/.gitignore
new file mode 100644
index 0000000..1cfbb01
--- /dev/null
+++ b/tools/virtio/.gitignore
@@ -0,0 +1,3 @@
+*.d
+virtio_test
+vringh_test
-- 
1.8.3.2.736.g869de25

