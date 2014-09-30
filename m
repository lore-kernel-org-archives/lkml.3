Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbaI3TW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 15:22:26 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:51800 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbaI3TWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 15:22:25 -0400
Date: Tue, 30 Sep 2014 12:22:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [torture] BUG: unable to handle kernel NULL pointer dereference
 at (null)
Message-ID: <20140930192220.GT5015@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140913122412.GA10984@localhost>
 <20140915202710.GG4723@linux.vnet.ibm.com>
 <20140917023154.GA9519@localhost>
 <20140917161704.GZ4723@linux.vnet.ibm.com>
 <20140918131751.GA8797@localhost>
 <20140926074223.GN4723@linux.vnet.ibm.com>
 <20140930022740.GA4723@wfg-t540p.sh.intel.com>
 <20140930095842.GR5015@linux.vnet.ibm.com>
 <20140930114138.GA3974@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930114138.GA3974@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14093019-7164-0000-0000-00000503B99D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 07:41:38PM +0800, Fengguang Wu wrote:
> Hi Paul,
> 
> > One thing would be something like this:
> > 
> > 	( sleep 300; rmmod rcutorture ) &
> > 
> > Running both locktorture and rcutorture concurrently is not supported
> > at the moment because both make the assumption that they have the entire
> > system at their disposal.
> 
> It's good to know that! Following your instructions, I just added 2
> test cases for rcutorture and locktorture in LKP. :)

Very good!  Please let me know how it goes.

							Thanx, Paul

