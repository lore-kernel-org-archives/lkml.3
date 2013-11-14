Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab3KNXeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 18:34:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:7880 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718Ab3KNXd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 18:33:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="409051237"
Subject: [PATCH 0/2] v2: fix hugetlb vs. anon-thp copy page
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, dave.jiang@intel.com, Mel Gorman <mgorman@suse.de>,
        akpm@linux-foundation.org, dhillf@gmail.com,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Thu, 14 Nov 2013 15:33:57 -0800
Message-Id: <20131114233357.90EE35C1@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were only minor comments about this the last time around.
Any reason not not merge it?

