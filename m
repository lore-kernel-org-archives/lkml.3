Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab3BEQYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:24:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57445 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab3BEQYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:24:11 -0500
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Tejun Heo <htejun@gmail.com>
Subject: [PATCH 0/3] cleanup memcg controller initialization
Date: Tue,  5 Feb 2013 17:23:58 +0100
Message-Id: <1360081441-1960-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
this is just a small cleanup I promised some time ago[1]. It just moves
all memcg controller initialization code independant on mem_cgroup into
subsystem initialization code.

There are no functional changes.

Diffstat even says that we have saved some lines.
 mm/memcontrol.c |   49 +++++++++++++++++++++----------------------------
 1 file changed, 21 insertions(+), 28 deletions(-)

Shortlog says:
Michal Hocko (3):
      memcg: move mem_cgroup_soft_limit_tree_init to mem_cgroup_init
      memcg: move memcg_stock initialization to mem_cgroup_init
      memcg: cleanup mem_cgroup_init comment
---
[1] https://lkml.org/lkml/2012/12/18/256
