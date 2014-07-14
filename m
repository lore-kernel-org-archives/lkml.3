Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbaGNEEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 00:04:32 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:18766 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750703AbaGNEEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 00:04:24 -0400
X-IronPort-AV: E=Sophos;i="5.00,886,1396972800"; 
   d="scan'208";a="33221100"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/1 V2] workqueue: manager cleanup
Date: Mon, 14 Jul 2014 12:05:06 +0800
Message-ID: <1405310716-12270-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1405008074-11031-1-git-send-email-laijs@cn.fujitsu.com>
References: <1405008074-11031-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, TJ,

I dropped the patch1 & patch2 of the V1, only the patch3 is kept and
re-based. The new patch depends on the patch of last night:
"workqueue: remove the del_timer_sync()s in maybe_create_worker()".

Thanks,
Lai

Lai Jiangshan (1):
  workqueue: unfold start_worker() into create_worker()

 kernel/workqueue.c |   69 ++++++++++------------------------------------------
 1 files changed, 13 insertions(+), 56 deletions(-)

-- 
1.7.4.4

