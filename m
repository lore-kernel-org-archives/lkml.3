Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbaFKSha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 14:37:30 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:55142 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbaFKSh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 14:37:29 -0400
From: Jason Low <jason.low2@hp.com>
To: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, tim.c.chen@linux.intel.com,
        paulmck@linux.vnet.ibm.com, rostedt@goodmis.org, davidlohr@hp.com,
        Waiman.Long@hp.com, scott.norton@hp.com, aswin@hp.com,
        jason.low2@hp.com
Subject: [PATCH v2 0/4] mutex: Modifications to mutex
Date: Wed, 11 Jun 2014 11:37:19 -0700
Message-Id: <1402511843-4721-1-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1->v2:
- Remove the MUTEX_SHOW_NO_WAITER() macro.
- Use !mutex_is_locked() instead of introducing a new MUTEX_IS_UNLOCKED() macro.
- Add more information to the changelog of the "Optimize mutex trylock slowpath"
  patch

This patchset contains documentation fixes and optimizations for mutex.

Jason Low (4):
  mutex: Correct documentation on mutex optimistic spinning
  mutex: Delete the MUTEX_SHOW_NO_WAITER macro
  mutex: Try to acquire mutex only if it is unlocked
  mutex: Optimize mutex trylock slowpath

 kernel/locking/mutex.c |   35 ++++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 17 deletions(-)

