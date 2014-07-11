Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbaGKTYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:24:23 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33928 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbaGKTYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:24:22 -0400
From: Ionut Alexa <ionut.m.alexa@gmail.com>
To: rui.zhang@intel.com
Cc: linux-kernel@vger.kernel.org, Ionut Alexa <johnnyalexa@yahoo.com>
Subject: [PATCH] tools:thermal:tmon :fix coding style issues
Date: Fri, 11 Jul 2014 22:25:47 +0300
Message-Id: <1405106747-7996-1-git-send-email-ionut.m.alexa@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ionut Alexa <johnnyalexa@yahoo.com>

Fixed coding style issues.

Signed-off-by: Ionut Alexa <johnnyalexa@yahoo.com>
---
 tools/thermal/tmon/tmon.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/thermal/tmon/tmon.c b/tools/thermal/tmon/tmon.c
index 09b7c32..bffd3d9 100644
--- a/tools/thermal/tmon/tmon.c
+++ b/tools/thermal/tmon/tmon.c
@@ -55,7 +55,7 @@ static void	start_daemon_mode(void);
 
 pthread_t event_tid;
 pthread_mutex_t input_lock;
-void usage()
+void usage(void)
 {
 	printf("Usage: tmon [OPTION...]\n");
 	printf("  -c, --control         cooling device in control\n");
@@ -70,7 +70,7 @@ void usage()
 	exit(0);
 }
 
-void version()
+void version(void)
 {
 	printf("TMON version %s\n", VERSION);
 	exit(EXIT_SUCCESS);
@@ -340,11 +340,12 @@ int main(int argc, char **argv)
 	return 0;
 }
 
-static void start_daemon_mode()
+static void start_daemon_mode(void)
 {
 	daemon_mode = 1;
 	/* fork */
 	pid_t	sid, pid = fork();
+
 	if (pid < 0) {
 		exit(EXIT_FAILURE);
 	} else if (pid > 0)
-- 
1.7.10.4

