Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759935Ab3FNCkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:40:55 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50957 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759888Ab3FNCkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:40:52 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: David Howells <dhowells@redhat.com>, linux-cachefs@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 18/33] fscache: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:43 -0700
Message-Id: <d854ec5babf0beda50655938342939fee641d68b.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/fscache/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fscache/main.c b/fs/fscache/main.c
index 7c27907..5b2c174 100644
--- a/fs/fscache/main.c
+++ b/fs/fscache/main.c
@@ -67,7 +67,7 @@ static int fscache_max_active_sysctl(struct ctl_table *table, int write,
 	return ret;
 }
 
-ctl_table fscache_sysctls[] = {
+struct ctl_table fscache_sysctls[] = {
 	{
 		.procname	= "object_max_active",
 		.data		= &fscache_object_max_active,
@@ -87,7 +87,7 @@ ctl_table fscache_sysctls[] = {
 	{}
 };
 
-ctl_table fscache_sysctls_root[] = {
+struct ctl_table fscache_sysctls_root[] = {
 	{
 		.procname	= "fscache",
 		.mode		= 0555,
-- 
1.8.1.2.459.gbcd45b4.dirty

