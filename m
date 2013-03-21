Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab3CUUAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:00:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:37780 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab3CUUAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:00:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,888,1355126400"; 
   d="scan'208";a="310162231"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, tglx@linutronix.de, eranian@google.com,
        torvalds@linux-foundation.org
Subject: Basic perf PMU support for Haswell v10
Date: Thu, 21 Mar 2013 12:59:50 -0700
Message-Id: <1363895995-12967-1-git-send-email-andi@firstfloor.org>
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

-Andi
