Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab3FNCi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:38:59 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42686 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759522Ab3FNCi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:38:57 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 05/33] powerpc: idle: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:30 -0700
Message-Id: <5e6452662144ad4c21bf817beeac0c1a32793c5c.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/powerpc/kernel/idle.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index 939ea7e..d7216c9 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -85,7 +85,7 @@ int powersave_nap;
 /*
  * Register the sysctl to set/clear powersave_nap.
  */
-static ctl_table powersave_nap_ctl_table[]={
+static struct ctl_table powersave_nap_ctl_table[] = {
 	{
 		.procname	= "powersave-nap",
 		.data		= &powersave_nap,
@@ -95,7 +95,7 @@ static ctl_table powersave_nap_ctl_table[]={
 	},
 	{}
 };
-static ctl_table powersave_nap_sysctl_root[] = {
+static struct ctl_table powersave_nap_sysctl_root[] = {
 	{
 		.procname	= "kernel",
 		.mode		= 0555,
-- 
1.8.1.2.459.gbcd45b4.dirty

