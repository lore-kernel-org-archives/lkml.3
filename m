Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaIYCat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 22:30:49 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:51549 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaIYCas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 22:30:48 -0400
From: Peter Foley <pefoley2@pefoley.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Foley <pefoley2@pefoley.com>, rdunlap@infradead.org,
        linux-doc@vger.kernel.org, sudeep.dutt@intel.com, nikhil.rao@intel.com,
        ashutosh.dixit@intel.com, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org
Subject: [PATCH] Make Documenation depend on headers_install
Date: Wed, 24 Sep 2014 22:30:33 -0400
Message-Id: <1411612233-23025-1-git-send-email-pefoley2@pefoley.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: rdunlap@infradead.org
Cc: linux-doc@vger.kernel.org
Cc: sudeep.dutt@intel.com
Cc: nikhil.rao@intel.com
Cc: ashutosh.dixit@intel.com
Cc: akpm@linux-foundation.org
Cc: gregkh@linuxfoundation.org
Signed-off-by: Peter Foley <pefoley2@pefoley.com>
---
 Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Makefile b/Makefile
index 16a4d48..b3cf4f9 100644
--- a/Makefile
+++ b/Makefile
@@ -1579,6 +1579,8 @@ endif
 	$(cmd_crmodverdir)
 	$(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1) \
 	$(build)=$(build-dir)
+# Make sure the latest headers are built for Documentation
+Documentation/: headers_install
 %/: prepare scripts FORCE
 	$(cmd_crmodverdir)
 	$(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1) \
-- 
2.1.1

