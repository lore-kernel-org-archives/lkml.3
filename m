Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbaJGIRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 04:17:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:53738 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbaJGIRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 04:17:43 -0400
Date: Tue, 7 Oct 2014 10:17:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: Re: [perf] BUG: unable to handle kernel NULL pointer dereference at
 00000085
Message-ID: <20141007081732.GF19379@twins.programming.kicks-ass.net>
References: <20141004134622.GA5214@wfg-t540p.sh.intel.com>
 <20141004172456.GA7509@worktop.ger.corp.intel.com>
 <20141007050348.GB17972@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007050348.GB17972@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 01:03:48PM +0800, Fengguang Wu wrote:
> > What is lacking is the actual .config.
> 
> Sorry, attached the .config. I expected the script to auto attach it,
> but obviously it's not yet perfect and failed to attach .config in
> this case.

Sure no problem, just figured I'd tell you.

> > Also the times above (~285 seconds) seem to suggest userspace needs to
> > do something ?
> 
> It's trinity. I'll try upgrade it, but it seems be valid for trinity
> to feed kernel with any parameters that it can accept -- unless the
> kernel completely rejects it one day.

OK, does it make sense to augment that script you have with a trinity
parameter? Maybe have that userspace read the kernel cmdline and also
run trinity when observed?

That way you can provide full reproduction environments, which it
appears you're striving towards.


