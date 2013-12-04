Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab3LDX2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 18:28:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370Ab3LDX2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 18:28:47 -0500
Date: Wed, 4 Dec 2013 18:28:38 -0500
From: Dave Jones <davej@redhat.com>
To: paulmck@linux.vnet.ibm.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: lots of brief rcu stalls.
Message-ID: <20131204232838.GA25592@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, paulmck@linux.vnet.ibm.com,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,
I'm seeing this happening more and more lately...

[  771.786462] INFO: rcu_preempt detected stalls on CPUs/tasks:
[  771.786552] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
[  771.786574] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
[  771.786595] 	(detected by 0, t=6502 jiffies, g=20611, c=20610, q=0)
[  771.786620] INFO: Stall ended before state dump start
[  966.724546] INFO: rcu_preempt detected stalls on CPUs/tasks:
[  966.724854] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
[  966.724931] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
[  966.725005] 	(detected by 0, t=26007 jiffies, g=20611, c=20610, q=0)
[  966.725093] INFO: Stall ended before state dump start
[ 1161.661459] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 1161.661763] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
[ 1161.661840] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
[ 1161.661915] 	(detected by 0, t=45512 jiffies, g=20611, c=20610, q=0)
[ 1161.662001] INFO: Stall ended before state dump start
[ 1356.598205] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 1356.598513] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
[ 1356.598590] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
[ 1356.598664] 	(detected by 0, t=65017 jiffies, g=20611, c=20610, q=0)
[ 1356.598751] INFO: Stall ended before state dump start
[ 1551.536099] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 1551.536408] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
[ 1551.536485] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
[ 1551.536559] 	(detected by 0, t=84522 jiffies, g=20611, c=20610, q=0)
[ 1551.536645] INFO: Stall ended before state dump start

While it's apparently a non-problem, it's pretty noisy.
Any ideas?

	Dave

