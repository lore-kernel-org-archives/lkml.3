Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbaIRNSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 09:18:07 -0400
Received: from mga14.intel.com ([192.55.52.115]:5757 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbaIRNSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 09:18:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,547,1406617200"; 
   d="scan'208";a="593247772"
Date: Thu, 18 Sep 2014 21:17:51 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [torture] BUG: unable to handle kernel NULL pointer dereference
 at (null)
Message-ID: <20140918131751.GA8797@localhost>
References: <20140913122412.GA10984@localhost>
 <20140915202710.GG4723@linux.vnet.ibm.com>
 <20140917023154.GA9519@localhost>
 <20140917161704.GZ4723@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917161704.GZ4723@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

> > > > plymouth-upstart-bridge: ply-event-loop.c:497: ply_event_loop_new: Assertion `loop->epoll_fd >= 0' failed.
> > > > /etc/lsb-base-logging.sh: line 5:  2580 Aborted                 plymouth --ping > /dev/null 2>&1
> > > > /etc/lsb-base-logging.sh: line 5:  2585 Aborted                 plymouth --ping > /dev/null 2>&1
> > > > mount: proc has wrong device number or fs type proc not supported
> > > > /etc/lsb-base-logging.sh: line 5:  2601 Aborted                 plymouth --ping > /dev/null 2>&1
> > > > /etc/rc6.d/S40umountfs: line 20: /proc/mounts: No such file or directory
> > > > cat: /proc/1/maps: No such file or directory
> > > > cat: /proc/1/maps: No such file or directory
> > > > cat: /proc/1/maps: No such file or directory
> > > > cat: /proc/1/maps: No such file or directory
> > > > cat: /proc/1/maps: No such file or directory
> > > > cat: /proc/1/maps: No such file or directory
> > > > umount: /var/run: not mounted
> > > > umount: /var/lock: not mounted
> > > > umount: /dev/shm: not mounted
> > > > mount: / is busy
> > > >  * Will now restart
> 
> Are these expected behavior?

Yes, because it's randconfig boot tests, the user space may well
complain about random stuff and I'll ignore them all as long as it
will eventually call the shutdown command to finish the test in time.  :)

> So again, I can invoke this commit without losing much (sendkey
> alt-sysrq-z is after all my friend), but it is not clear to me that we
> have gotten to the root of this problem.

Sorry about that! If you see any debug tricks that I can try, or
information I can collect, please let me know.

Regards,
Fengguang
