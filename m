Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759841Ab3FNCkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:40:13 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41762 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759823Ab3FNCkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:40:09 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 13/33] md: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:38 -0700
Message-Id: <f688e5c8901e3fadf381ba5ba5cde664bd95ab93.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/md/md.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9b82377..f7edaf9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -112,7 +112,7 @@ static inline int speed_max(struct mddev *mddev)
 
 static struct ctl_table_header *raid_table_header;
 
-static ctl_table raid_table[] = {
+static struct ctl_table raid_table[] = {
 	{
 		.procname	= "speed_limit_min",
 		.data		= &sysctl_speed_limit_min,
@@ -130,7 +130,7 @@ static ctl_table raid_table[] = {
 	{ }
 };
 
-static ctl_table raid_dir_table[] = {
+static struct ctl_table raid_dir_table[] = {
 	{
 		.procname	= "raid",
 		.maxlen		= 0,
@@ -140,7 +140,7 @@ static ctl_table raid_dir_table[] = {
 	{ }
 };
 
-static ctl_table raid_root_table[] = {
+static struct ctl_table raid_root_table[] = {
 	{
 		.procname	= "dev",
 		.maxlen		= 0,
-- 
1.8.1.2.459.gbcd45b4.dirty

