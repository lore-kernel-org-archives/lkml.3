Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaL1Oyq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 09:54:46 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36943 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbaL1Oyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 09:54:45 -0500
From: Matej Muzila <mmuzila@gmail.com>
X-Google-Original-From: Matej Muzila <mmuzila@redhat.com>
To: kys@microsoft.com, haiyangz@microsoft.com, devel@linuxdriverproject.org
Cc: linux-kernel@vger.kernel.org, Matej Muzila <mmuzila@redhat.com>
Subject: [PATCH] tools: hv: Makefile: Add hv_fcopy_daemon to Makefile
Date: Sun, 28 Dec 2014 15:54:13 +0100
Message-Id: <1419778453-5152-1-git-send-email-mmuzila@redhat.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hv_fcopy_daemon is not mentioned in Makefile so it must be built
manually. Add hv_fcopy_daemon to Makefile.

Signed-off-by: Matej Muzila <mmuzila@redhat.com>
---
 tools/hv/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/hv/Makefile b/tools/hv/Makefile
index bd22f78..99ffe61 100644
--- a/tools/hv/Makefile
+++ b/tools/hv/Makefile
@@ -5,9 +5,9 @@ PTHREAD_LIBS = -lpthread
 WARNINGS = -Wall -Wextra
 CFLAGS = $(WARNINGS) -g $(PTHREAD_LIBS)
 
-all: hv_kvp_daemon hv_vss_daemon
+all: hv_kvp_daemon hv_vss_daemon hv_fcopy_daemon
 %: %.c
 	$(CC) $(CFLAGS) -o $@ $^
 
 clean:
-	$(RM) hv_kvp_daemon hv_vss_daemon
+	$(RM) hv_kvp_daemon hv_vss_daemon hv_fcopy_daemon
-- 
1.9.3

