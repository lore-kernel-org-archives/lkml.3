Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab3BRSsh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 13:48:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:10619 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753Ab3BRSsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 13:48:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,689,1355126400"; 
   d="scan'208";a="292717927"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Basic perf PMU support for Haswell v8
Date: Mon, 18 Feb 2013 10:48:02 -0800
Message-Id: <1361213287-7636-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is based on v7 of the full Haswell PMU support, but 
ported to the latest perf/core and stripped down to the
bare bones

Only for very extremly basic usage.

Most interesting new features are not in this patchkit
(full version is git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc.git hsw/pmu5)

Contains support for:
- Basic Haswell PMU and PEBS support
- Late unmasking of the PMI
- Support for wide counters

v2: Addressed Stephane's feedback. See individual patches for details.
v3: now even more bite-sized. Qualifier constraints merged earlier.
v4: Rename some variables, add some comments and other minor changes.
Add some Reviewed/Tested-bys.
v5: Address some minor review feedback. Port to latest perf/core
v6: Add just some variable names, add comments, edit descriptions, some
more testing, rebased to latest perf/core
v7: Expand comment
v8: Rename structure field.

-Andi
