Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaLCTuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 14:50:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbaLCTuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 14:50:21 -0500
Date: Wed, 3 Dec 2014 20:50:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/1] oom: don't assume that a coredumping thread will
	exit soon
Message-ID: <20141203195001.GA11558@redhat.com>
References: <20141127230349.GA25075@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127230349.GA25075@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

This replaces

	oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch

in -mm tree.

The patch is basically the same, but as Michal pointed out
mem_cgroup_out_of_memory() can use the new helper too, it can face
the same problems.

Also, I tried to update the changelog.

Michal, can you ack this version?

Oleg.

