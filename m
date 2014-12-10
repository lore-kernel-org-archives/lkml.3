Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbaLJQNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:13:32 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:47805 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbaLJQNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:13:30 -0500
Date: Wed, 10 Dec 2014 11:13:26 -0500
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
Subject: [GIT PULL] percpu changes for v3.19-rc1
Message-ID: <20141210161326.GB6294@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Nothing interesting.  A patch to convert the remaining __get_cpu_var()
users, another to fix non-critical off-by-one in an assertion and a
cosmetic conversion to lockless_dereference() in percpu-ref.  The pull
from mainline is to receive lockless_dereference().

Thanks.

The following changes since commit 8a84e01e147f44111988f9d8ccd2eaa30215a0f2:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2014-11-21 17:20:36 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.19

for you to fetch changes up to eadac03e898617521f327faf265932b73ecc3e0f:

  percpu: Replace smp_read_barrier_depends() with lockless_dereference() (2014-11-22 09:33:17 -0500)

----------------------------------------------------------------
Christoph Lameter (1):
      percpu: Convert remaining __get_cpu_var uses in 3.18-rcX

Dan Carpenter (1):
      percpu: off by one in BUG_ON()

Pranith Kumar (1):
      percpu: Replace smp_read_barrier_depends() with lockless_dereference()

Tejun Heo (1):
      Merge branch 'master' into for-3.19

 arch/arm64/kernel/psci.c        | 4 ++--
 include/linux/percpu-refcount.h | 4 +---
 kernel/irq_work.c               | 4 ++--
 kernel/time/tick-sched.c        | 2 +-
 mm/percpu.c                     | 2 +-
 5 files changed, 7 insertions(+), 9 deletions(-)

--
tejun
