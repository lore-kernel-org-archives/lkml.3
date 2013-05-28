Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934211Ab3E1NgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:36:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50624 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933937Ab3E1NgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:36:18 -0400
Date: Tue, 28 May 2013 06:36:01 -0700
From: tip-bot for Zhang Yanfei <tipbot@zytor.com>
Message-ID: <tip-592a9b8cc813f1e775a7f817985f0722e50e555d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        zhangyanfei@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, tglx@linutronix.de
In-Reply-To: <5191FAE2.4020403@cn.fujitsu.com>
References: <5191FAE2.4020403@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/mm: Drop unneeded include <asm/*pgtable,
  page*_types.h>
Git-Commit-ID: 592a9b8cc813f1e775a7f817985f0722e50e555d
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

Commit-ID:  592a9b8cc813f1e775a7f817985f0722e50e555d
Gitweb:     http://git.kernel.org/tip/592a9b8cc813f1e775a7f817985f0722e50e555d
Author:     Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
AuthorDate: Tue, 14 May 2013 16:50:42 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 11:47:23 +0200

x86/mm: Drop unneeded include <asm/*pgtable, page*_types.h>

arch/x86/boot/compressed/head_64.S includes <asm/pgtable_types.h> and
 <asm/page_types.h> but it doesn't look like it needs them. So remove them.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Link: http://lkml.kernel.org/r/5191FAE2.4020403@cn.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/boot/compressed/head_64.S | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 16f24e6..06e71c2 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -27,8 +27,6 @@
 #include <linux/init.h>
 #include <linux/linkage.h>
 #include <asm/segment.h>
-#include <asm/pgtable_types.h>
-#include <asm/page_types.h>
 #include <asm/boot.h>
 #include <asm/msr.h>
 #include <asm/processor-flags.h>
