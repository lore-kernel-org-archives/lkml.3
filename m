Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbaJGIky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 04:40:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:17041 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbaJGIku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 04:40:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,668,1406617200"; 
   d="scan'208";a="584614709"
Date: Tue, 7 Oct 2014 16:40:44 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: Re: [perf] BUG: unable to handle kernel NULL pointer dereference at
 00000085
Message-ID: <20141007084044.GA12300@wfg-t540p.sh.intel.com>
References: <20141004134622.GA5214@wfg-t540p.sh.intel.com>
 <20141004172456.GA7509@worktop.ger.corp.intel.com>
 <20141007050348.GB17972@wfg-t540p.sh.intel.com>
 <20141007081732.GF19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007081732.GF19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 10:17:32AM +0200, Peter Zijlstra wrote:
> On Tue, Oct 07, 2014 at 01:03:48PM +0800, Fengguang Wu wrote:
> > > What is lacking is the actual .config.
> > 
> > Sorry, attached the .config. I expected the script to auto attach it,
> > but obviously it's not yet perfect and failed to attach .config in
> > this case.
> 
> Sure no problem, just figured I'd tell you.
> 
> > > Also the times above (~285 seconds) seem to suggest userspace needs to
> > > do something ?
> > 
> > It's trinity. I'll try upgrade it, but it seems be valid for trinity
> > to feed kernel with any parameters that it can accept -- unless the
> > kernel completely rejects it one day.
> 
> OK, does it make sense to augment that script you have with a trinity
> parameter? Maybe have that userspace read the kernel cmdline and also
> run trinity when observed?  That way you can provide full
> reproduction environments, which it appears you're striving towards.

The trinity binary is included in the initrd image that it downloads,
and will auto run after boot up. I also plan to add trinity as a LKP
test case. :)

Thanks,
Fengguang
