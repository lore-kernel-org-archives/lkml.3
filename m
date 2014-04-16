Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030AbaDPXXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 19:23:36 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:58603 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbaDPXXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 19:23:35 -0400
Date: Wed, 16 Apr 2014 16:23:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <pranith@gatech.edu>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] kernel/rcu/rcutorture.c: use macro to define module
 parameter
Message-ID: <20140416232331.GF4496@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <534EEC6B.8030500@gatech.edu>
 <20140416211407.GA4496@linux.vnet.ibm.com>
 <CAJhHMCBU+u6vmc+vjLCGrSytb74MmpgBCvMZVvR7o9k=3vgchA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCBU+u6vmc+vjLCGrSytb74MmpgBCvMZVvR7o9k=3vgchA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041623-1344-0000-0000-000000F8F0A8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 07:10:41PM -0400, Pranith Kumar wrote:
> On Wed, Apr 16, 2014 at 5:14 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > This fails for me.  The problem is that the defined macro makes everything
> > static, and rcutorture_runnable is used in kernel/sysctl.c.  :-/
> >
> > In theory, it would be possible to make torture_param() take "static"
> > as a parameter, but this adds more characters than it removes.
> >
> 
> Oh, I just tried building it as a module and it worked. In the future
> I will run this both as inbuilt and as a module before sending any
> patches.
> 
> Sorry for the noise!

This is not noise!  I do intend to use it as a module in the future, so
it is helpful that you found and fixed the other bugs.  I really cannot
complain about one bad patch out of several useful fixes!  So please
do keep trying things and looking at things in RCU.  ;-)

							Thanx, Paul

