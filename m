Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbaG1IDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:03:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:53416 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaG1IDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:03:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,747,1400050800"; 
   d="scan'208";a="579909524"
Date: Mon, 28 Jul 2014 08:01:15 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
        pjt@google.com, bsegall@google.com, arjan.van.de.ven@intel.com,
        len.brown@intel.com, rafael.j.wysocki@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, fengguang.wu@intel.com
Subject: Re: [PATCH 0/2 v4] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140728000115.GB23367@intel.com>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <1405835183.6512.37.camel@marge.simpson.net>
 <20140727193453.GA23367@intel.com>
 <1406533758.5133.238.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406533758.5133.238.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 09:49:18AM +0200, Mike Galbraith wrote:
> On Mon, 2014-07-28 at 03:34 +0800, Yuyang Du wrote: 
> > Thanks a lot, Mike.
> > 
> > Ben asked for this test, but actually I don't know how to get pipe-test, still
> > not even after google it.
> 
> You could write it trivially, it's just pipe ping-pong.  I can send you
> a copy of the one I use if you like.  Ingo wrote it way back in the dark
> ages, I use it to watch out for fastpath lard accumulation.

Yes, please, drop me a copy.

> > So the result is flat compared to before or a pass?
> 
> Yeah, my little box said it was a deep cgroup price noop, but a modest
> win for root.  I love minus signs, they work great, though sometimes in
> highly mysterious ways :)
> 

Minus sign is great, and I hope this patchset is not mysterious, :)

Thanks,
Yuyang
