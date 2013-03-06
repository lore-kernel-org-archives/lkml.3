Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab3CFDr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 22:47:28 -0500
Received: from mga14.intel.com ([143.182.124.37]:20783 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab3CFDrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 22:47:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,791,1355126400"; 
   d="scan'208";a="265014250"
Message-ID: <1362541640.2441.3.camel@rzhang1-mobl4>
Subject: Re: [PATCH] acerhdf: Fix fan activation with new thermal governor
From: Zhang Rui <rui.zhang@intel.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Borislav Petkov <bp@alien8.de>, Peter Feuerer <peter@piie.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Durgadoss R <durgadoss.r@intel.com>,
        Alexander Lam <azl@andrew.cmu.edu>
Date: Wed, 06 Mar 2013 11:47:20 +0800
In-Reply-To: <20130305215946.GA16796@rhlx01.hs-esslingen.de>
References: <20130222111521.GA25473@pd.tnic>
	 <1361647210-12983-1-git-send-email-bp@alien8.de>
	 <20130224112851.GA19609@pd.tnic> <cone.1361706175.908398.1806.1000@galar>
	 <20130224143452.GE19609@pd.tnic> <1361762514.2303.21.camel@rzhang1-mobl4>
	 <20130225102526.GB12067@pd.tnic> <20130225121608.GC12067@pd.tnic>
	 <20130304133410.GC22274@pd.tnic>
	 <20130305215946.GA16796@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-05 at 22:59 +0100, Andreas Mohr wrote:
> Hi,
> 
> On Mon, Mar 04, 2013 at 02:34:10PM +0100, Borislav Petkov wrote:
> > On Mon, Feb 25, 2013 at 01:16:08PM +0100, Borislav Petkov wrote:
> > > Ok, doing a short test here proves successful. I'll run it the next days
> > > too to make sure - it would be nice if people could confirm my test
> > > results, though.
> > > 
> > > Tested-by: Borislav Petkov <bp@suse.de>
> > 
> > Pjooiiing!
> > 
> > Andreas, Peter, can you guys give http://lkml.org/lkml/2012/12/30/47 a run?
> 
> I'm now running 3.8 proper with only that patch plus my local
> beautification-only (really shouldn't matter)
> acerhdf updates (now properly split ;),
> and so far fan behaviour seems fine, over various usage conditions.
> Haven't really stressed it mischievously yet, though. Will do more testing.
> 
> So this now does not have any of the Schmitt trigger equivalent (?)
> governor changes that were nicely discussed in this activity -
> So what do we want to have committed, and what do we not,

the problem should have been fixed in 3.9-rc1 by
commit b8bb6cb999858043489c1ddef08eed2127559169
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Nov 22 15:45:02 2012 +0800

    step_wise: Unify the code for both throttle and dethrottle

    Signed-off-by: Zhang Rui <rui.zhang@intel.com>

I'll send Alexander' patch for 3.8 stable.

thanks,
rui
> and most importantly, does it all work fatally precisely correctly? ;)
> (remember, this is thermal layer, not particularly a place for sloppiness)
> 
> Thanks,
> 
> Andreas Mohr


