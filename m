Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaBND6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 22:58:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47821 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaBND6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 22:58:10 -0500
Date: Thu, 13 Feb 2014 19:57:57 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-d47d5c8194579bce1d62f88e26fea91d7c553e42@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1391845930-28580-2-git-send-email-ak@linux.intel.com>
References: <1391845930-28580-2-git-send-email-ak@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] asmlinkage: Make __iowrite32_copy visible
Git-Commit-ID: d47d5c8194579bce1d62f88e26fea91d7c553e42
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 13 Feb 2014 19:58:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d47d5c8194579bce1d62f88e26fea91d7c553e42
Gitweb:     http://git.kernel.org/tip/d47d5c8194579bce1d62f88e26fea91d7c553e42
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sat, 8 Feb 2014 08:51:58 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Feb 2014 18:12:04 -0800

asmlinkage: Make __iowrite32_copy visible

This is a assembler function on x86, so it should be visible.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1391845930-28580-2-git-send-email-ak@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 include/linux/io.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/io.h b/include/linux/io.h
index f4f42fa..8a18e75 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -24,7 +24,7 @@
 
 struct device;
 
-void __iowrite32_copy(void __iomem *to, const void *from, size_t count);
+__visible void __iowrite32_copy(void __iomem *to, const void *from, size_t count);
 void __iowrite64_copy(void __iomem *to, const void *from, size_t count);
 
 #ifdef CONFIG_MMU
