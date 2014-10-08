Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbaJHDvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 23:51:03 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:26137 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752846AbaJHDvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 23:51:00 -0400
X-IronPort-AV: E=Sophos;i="5.04,674,1406563200"; 
   d="scan'208";a="36937199"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/3] workqueue: unbound workqueue management Vs hotplug
Date: Wed, 8 Oct 2014 11:53:30 +0800
Message-ID: <1412740423-20782-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, TJ

These patches are for unbound workqueue management (hotplug).

This patchset simplify the unbound workqueue management when hotplug.
This is also a preparation patchset for later unbound workqueue management
patches.

Thanks,
Lai.

Lai Jiangshan (3):
  workqueue: add wq_unbound_online_cpumask
  workqueue: extend wq_pool_mutex to also protect pwq-installation
  workqueue: remove get_online_cpus() from apply_workqueue_attrs()

 kernel/workqueue.c |   61 ++++++++++++++++++++-------------------------------
 1 files changed, 24 insertions(+), 37 deletions(-)

-- 
1.7.4.4

