Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab3KOXHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:07:11 -0500
Received: from mga14.intel.com ([143.182.124.37]:37226 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307Ab3KOXHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:07:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,710,1378882800"; 
   d="scan'208";a="428544776"
Subject: [v3][PATCH 0/2] v3: fix hugetlb vs. anon-thp copy page
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        akpm@linux-foundation.org, dhillf@gmail.com,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Mel Gorman <mgorman@suse.de>, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Fri, 15 Nov 2013 14:55:50 -0800
Message-Id: <20131115225550.737E5C33@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This took some of Mel's comments in to consideration.  Dave
Jiang, could you retest this if you get a chance?  These have
only been lightly compile-tested.

