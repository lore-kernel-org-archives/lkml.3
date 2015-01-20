Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbbATLzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:55:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56621 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbbATLze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:55:34 -0500
Date: Tue, 20 Jan 2015 03:55:22 -0800
From: tip-bot for Andy Shevchenko <tipbot@zytor.com>
Message-ID: <tip-4922b9ce89ccdeb99364666f1fcc297c4af31bf7@git.kernel.org>
Cc: aubrey.li@linux.intel.com, mahesh.kumar.p@intel.com, tglx@linutronix.de,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@kernel.org, andriy.shevchenko@linux.intel.com
Reply-To: mingo@kernel.org, andriy.shevchenko@linux.intel.com,
        aubrey.li@linux.intel.com, mahesh.kumar.p@intel.com,
        linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com,
        tglx@linutronix.de, hpa@zytor.com
In-Reply-To: <1421253575-22509-4-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1421253575-22509-4-git-send-email-andriy.shevchenko@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: pmc-atom: Remove unused macro
Git-Commit-ID: 4922b9ce89ccdeb99364666f1fcc297c4af31bf7
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

Commit-ID:  4922b9ce89ccdeb99364666f1fcc297c4af31bf7
Gitweb:     http://git.kernel.org/tip/4922b9ce89ccdeb99364666f1fcc297c4af31bf7
Author:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
AuthorDate: Wed, 14 Jan 2015 18:39:33 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 20 Jan 2015 12:50:14 +0100

x86: pmc-atom: Remove unused macro

DRIVER_NAME seems unused. This patch just removes it. There is no functional
change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Aubrey Li <aubrey.li@linux.intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Kumar P. Mahesh <mahesh.kumar.p@intel.com>
Link: http://lkml.kernel.org/r/1421253575-22509-4-git-send-email-andriy.shevchenko@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/pmc_atom.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
index 1dd6c62..6b62f55 100644
--- a/arch/x86/kernel/pmc_atom.c
+++ b/arch/x86/kernel/pmc_atom.c
@@ -25,8 +25,6 @@
 
 #include <asm/pmc_atom.h>
 
-#define	DRIVER_NAME	KBUILD_MODNAME
-
 struct pmc_dev {
 	u32 base_addr;
 	void __iomem *regmap;
