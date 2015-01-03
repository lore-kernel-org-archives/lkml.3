Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750851AbbACGwh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 01:52:37 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:65406 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbbACGwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 01:52:36 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH] x86, setup: Rename BOOT_ISDIGIT_H -> BOOT_CTYPE_H
Date: Sat,  3 Jan 2015 12:52:21 +0600
Message-Id: <1420267941-26390-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.2.1.202.g44ae4ee.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/boot/isdigit.h was renamed to arch/x86/boot/ctype.h at
6238b47b58480cd9c092600c05338dbe261b71ce.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 arch/x86/boot/ctype.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/ctype.h b/arch/x86/boot/ctype.h
index 25e1340..d249ccc 100644
--- a/arch/x86/boot/ctype.h
+++ b/arch/x86/boot/ctype.h
@@ -1,6 +1,6 @@
-#ifndef BOOT_ISDIGIT_H
+#ifndef BOOT_CTYPE_H
 
-#define BOOT_ISDIGIT_H
+#define BOOT_CTYPE_H
 
 static inline int isdigit(int ch)
 {
-- 
2.2.1.202.g44ae4ee.dirty

