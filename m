Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbaBTRm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:42:28 -0500
Received: from mail.windriver.com ([147.11.1.11]:60296 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbaBTRm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:42:27 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: David Howells <dhowells@redhat.com>
CC: <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] frv: add .gitignore for generated files
Date: Thu, 20 Feb 2014 12:42:16 -0500
Message-ID: <1392918136-16755-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/arch/frv/.gitignore b/arch/frv/.gitignore
new file mode 100644
index 000000000000..17d6ce1969b9
--- /dev/null
+++ b/arch/frv/.gitignore
@@ -0,0 +1,2 @@
+boot/Image
+kernel/vmlinux.lds
-- 
1.8.5.2

