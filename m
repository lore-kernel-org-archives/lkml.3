Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbbAPIHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 03:07:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59525 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbbAPIHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 03:07:16 -0500
Date: Fri, 16 Jan 2015 00:07:04 -0800
From: tip-bot for Alexander Kuleshov <tipbot@zytor.com>
Message-ID: <tip-60b217a03b1156a22926ec0770c2aa08679ea769@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org, bp@suse.de,
        kuleshovmail@gmail.com, tglx@linutronix.de
Reply-To: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        tglx@linutronix.de, bp@suse.de, kuleshovmail@gmail.com
In-Reply-To: <1420267941-26390-1-git-send-email-kuleshovmail@gmail.com>
References: <1420267941-26390-1-git-send-email-kuleshovmail@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, setup:
  Rename BOOT_ISDIGIT_H to BOOT_CTYPE_H
Git-Commit-ID: 60b217a03b1156a22926ec0770c2aa08679ea769
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60b217a03b1156a22926ec0770c2aa08679ea769
Gitweb:     http://git.kernel.org/tip/60b217a03b1156a22926ec0770c2aa08679ea769
Author:     Alexander Kuleshov <kuleshovmail@gmail.com>
AuthorDate: Sat, 3 Jan 2015 12:52:21 +0600
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Tue, 13 Jan 2015 11:59:04 +0100

x86, setup: Rename BOOT_ISDIGIT_H to BOOT_CTYPE_H

arch/x86/boot/isdigit.h was renamed to arch/x86/boot/ctype.h in
6238b47b5848 ("x86, setup: move isdigit.h to ctype.h, header files on top.")
Adjust guards too.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Link: http://lkml.kernel.org/r/1420267941-26390-1-git-send-email-kuleshovmail@gmail.com
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/boot/ctype.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/ctype.h b/arch/x86/boot/ctype.h
index 25e1340..020f137 100644
--- a/arch/x86/boot/ctype.h
+++ b/arch/x86/boot/ctype.h
@@ -1,6 +1,5 @@
-#ifndef BOOT_ISDIGIT_H
-
-#define BOOT_ISDIGIT_H
+#ifndef BOOT_CTYPE_H
+#define BOOT_CTYPE_H
 
 static inline int isdigit(int ch)
 {
