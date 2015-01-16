Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbbAPIHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 03:07:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59534 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbbAPIHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 03:07:35 -0500
Date: Fri, 16 Jan 2015 00:07:23 -0800
From: tip-bot for Alexander Kuleshov <tipbot@zytor.com>
Message-ID: <tip-e054273a9b117f74ad8214b1f0f23e917e25522e@git.kernel.org>
Cc: bp@suse.de, linux-kernel@vger.kernel.org, kuleshovmail@gmail.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com
Reply-To: tglx@linutronix.de, hpa@zytor.com, bp@suse.de,
        linux-kernel@vger.kernel.org, kuleshovmail@gmail.com, mingo@kernel.org
In-Reply-To: <1420034191-20721-1-git-send-email-kuleshovmail@gmail.com>
References: <1420034191-20721-1-git-send-email-kuleshovmail@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, early_serial_console:
  Remove unused macro XMTRDY
Git-Commit-ID: e054273a9b117f74ad8214b1f0f23e917e25522e
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

Commit-ID:  e054273a9b117f74ad8214b1f0f23e917e25522e
Gitweb:     http://git.kernel.org/tip/e054273a9b117f74ad8214b1f0f23e917e25522e
Author:     Alexander Kuleshov <kuleshovmail@gmail.com>
AuthorDate: Wed, 31 Dec 2014 19:56:31 +0600
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Tue, 13 Jan 2015 12:13:11 +0100

x86, early_serial_console: Remove unused macro XMTRDY

There is no write to serial routine, no need for XMTRDY macro.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Link: http://lkml.kernel.org/r/1420034191-20721-1-git-send-email-kuleshovmail@gmail.com
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/boot/early_serial_console.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/boot/early_serial_console.c b/arch/x86/boot/early_serial_console.c
index 5df2869..790586d 100644
--- a/arch/x86/boot/early_serial_console.c
+++ b/arch/x86/boot/early_serial_console.c
@@ -2,8 +2,6 @@
 
 #define DEFAULT_SERIAL_PORT 0x3f8 /* ttyS0 */
 
-#define XMTRDY          0x20
-
 #define DLAB		0x80
 
 #define TXR             0       /*  Transmit register (WRITE) */
