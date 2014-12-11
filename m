Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965238AbaLKU66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 15:58:58 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:37937 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933310AbaLKUwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 15:52:51 -0500
From: Olof Johansson <olof@lixom.net>
To: yann.morin.1998@free.fr
Cc: linux-kbuild@vger.kernel.org, dvhart@linux.intel.com,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [PATCH 2/2] merge_config.sh: add -? for help
Date: Thu, 11 Dec 2014 12:55:04 -0800
Message-Id: <1418331304-4821-2-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1418331304-4821-1-git-send-email-olof@lixom.net>
References: <1418331304-4821-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's usual enough for help text that it makes sense to support it.

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 scripts/kconfig/merge_config.sh |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/scripts/kconfig/merge_config.sh b/scripts/kconfig/merge_config.sh
index 2ab91b9..0c89537 100755
--- a/scripts/kconfig/merge_config.sh
+++ b/scripts/kconfig/merge_config.sh
@@ -28,11 +28,11 @@ trap clean_up HUP INT TERM
 
 usage() {
 	echo "Usage: $0 [OPTIONS] [CONFIG [...]]"
-	echo "  -h    display this help text"
-	echo "  -m    only merge the fragments, do not execute the make command"
-	echo "  -n    use allnoconfig instead of alldefconfig"
-	echo "  -r    list redundant entries when merging fragments"
-	echo "  -O    dir to put generated output files"
+	echo "  -h or -? display this help text"
+	echo "  -m       only merge the fragments, do not execute the make command"
+	echo "  -n       use allnoconfig instead of alldefconfig"
+	echo "  -r       list redundant entries when merging fragments"
+	echo "  -O       dir to put generated output files"
 }
 
 MAKE=true
@@ -52,7 +52,7 @@ while true; do
 		shift
 		continue
 		;;
-	"-h")
+	"-h"|"-?")
 		usage
 		exit
 		;;
-- 
1.7.10.4

