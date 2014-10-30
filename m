Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760432AbaJ3OUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:20:18 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:53502 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757996AbaJ3OUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:20:15 -0400
Date: Thu, 30 Oct 2014 14:14:13 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Vikas Shivappa <vikas.shivappa@intel.com>,
        "Auld, Will" <will.auld@intel.com>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fleming, Matt" <matt.fleming@intel.com>
Subject: Re: Cache Allocation Technology Design
Message-ID: <20141030141413.GT12020@console-pimps.org>
References: <20141028232215.GO12020@console-pimps.org>
 <20141029081640.GT3337@twins.programming.kicks-ass.net>
 <20141029124834.GQ12020@console-pimps.org>
 <20141029134526.GC3337@twins.programming.kicks-ass.net>
 <96EC5A4F3149B74492D2D9B9B1602C27349EEB88@ORSMSX105.amr.corp.intel.com>
 <20141029172845.GP12706@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1410291036070.26215@vshiva-Udesk>
 <20141029182234.GA13393@mtj.dyndns.org>
 <20141030070725.GG3337@twins.programming.kicks-ass.net>
 <20141030124333.GA29540@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030124333.GA29540@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct, at 08:43:33AM, Tejun Heo wrote:
> Hello, Peter.
> 
> On Thu, Oct 30, 2014 at 08:07:25AM +0100, Peter Zijlstra wrote:
> > If this means echo $tid > tasks, then sorry we can't do. There is a
> > limited number of hardware resources backing this thing. At some point
> > they're consumed and something must give.
> 
> And that something shouldn't be disallowing task migration across
> cgroups.  This simply doesn't work with co-mounting or unified
> hierarchy.  cpuset automatically takes on the nearest ancestor's
> configuration which has enough execution resources.  Maybe that can be
> an option for this too?
 
Oh, you can always add more tasks to a cgroup, or move tasks between
cgroups. What you can't always do is create more cgroups.

-- 
Matt Fleming, Intel Open Source Technology Center
