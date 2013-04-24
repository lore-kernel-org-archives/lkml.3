Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab3DXR3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 13:29:33 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:59263 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559Ab3DXR3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 13:29:32 -0400
Date: Wed, 24 Apr 2013 10:29:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, ajax@redhat.com, gusld@br.ibm.com,
        a.p.zijlstra@chello.nl, paulus@samba.org, acme@ghostprotocols.net,
        torvalds@linux-foundation.org
Subject: [GIT PULL events/urgent] Protect access via task_subsys_state_check()
Message-ID: <20130424172912.GA31818@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042417-3620-0000-0000-0000022B9814
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

This pull request is for an RCU-related bug fix in perf_event_comm().
Without this fix, RCU-lockdep splats and other failures result.

This fix is available in the git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/urgent

It has been subjected to -next testing and was posted to LKML at
https://lkml.org/lkml/2013/4/19/403.

							Thanx, Paul

----------------------------------------------------------------
Paul E. McKenney (1):
      events: Protect access via task_subsys_state_check()

 kernel/events/core.c | 2 ++
 1 file changed, 2 insertions(+)

