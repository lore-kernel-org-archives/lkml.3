Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034Ab3BGTXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:23:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:61556 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755617Ab3BGTXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:23:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,623,1355126400"; 
   d="scan'208";a="259237571"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, eranian@google.com
Subject: Basic perf PMU support for Haswell v5
Date: Thu,  7 Feb 2013 11:23:34 -0800
Message-Id: <1360265019-23865-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is based on v7 of the full Haswell PMU support, but 
ported to the latest perf/core and stripped down to the
bare bones

Only for very extremly basic usage.

Most interesting new features are not in this patchkit
(full version is
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc.git hsw/pmu5)

Contains support for:
- Basic Haswell PMU and PEBS support
- Late unmasking of the PMI
- Support for wide counters

v2: Addressed Stephane's feedback. See individual patches for details.
v3: now even more bite-sized. Qualifier constraints merged earlier.
v4: Rename some variables, add some comments and other minor changes.
v5: Address some minor review feedback. Port to latest perf/core
Add some Reviewed/Tested-bys.

-Andi
