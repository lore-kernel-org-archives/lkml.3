Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbaIZNXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 09:23:38 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48751 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbaIZNXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 09:23:37 -0400
Date: Fri, 26 Sep 2014 15:23:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sergey Oboguev <oboguev.public@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH 1/2] sched: deferred set priority (dprio) -- rebased for
 the tip
Message-ID: <20140926132330.GF4140@worktop.programming.kicks-ass.net>
References: <CA+80gGaC5tutmFiTCyL-zoBY4BcbZnh63wXhO-g5UetP+w5g4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+80gGaC5tutmFiTCyL-zoBY4BcbZnh63wXhO-g5UetP+w5g4w@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 12:26:04PM -0700, Sergey Oboguev wrote:
> This is a replica of "[PATCH 1/2] dprio" (posted yesterday for 3.16.3)
> rebased now for the current tip (3.17.0-rc6).
> 
> Signed-off-by: Sergey Oboguev <oboguev@yahoo.com>
> 
> ---
>  Documentation/sysctl/kernel.txt |  14 +
>  fs/exec.c                       |   8 +
>  include/linux/dprio.h           | 129 +++++++++
>  include/linux/init_task.h       |  17 ++
>  include/linux/sched.h           |  19 ++
>  include/uapi/linux/Kbuild       |   1 +
>  include/uapi/linux/capability.h |   5 +-
>  include/uapi/linux/dprio_api.h  | 137 +++++++++
>  include/uapi/linux/prctl.h      |   2 +
>  init/Kconfig                    |   2 +
>  kernel/Kconfig.dprio            |  68 +++++
>  kernel/exit.c                   |   6 +
>  kernel/fork.c                   |  88 +++++-
>  kernel/sched/Makefile           |   1 +
>  kernel/sched/core.c             | 195 ++++++++++++-
>  kernel/sched/dprio.c            | 617 ++++++++++++++++++++++++++++++++++++++++
>  kernel/sys.c                    |   6 +
>  kernel/sysctl.c                 |  12 +
>  18 files changed, 1315 insertions(+), 12 deletions(-)

2 lines of changelog for a ~1300 line patch, you must be kidding, right?

What problem is it solving and why do I care?
