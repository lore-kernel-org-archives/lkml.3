Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab3HFVpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:45:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43591 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933Ab3HFVpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:45:11 -0400
Date: Tue, 6 Aug 2013 14:45:01 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-28596b6a8779b736829ad837f95fdc2e81bdd1ee@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1375740170-7446-17-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-17-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] x86, asmlinkage, vdso:
  Mark vdso variables __visible
Git-Commit-ID: 28596b6a8779b736829ad837f95fdc2e81bdd1ee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 06 Aug 2013 14:45:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  28596b6a8779b736829ad837f95fdc2e81bdd1ee
Gitweb:     http://git.kernel.org/tip/28596b6a8779b736829ad837f95fdc2e81bdd1ee
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 5 Aug 2013 15:02:50 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 6 Aug 2013 14:21:08 -0700

x86, asmlinkage, vdso: Mark vdso variables __visible

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1375740170-7446-17-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/vvar.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index de656ac..d76ac40 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -35,7 +35,7 @@
 
 #define DEFINE_VVAR(type, name)						\
 	type name							\
-	__attribute__((section(".vvar_" #name), aligned(16)))
+	__attribute__((section(".vvar_" #name), aligned(16))) __visible
 
 #define VVAR(name) (*vvaraddr_ ## name)
 
