Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab3HMG3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:29:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:39774 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755741Ab3HMG3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:29:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,867,1367996400"; 
   d="scan'208";a="345514391"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, eranian@google.com, ak@linux.intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V2 0/3] perf, uncore: updates
Date: Tue, 13 Aug 2013 14:29:39 +0800
Message-Id: <1376375382-21350-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

These 3 patches enable uncore QPI traffic filter and  extra_sel_bit
for uncore PCU.

Regards
Yan, Zheng
---
Changes since v1: update commit messages
