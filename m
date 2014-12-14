Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaLNHzL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 02:55:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35646 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaLNHzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 02:55:07 -0500
Date: Sat, 13 Dec 2014 23:54:44 -0800
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-f0905c5a32ce6e9b743b4d9c70e53d1ce447852d@git.kernel.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        luto@amacapital.net, tglx@linutronix.de
Reply-To: tglx@linutronix.de, linux-kernel@vger.kernel.org, mingo@kernel.org,
        luto@amacapital.net, hpa@zytor.com
In-Reply-To: <1042001e502f8e0deb0edfeeac209b68378650cf.1418430292.git.luto@amacapital.net>
References: <1042001e502f8e0deb0edfeeac209b68378650cf.1418430292.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] MAINTAINERS: Add me as x86 VDSO submaintainer
Git-Commit-ID: f0905c5a32ce6e9b743b4d9c70e53d1ce447852d
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

Commit-ID:  f0905c5a32ce6e9b743b4d9c70e53d1ce447852d
Gitweb:     http://git.kernel.org/tip/f0905c5a32ce6e9b743b4d9c70e53d1ce447852d
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Fri, 12 Dec 2014 16:25:47 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 14 Dec 2014 08:47:22 +0100

MAINTAINERS: Add me as x86 VDSO submaintainer

Here goes... :)

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1042001e502f8e0deb0edfeeac209b68378650cf.1418430292.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c444907..7a54fa8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10295,6 +10295,13 @@ L:	linux-edac@vger.kernel.org
 S:	Maintained
 F:	arch/x86/kernel/cpu/mcheck/*
 
+X86 VDSO
+M:	Andy Lutomirski <luto@amacapital.net>
+L:	linux-kernel@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/vdso
+S:	Maintained
+F:	arch/x86/vdso/
+
 XC2028/3028 TUNER DRIVER
 M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 L:	linux-media@vger.kernel.org
