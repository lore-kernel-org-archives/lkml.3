Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbaGHKSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 06:18:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:43973 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139AbaGHKSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 06:18:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,625,1400050800"; 
   d="scan'208";a="558763566"
Date: Tue, 8 Jul 2014 18:18:41 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, ZhaoLei <zhaolei@cn.fujitsu.com>
Subject: Re: [timer] BUG: soft lockup - CPU#1 stuck for 23s! [swapper/0:1]
Message-ID: <20140708101841.GA26073@localhost>
References: <20140708034521.GD17142@localhost>
 <alpine.DEB.2.10.1407081208060.4357@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1407081208060.4357@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 12:08:53PM +0200, Thomas Gleixner wrote:
> On Tue, 8 Jul 2014, Fengguang Wu wrote:
> 
> > Greetings,
> > 
> > 0day kernel testing robot got the below dmesg and the first bad commit is
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > commit 1ead65812486cda65093683a99b8907a7242fa93
> > Merge: b6d739e b97f029
> > Author:     Linus Torvalds <torvalds@linux-foundation.org>
> > AuthorDate: Tue Apr 1 11:00:07 2014 -0700
> > Commit:     Linus Torvalds <torvalds@linux-foundation.org>
> > CommitDate: Tue Apr 1 11:00:07 2014 -0700
> 
> That's not really helpful. It's a merge commit, so we'd need to drill
> down the bisect into what got merged.

Yes, it is. We'll try to refine the bisect.

Thanks,
Fengguang
