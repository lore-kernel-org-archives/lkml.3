Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab3FNCjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:39:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39685 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750970Ab3FNCjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:39:16 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 07/33] tile: proc: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:32 -0700
Message-Id: <f7477f0208b45c64fec077211db4cee2afdbba24.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/tile/kernel/proc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/tile/kernel/proc.c b/arch/tile/kernel/proc.c
index dafc447..6570813 100644
--- a/arch/tile/kernel/proc.c
+++ b/arch/tile/kernel/proc.c
@@ -114,7 +114,7 @@ arch_initcall(proc_tile_init);
  */
 
 #ifndef __tilegx__  /* FIXME: GX: no support for unaligned access yet */
-static ctl_table unaligned_subtable[] = {
+static struct ctl_table unaligned_subtable[] = {
 	{
 		.procname	= "enabled",
 		.data		= &unaligned_fixup,
@@ -139,7 +139,7 @@ static ctl_table unaligned_subtable[] = {
 	{}
 };
 
-static ctl_table unaligned_table[] = {
+static struct ctl_table unaligned_table[] = {
 	{
 		.procname	= "unaligned_fixup",
 		.mode		= 0555,
-- 
1.8.1.2.459.gbcd45b4.dirty

