Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaKLRWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 12:22:16 -0500
Received: from mga03.intel.com ([134.134.136.65]:39767 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbaKLRWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 12:22:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,370,1413270000"; 
   d="scan'208";a="606720874"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "H . Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
        Aubrey Li <aubrey.li@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "Kumar P, Mahesh" <mahesh.kumar.p@intel.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v4 0/3] x86: clean ups and feature enhancement in pmc_atom
Date: Wed, 12 Nov 2014 19:18:06 +0200
Message-Id: <1415812689-17326-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Couple of clean ups and one feature enhancement (expose PSS register in the
debug fs).

Changes since v3:
- rebase on top of recent linux-next
- resend to better place for review and push

Changes since v2:
- rebase on top of recent linux-next
- applied Acks
- introduce patch 3/3

Andy Shevchenko (3):
  x86: pmc_atom: clean up init function
  x86: pmc_atom: don't check for NULL twice
  x86: pmc_atom: expose contents of PSS

 arch/x86/include/asm/pmc_atom.h | 22 ++++++++++++
 arch/x86/kernel/pmc_atom.c      | 75 +++++++++++++++++++++++++++++++++--------
 2 files changed, 83 insertions(+), 14 deletions(-)

-- 
2.1.3

