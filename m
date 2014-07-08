Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbaGHWck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:32:40 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:57923 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbaGHWcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:32:39 -0400
MIME-Version: 1.0
In-Reply-To: <1404858378-23806-1-git-send-email-bobby.prani@gmail.com>
References: <1404858378-23806-1-git-send-email-bobby.prani@gmail.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Tue, 8 Jul 2014 18:32:03 -0400
Message-ID: <CAJhHMCDUy_=LZWkhA5OU3WsfpyFwxwDJGT6rnqY3E6t=ZXQk3g@mail.gmail.com>
Subject: Re: [PATCH 0/9] rcu: trivial sparse and return type fixes for rcu
To: LKML <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains trivial fixes for sparse warnings and using bool
types where appropriate instead of 0/1.

I can probably merge the return type changes into one commit if you think that
is appropriate.

Pranith Kumar (9):
  rcu: fix sparse warning about rcu_batches_completed_preempt(
) being
    non-static
  rcu: use bool type for return value in rcu_is_watching()
  rcu: Fix a sparse warning about boost_mutex being non-static
  rcu: return bool type in rcu_lockdep_current_cpu_online()
  rcu: return bool type for rcu_try_advance_all_cbs()
  rcu: use true/false for return in __call_rcu_nocb()
  rcu: use true/false for return in rcu_nocb_adopt_orphan_cbs()
  rcu: use false for return in __call_rcu_nocb()
  rcu: use bool return type in rcu_nocb_adopt_orphan_cbs()

 include/linux/rcupdate.h |  2 +-
 kernel/rcu/rcutorture.c  |  2 +-
 kernel/rcu/tree.c        |  2 +-
 kernel/rcu/tree_plugin.h | 16 ++++++++--------
 4 files changed, 11 insertions(+), 11 deletions(-)
