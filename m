Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab3CEV7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 16:59:50 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:35461 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab3CEV7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 16:59:48 -0500
Date: Tue, 5 Mar 2013 22:59:46 +0100
From: Andreas Mohr <andi@lisas.de>
To: Borislav Petkov <bp@alien8.de>, Peter Feuerer <peter@piie.net>,
        Andreas Mohr <andi@lisas.de>, Zhang Rui <rui.zhang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Durgadoss R <durgadoss.r@intel.com>,
        Alexander Lam <azl@andrew.cmu.edu>
Subject: Re: [PATCH] acerhdf: Fix fan activation with new thermal governor
Message-ID: <20130305215946.GA16796@rhlx01.hs-esslingen.de>
References: <20130222111521.GA25473@pd.tnic>
 <1361647210-12983-1-git-send-email-bp@alien8.de>
 <20130224112851.GA19609@pd.tnic>
 <cone.1361706175.908398.1806.1000@galar>
 <20130224143452.GE19609@pd.tnic>
 <1361762514.2303.21.camel@rzhang1-mobl4>
 <20130225102526.GB12067@pd.tnic>
 <20130225121608.GC12067@pd.tnic>
 <20130304133410.GC22274@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130304133410.GC22274@pd.tnic>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Mar 04, 2013 at 02:34:10PM +0100, Borislav Petkov wrote:
> On Mon, Feb 25, 2013 at 01:16:08PM +0100, Borislav Petkov wrote:
> > Ok, doing a short test here proves successful. I'll run it the next days
> > too to make sure - it would be nice if people could confirm my test
> > results, though.
> > 
> > Tested-by: Borislav Petkov <bp@suse.de>
> 
> Pjooiiing!
> 
> Andreas, Peter, can you guys give http://lkml.org/lkml/2012/12/30/47 a run?

I'm now running 3.8 proper with only that patch plus my local
beautification-only (really shouldn't matter)
acerhdf updates (now properly split ;),
and so far fan behaviour seems fine, over various usage conditions.
Haven't really stressed it mischievously yet, though. Will do more testing.

So this now does not have any of the Schmitt trigger equivalent (?)
governor changes that were nicely discussed in this activity -
So what do we want to have committed, and what do we not,
and most importantly, does it all work fatally precisely correctly? ;)
(remember, this is thermal layer, not particularly a place for sloppiness)

Thanks,

Andreas Mohr
