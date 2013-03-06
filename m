Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab3CFHag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:30:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:29583 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab3CFHaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:30:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,793,1355126400"; 
   d="scan'208";a="271963328"
Message-ID: <1362555028.2441.21.camel@rzhang1-mobl4>
Subject: Re: [PATCH] acerhdf: Fix fan activation with new thermal governor
From: Zhang Rui <rui.zhang@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Andreas Mohr <andi@lisas.de>, Peter Feuerer <peter@piie.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Durgadoss R <durgadoss.r@intel.com>,
        Alexander Lam <azl@andrew.cmu.edu>
Date: Wed, 06 Mar 2013 15:30:28 +0800
In-Reply-To: <20130306070057.GA30673@pd.tnic>
References: <1361647210-12983-1-git-send-email-bp@alien8.de>
	 <20130224112851.GA19609@pd.tnic> <cone.1361706175.908398.1806.1000@galar>
	 <20130224143452.GE19609@pd.tnic> <1361762514.2303.21.camel@rzhang1-mobl4>
	 <20130225102526.GB12067@pd.tnic> <20130225121608.GC12067@pd.tnic>
	 <20130304133410.GC22274@pd.tnic>
	 <20130305215946.GA16796@rhlx01.hs-esslingen.de>
	 <1362541640.2441.3.camel@rzhang1-mobl4> <20130306070057.GA30673@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-06 at 08:00 +0100, Borislav Petkov wrote:
> On Wed, Mar 06, 2013 at 11:47:20AM +0800, Zhang Rui wrote:
> > > So this now does not have any of the Schmitt trigger equivalent (?)
> > > governor changes that were nicely discussed in this activity -
> > > So what do we want to have committed, and what do we not,
> > 
> > the problem should have been fixed in 3.9-rc1 by
> > commit b8bb6cb999858043489c1ddef08eed2127559169
> > Author: Zhang Rui <rui.zhang@intel.com>
> > Date:   Thu Nov 22 15:45:02 2012 +0800
> > 
> >     step_wise: Unify the code for both throttle and dethrottle
> > 
> >     Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > 
> > I'll send Alexander' patch for 3.8 stable.
> 
> Hold on, do I understand it correctly that this is yet another patch
> that "fixes" it?

sorry I should be clearer.
the problem that alexander' patch fixes, does not exist in 3.9-rc1
because the problem is fixed by this commit
b8bb6cb999858043489c1ddef08eed2127559169.

so what we need is, either 3.8.x kernel + alexander's patch, or clean
3.9-rc1.

>  If so, maybe we should test 3.9-rc1 which contains the
> said patch above? Yes, no?
> 
> Also, I don't see Alexander's patch applied anywhere so if it isn't
> upstream, you can't send it to stable.
> 
then I'll back port b8bb6cb999858043489c1ddef08eed2127559169 for 3.8
stable.

thanks,
rui

