Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224Ab3HSJmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:42:10 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:48401 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3HSJmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:42:06 -0400
X-AuditID: 85900ec0-d3b2cb9000001514-3c-5211e86c6f69
Subject: [RFC PATCH 01/11] [TRIVIAL] trace-cmd: Delete the variable iface in
 trace-listen
To: Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Mon, 19 Aug 2013 18:46:22 +0900
Message-ID: <20130819094622.26597.90637.stgit@yunodevel>
In-Reply-To: <20130819094620.26597.79499.stgit@yunodevel>
References: <20130819094620.26597.79499.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iface in trace-listen is not used any more, so it is deleted.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---
 trace-listen.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/trace-listen.c b/trace-listen.c
index 8503b50..dec1c00 100644
--- a/trace-listen.c
+++ b/trace-listen.c
@@ -653,7 +653,6 @@ void trace_listen(int argc, char **argv)
 {
 	char *logfile = NULL;
 	char *port = NULL;
-	char *iface;
 	int daemon = 0;
 	int c;
 
@@ -672,7 +671,7 @@ void trace_listen(int argc, char **argv)
 			{NULL, 0, NULL, 0}
 		};
 
-		c = getopt_long (argc-1, argv+1, "+hp:o:d:i:l:D",
+		c = getopt_long (argc-1, argv+1, "+hp:o:d:l:D",
 			long_options, &option_index);
 		if (c == -1)
 			break;
@@ -683,9 +682,6 @@ void trace_listen(int argc, char **argv)
 		case 'p':
 			port = optarg;
 			break;
-		case 'i':
-			iface = optarg;
-			break;
 		case 'd':
 			output_dir = optarg;
 			break;

