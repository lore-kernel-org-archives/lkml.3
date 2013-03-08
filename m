Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933843Ab3CHXv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 18:51:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:50380 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756564Ab3CHXvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 18:51:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,810,1355126400"; 
   d="scan'208";a="274510210"
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: Basic perf PMU support for Haswell v9
Date: Fri,  8 Mar 2013 15:49:28 -0800
Message-Id: <1362786573-18455-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is based on v7 of the full Haswell PMU support,
rebased, reviewer-optimized and stripped down to the bare bones

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

-Andi
