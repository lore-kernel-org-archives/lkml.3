Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab3DYJq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:46:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52955 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab3DYJq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:46:28 -0400
Date: Thu, 25 Apr 2013 02:45:39 -0700
From: tip-bot for Jean Delvare <tipbot@zytor.com>
Message-ID: <tip-06d219dc22daa26b79ec8e611caa68801607f15d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jdelvare@suse.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jdelvare@suse.de
In-Reply-To: <1366881845.4186.65.camel@chaos.site>
References: <1366881845.4186.65.camel@chaos.site>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/setup: Drop unneeded include <asm/dmi.h>
Git-Commit-ID: 06d219dc22daa26b79ec8e611caa68801607f15d
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

Commit-ID:  06d219dc22daa26b79ec8e611caa68801607f15d
Gitweb:     http://git.kernel.org/tip/06d219dc22daa26b79ec8e611caa68801607f15d
Author:     Jean Delvare <jdelvare@suse.de>
AuthorDate: Thu, 25 Apr 2013 11:24:05 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 25 Apr 2013 11:32:51 +0200

x86/setup: Drop unneeded include <asm/dmi.h>

arch/x86/kernel/setup.c includes <asm/dmi.h> but it doesn't look
like it needs it, <linux/dmi.h> is sufficient.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Link: http://lkml.kernel.org/r/1366881845.4186.65.camel@chaos.site
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/setup.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 90d8cc9..a60b245 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -82,7 +82,6 @@
 #include <asm/timer.h>
 #include <asm/i8259.h>
 #include <asm/sections.h>
-#include <asm/dmi.h>
 #include <asm/io_apic.h>
 #include <asm/ist.h>
 #include <asm/setup_arch.h>
