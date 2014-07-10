Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbaGJQAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 12:00:21 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:60630 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752336AbaGJQAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 12:00:19 -0400
X-IronPort-AV: E=Sophos;i="5.00,869,1396972800"; 
   d="scan'208";a="33107678"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/3] workqueue: manager cleanup
Date: Fri, 11 Jul 2014 00:01:02 +0800
Message-ID: <1405008074-11031-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, TJ

These are the cleanups for which you asked during the prevous development,
especailly the patch3 merging start_worker() into create_worker().

Thanks,
Lai


Lai Jiangshan (3):
  workqueue: remove the first check and the return value of
    maybe_create_worker()
  workqueue: remove the guarantee and the retrying of
    maybe_create_worker()
  workqueue: unfold start_worker() into create_worker()

 kernel/workqueue.c |  113 +++++++++++----------------------------------------
 1 files changed, 25 insertions(+), 88 deletions(-)

-- 
1.7.4.4

