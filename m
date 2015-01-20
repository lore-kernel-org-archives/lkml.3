Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbbATVwG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 16:52:06 -0500
Received: from mga14.intel.com ([192.55.52.115]:15696 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098AbbATVuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 16:50:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,437,1418112000"; 
   d="scan'208";a="640071610"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: x86@kernel.org, Aubrey Li <aubrey.li@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "Kumar P, Mahesh" <mahesh.kumar.p@intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 0/4] x86: pmc_atom: Add Cherrytrail support
Date: Tue, 20 Jan 2015 23:49:59 +0200
Message-Id: <1421790603-30097-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the reworked patch series which had been sent earlier [1] to support
Intel CherryTrail SoC.

The patches were tested on both BayTrail and CherryTrail SoCs.

[1] https://patchwork.kernel.org/patch/5235891/

Changes to v1:
 - rebased on top of recent pmc_atom changes
 - cleaned up, reqorked and split to few smaller patches

Andy Shevchenko (4):
  x86: pmc_atom: save struct device pointer in pmc
  x86: pmc_atom: print index of device in loop
  x86: pmc_atom: supply register mappings via pmc object
  PMC driver: Add Cherrytrail PMC interface

 arch/x86/include/asm/pmc_atom.h |  25 ++++
 arch/x86/kernel/pmc_atom.c      | 270 +++++++++++++++++++++++++---------------
 2 files changed, 198 insertions(+), 97 deletions(-)

-- 
2.1.4

