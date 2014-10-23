Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbaJWTiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 15:38:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400AbaJWTiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 15:38:12 -0400
Date: Thu, 23 Oct 2014 15:37:59 -0400
From: Dave Jones <davej@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, htejun@gmail.com,
        oleg@redhat.com
Subject: Re: rcu_preempt detected stalls.
Message-ID: <20141023193759.GA14188@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, htejun@gmail.com,
	oleg@redhat.com
References: <20141013173504.GA27955@redhat.com>
 <20141023183232.GW4977@linux.vnet.ibm.com>
 <20141023184018.GA12274@redhat.com>
 <20141023192807.GY4977@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023192807.GY4977@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 12:28:07PM -0700, Paul E. McKenney wrote:
 
 > >  > This one will require more looking.  But did you do something like
 > >  > create a pair of mutually recursive symlinks or something?  ;-)
 > > 
 > > I'm not 100% sure, but this may have been on a box that I was running
 > > tests on NFS. So maybe the server had disappeared with the mount
 > > still active..
 > > 
 > > Just a guess tbh.
 > 
 > Another possibility might be that the box was so overloaded that tasks
 > were getting preempted for 21 seconds as a matter of course, and sometimes
 > within RCU read-side critical sections.  Or did the box have ample idle
 > time?

I fairly recently upped the number of child processes I typically run
with, so it being overloaded does sound highly likely.

	Dave
