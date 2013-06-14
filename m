Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab3FNCpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:45:40 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45150 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759906Ab3FNCkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:40:43 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        codalist@TELEMANN.coda.cs.cmu.edu, linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 17/33] coda: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:42 -0700
Message-Id: <0faa0687155ea1bf305c95803147c1e684732055.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/coda/sysctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/coda/sysctl.c b/fs/coda/sysctl.c
index af56ad5..34218a8 100644
--- a/fs/coda/sysctl.c
+++ b/fs/coda/sysctl.c
@@ -14,7 +14,7 @@
 #ifdef CONFIG_SYSCTL
 static struct ctl_table_header *fs_table_header;
 
-static ctl_table coda_table[] = {
+static struct ctl_table coda_table[] = {
 	{
 		.procname	= "timeout",
 		.data		= &coda_timeout,
@@ -39,7 +39,7 @@ static ctl_table coda_table[] = {
 	{}
 };
 
-static ctl_table fs_table[] = {
+static struct ctl_table fs_table[] = {
 	{
 		.procname	= "coda",
 		.mode		= 0555,
-- 
1.8.1.2.459.gbcd45b4.dirty

