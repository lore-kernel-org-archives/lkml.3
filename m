Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaFFD5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 23:57:52 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:1529 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751774AbaFFD5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 23:57:51 -0400
X-IronPort-AV: E=Sophos;i="4.98,986,1392134400"; 
   d="scan'208";a="31545952"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <toshi.kani@hp.com>, <tj@kernel.org>, <hpa@zytor.com>, <mingo@elte.hu>,
        <laijs@cn.fujitsu.com>
CC: <isimatu.yasuaki@jp.fujitsu.com>, <hutao@cn.fujitsu.com>,
        <guz.fnst@cn.fujitsu.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH v2 0/2] Fix for memory online/offline.
Date: Fri, 6 Jun 2014 11:58:52 +0800
Message-ID: <1402027134-14423-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches does some fixes in memory online/offline process.

Tang Chen (2):
  mem-hotplug: Avoid illegal state prefixed with legal state when
    changing state of memory_block.
  mem-hotplug: Introduce MMOP_OFFLINE to replace the hard coding -1.

 drivers/base/memory.c          | 24 ++++++++++++------------
 include/linux/memory_hotplug.h |  9 +++++----
 mm/memory_hotplug.c            |  9 ++++++---
 3 files changed, 23 insertions(+), 19 deletions(-)

-- 
1.8.3.1

