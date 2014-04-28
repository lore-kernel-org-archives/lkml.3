Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbaD1PTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:19:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755335AbaD1PTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:19:43 -0400
Date: Mon, 28 Apr 2014 17:19:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <bsingharora@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Peter Chiang <pchiang@nvidia.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 0/3] memcg: minor ->mm_owner fix/cleanups
Message-ID: <20140428151926.GA20729@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

You applied the last (4th) memcg-kill-config_mm_owner.patch, but other
patches in this thread were ignored. Hopefully thi is because I sent
them chaotically.

Let me resend 1-3 in case you missed them. Acked by Michal.

Oleg.

 init/main.c   |    1 -
 kernel/exit.c |   18 +++++++++++-------
 2 files changed, 11 insertions(+), 8 deletions(-)

