Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbaGOI7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 04:59:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:44559 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbaGOI7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 04:59:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,664,1400050800"; 
   d="scan'208";a="457092141"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v2 0/7] perf, x86: large PEBS interrupt threshold
Date: Tue, 15 Jul 2014 16:58:52 +0800
Message-Id: <1405414739-31455-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements large PEBS interrupt threshold. For some
limited cases, it can significantly reduce the sample overhead. Please
read patch 6's commit message for more information.

changes since v1:
  - drop patch 'perf, core: Add all PMUs to pmu_idr'
  - add comments for case that multiple counters overflow simultaneously

