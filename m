Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaJTPWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:22:22 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:42352 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbaJTPWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:22:19 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 0/4] mm: memcontrol: remove the page_cgroup->flags field
Date: Mon, 20 Oct 2014 11:22:08 -0400
Message-Id: <1413818532-11042-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series gets rid of the remaining page_cgroup flags, thus cutting
the memcg per-page overhead down to one pointer.

 include/linux/page_cgroup.h |  12 ----
 mm/memcontrol.c             | 154 ++++++++++++++++++------------------------
 2 files changed, 64 insertions(+), 102 deletions(-)

