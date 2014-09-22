Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbaIVQA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:00:57 -0400
Received: from mx2.parallels.com ([199.115.105.18]:60462 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbaIVQA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:00:56 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Christoph Lameter <cl@linux.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH v2 0/3] memcg: trivial cleanups in kmemcg core
Date: Mon, 22 Sep 2014 20:00:43 +0400
Message-ID: <cover.1411401021.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set does exactly the same thing as

https://lkml.org/lkml/2014/9/18/315

but it's commented better (thanks to Michal).

Vladimir Davydov (3):
  memcg: move memcg_{alloc,free}_cache_params to slab_common.c
  memcg: don't call memcg_update_all_caches if new cache id fits
  memcg: move memcg_update_cache_size to slab_common.c

 include/linux/memcontrol.h |   15 -----
 mm/memcontrol.c            |  154 ++++++++++++--------------------------------
 mm/slab_common.c           |   74 ++++++++++++++++++++-
 3 files changed, 111 insertions(+), 132 deletions(-)

-- 
1.7.10.4

