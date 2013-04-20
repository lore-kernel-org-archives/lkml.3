Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab3DTTGc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 15:06:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:46498 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234Ab3DTTGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 15:06:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,515,1363158000"; 
   d="scan'208";a="298136962"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: Basic perf PMU support for Haswell v11
Date: Sat, 20 Apr 2013 12:06:18 -0700
Message-Id: <1366484783-15613-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is based on v7 of the full Haswell PMU support,
rebased, and stripped down to the bare bones

Most interesting new features are not in this patchkit
(full version is git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc.git hsw/pmu5)

Contains support for:
- Basic Haswell PMU and PEBS support
- Late unmasking of the PMI
- Basic LBRv4 support

v2: Addressed Stephane's feedback. See individual patches for details.
v3: now even more bite-sized. Qualifier constraints merged earlier.
v4: Rename some variables, add some comments and other minor changes.
Add some Reviewed/Tested-bys.
v5: Address some minor review feedback. Port to latest perf/core
v6: Add just some variable names, add comments, edit descriptions, some
more testing, rebased to latest perf/core
v7: Expand comment
v8: Rename structure field.
v9: No wide counters, but add basic LBRs. Add some more 
constraints. Rebase to 3.9rc1
v10: Change some whitespace. Rebase to 3.9rc3
v11: Rebase to perf/core. Fix extra regs. Rename INTX.

-Andi
