Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbbANQjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:39:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:31861 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbbANQjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:39:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,756,1413270000"; 
   d="scan'208";a="651077351"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: x86@kernel.org, Aubrey Li <aubrey.li@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "Kumar P, Mahesh" <mahesh.kumar.p@intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v5 0/5] x86: clean ups and feature enhancement in pmc_atom
Date: Wed, 14 Jan 2015 18:39:30 +0200
Message-Id: <1421253575-22509-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Couple of clean ups and one feature enhancement (expose PSS register in the
debug fs).

Changes since v4:
- address one Thomas' comment (patch 1/5 was added)
- rebased on recent linux-next

Changes since v3:
- rebase on top of recent linux-next
- resend to better place for review and push

Changes since v2:
- rebase on top of recent linux-next
- applied Acks
- introduce patch 3/3

Andy Shevchenko (5):
  x86: pmc-atom: assign debugfs node as soon as possible
  x86: pmc_atom: don't check for NULL twice
  x86: pmc-atom: remove unused macro
  x86: pmc_atom: clean up init function
  x86: pmc_atom: expose contents of PSS

 arch/x86/include/asm/pmc_atom.h | 22 +++++++++++
 arch/x86/kernel/pmc_atom.c      | 81 ++++++++++++++++++++++++++++++++---------
 2 files changed, 86 insertions(+), 17 deletions(-)

-- 
2.1.4

