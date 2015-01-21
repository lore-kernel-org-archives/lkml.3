Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbbAUJtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:49:11 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:50118 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbbAUJtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:49:05 -0500
Date: Wed, 21 Jan 2015 00:54:32 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        LKP ML <lkp@01.org>
Subject: Re: [LKP] [rcu] 00f5159aeb6: +55.3%
 will-it-scale.time.involuntary_context_switches
Message-ID: <20150121085432.GD9719@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1421825564.6126.29.camel@intel.com>
 <20150121075254.GC9719@linux.vnet.ibm.com>
 <1421827607.5772.19.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421827607.5772.19.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012109-0033-0000-0000-00000366BB21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 09:06:47AM +0100, Mike Galbraith wrote:
> On Tue, 2015-01-20 at 23:52 -0800, Paul E. McKenney wrote: 
> > On Wed, Jan 21, 2015 at 03:32:44PM +0800, Huang Ying wrote:
> > > FYI, we noticed the below changes on
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git stall.2015.01.06a
> > > commit 00f5159aeb68f08ce29597be86be87d6db0c1ba1 ("rcu: Run grace-period kthreads at real-time priority")
> > 
> > Glad this helps!
> 
> The way I read it, it's hurting by increasing context switches... but if
> you'll need a boot param to turn it on in the future, this is moot :)

Heh!  I guess I should read it more carefully.  Anyway, the commit does
help in some heavy-load situations, but something more deft is clearly
required if it is to be enabled more generally.

							Thanx, Paul

