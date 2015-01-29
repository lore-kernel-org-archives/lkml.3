Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947AbbA2LbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:31:09 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:37841 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbbA2LbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:31:07 -0500
From: Andrey Skvortsov <andrej.skvortzov@gmail.com>
To: Michal Marek <mmarek@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Boaz Harrosh <boaz@plexistor.com>, Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Subject: [PATCH] gitignore: ignore tar-install build directory
Date: Thu, 29 Jan 2015 14:30:56 +0300
Message-Id: <1422531056-22517-1-git-send-email-andrej.skvortzov@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have git ignore the Debian directory created when running:
     make tar-pkg / targz-pkg / tarbz2-pkg / tarxz-pkg

Signed-off-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>
---
 .gitignore |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/.gitignore b/.gitignore
index ce57b79..9ac9106 100644
--- a/.gitignore
+++ b/.gitignore
@@ -53,6 +53,11 @@ Module.symvers
 /debian/
 
 #
+# tar directory (make tar*-pkg)
+#
+/tar-install/
+
+#
 # git files that we don't want to ignore even it they are dot-files
 #
 !.gitignore
-- 
1.7.10.4

