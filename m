Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965103Ab3FSSnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:43:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40309 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964945Ab3FSSne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:43:34 -0400
Date: Wed, 19 Jun 2013 11:43:21 -0700
From: tip-bot for Joe Perches <tipbot@zytor.com>
Message-ID: <tip-f07d91ede6f346cbe31bb814cefe2584940b96f3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        trivial@kernel.org, joe@perches.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joe@perches.com, trivial@kernel.org, tglx@linutronix.de
In-Reply-To: <a756fa0060e8eea25e8c1863c2764e86c2823617.1371177118.git.joe@perches.com>
References: <a756fa0060e8eea25e8c1863c2764e86c2823617.1371177118.git.joe@perches.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86/vdso:
  Convert use of typedef ctl_table to struct ctl_table
Git-Commit-ID: f07d91ede6f346cbe31bb814cefe2584940b96f3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:43:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f07d91ede6f346cbe31bb814cefe2584940b96f3
Gitweb:     http://git.kernel.org/tip/f07d91ede6f346cbe31bb814cefe2584940b96f3
Author:     Joe Perches <joe@perches.com>
AuthorDate: Thu, 13 Jun 2013 19:37:33 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 15:06:09 +0200

x86/vdso: Convert use of typedef ctl_table to struct ctl_table

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>
Link: http://lkml.kernel.org/r/a756fa0060e8eea25e8c1863c2764e86c2823617.1371177118.git.joe@perches.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/vdso/vdso32-setup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 0faad64..d6bfb87 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -372,7 +372,7 @@ subsys_initcall(sysenter_setup);
 /* Register vsyscall32 into the ABI table */
 #include <linux/sysctl.h>
 
-static ctl_table abi_table2[] = {
+static struct ctl_table abi_table2[] = {
 	{
 		.procname	= "vsyscall32",
 		.data		= &sysctl_vsyscall32,
@@ -383,7 +383,7 @@ static ctl_table abi_table2[] = {
 	{}
 };
 
-static ctl_table abi_root_table2[] = {
+static struct ctl_table abi_root_table2[] = {
 	{
 		.procname = "abi",
 		.mode = 0555,
