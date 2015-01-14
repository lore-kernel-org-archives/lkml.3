Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbbANQkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:40:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:36977 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbbANQji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:39:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,756,1413270000"; 
   d="scan'208";a="661802468"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: x86@kernel.org, Aubrey Li <aubrey.li@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "Kumar P, Mahesh" <mahesh.kumar.p@intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v5 3/5] x86: pmc-atom: remove unused macro
Date: Wed, 14 Jan 2015 18:39:33 +0200
Message-Id: <1421253575-22509-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421253575-22509-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1421253575-22509-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DRIVER_NAME seems unused. This patch just removes it. There is no functional
change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
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
-- 
2.1.4

