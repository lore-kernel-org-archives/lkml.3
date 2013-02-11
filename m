Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab3BKNvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 08:51:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:23685 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757282Ab3BKNvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 08:51:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,643,1355126400"; 
   d="scan'208";a="285695155"
Date: Mon, 11 Feb 2013 21:51:09 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: netdev@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: WARNING: at net/core/neighbour.c:1545 neigh_table_init()
Message-ID: <20130211135109.GA17277@localhost>
References: <20130209123937.GA23420@localhost>
 <20130211092600.GB23932@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130211092600.GB23932@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 10:26:00AM +0100, Ingo Molnar wrote:
> 
> * Fengguang Wu <fengguang.wu@intel.com> wrote:
> 
> > Greetings,
> > 
> > I got the below oops in linux-next and the first bad commit is
> > 
> > commit 455e987c0c2eb2c9045dc854559474cf41509965
> > Merge: 7c17e48 fd6da69
> > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > Date:   Sat Dec 1 13:07:48 2012 -0800
> > 
> >     Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> 
> This bisection result is probably spurious?

You are right. Sorry! I just fixed a recently introduced bug in the
test script and it probably lead to the wrong bisect.

I've restarted the bisect and the initial steps till now are already
different from that of the previous bisect.

Thanks,
Fengguang
