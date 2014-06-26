Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbaFZRC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:02:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757500AbaFZRCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:02:55 -0400
Date: Thu, 26 Jun 2014 19:01:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] rcu: uninline rcu_lock_acquire() and rcu_lock_release()
Message-ID: <20140626170116.GA28558@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

sorry for delay with resend...

The patch is simple and the numbers look good (and probably we can do more).
But when I re-diffed this change I noticed that rcu_lockdep_assert() has the
warn-once semantics, and this patch obviously changes the behaviour. So please
ack/nack this part too.

Oleg.

