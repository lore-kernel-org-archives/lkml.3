Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbaF3QUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:20:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932237AbaF3QUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:20:21 -0400
Date: Mon, 30 Jun 2014 18:18:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] rcu: uninline rcu_lock_acquire() and
	rcu_lock_release()
Message-ID: <20140630161837.GA15873@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

May be correct this time ;) Based on paulmck/linux-rcu.git rcu/next.

2/2 is new and hopefully trivial. But! the numbers look suspiciously
good, I do not understand where does the difference come from...

Oleg.

 include/linux/rcupdate.h |   66 +++++++++++++++++++++++----------------------
 include/linux/srcu.h     |    6 ++--
 kernel/rcu/rcu.h         |    6 ++--
 kernel/rcu/update.c      |   53 +++++++++++++++++++++++++++++++++++++
 4 files changed, 93 insertions(+), 38 deletions(-)

