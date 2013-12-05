Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445Ab3LEBWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 20:22:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756355Ab3LEBW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 20:22:28 -0500
Date: Wed, 4 Dec 2013 20:22:06 -0500
From: Dave Jones <davej@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: lots of brief rcu stalls.
Message-ID: <20131205012206.GA31349@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20131204232838.GA25592@redhat.com>
 <20131205001614.GI15492@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205001614.GI15492@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 04:16:14PM -0800, Paul E. McKenney wrote:
 > On Wed, Dec 04, 2013 at 06:28:38PM -0500, Dave Jones wrote:
 > > Paul,
 > > I'm seeing this happening more and more lately...
 > > 
 > > [  771.786462] INFO: rcu_preempt detected stalls on CPUs/tasks:
 > > [  771.786552] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
 > > [  771.786574] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
 > > [  771.786595] 	(detected by 0, t=6502 jiffies, g=20611, c=20610, q=0)
 > > [  771.786620] INFO: Stall ended before state dump start
 > > [  966.724546] INFO: rcu_preempt detected stalls on CPUs/tasks:
 > > [  966.724854] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
 > > [  966.724931] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
 > > [  966.725005] 	(detected by 0, t=26007 jiffies, g=20611, c=20610, q=0)
 > > [  966.725093] INFO: Stall ended before state dump start
 > > [ 1161.661459] INFO: rcu_preempt detected stalls on CPUs/tasks:
 > > [ 1161.661763] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
 > > [ 1161.661840] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
 > > [ 1161.661915] 	(detected by 0, t=45512 jiffies, g=20611, c=20610, q=0)
 > > [ 1161.662001] INFO: Stall ended before state dump start
 > > [ 1356.598205] INFO: rcu_preempt detected stalls on CPUs/tasks:
 > > [ 1356.598513] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
 > > [ 1356.598590] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
 > > [ 1356.598664] 	(detected by 0, t=65017 jiffies, g=20611, c=20610, q=0)
 > > [ 1356.598751] INFO: Stall ended before state dump start
 > > [ 1551.536099] INFO: rcu_preempt detected stalls on CPUs/tasks:
 > > [ 1551.536408] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
 > > [ 1551.536485] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
 > > [ 1551.536559] 	(detected by 0, t=84522 jiffies, g=20611, c=20610, q=0)
 > > [ 1551.536645] INFO: Stall ended before state dump start
 > > 
 > > While it's apparently a non-problem, it's pretty noisy.
 > > Any ideas?
 > 
 > Does the following help?

Seems so so far!

	Dave

