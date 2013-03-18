Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794Ab3CRALI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 20:11:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:22795 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932587Ab3CRALG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 20:11:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,861,1355126400"; 
   d="scan'208";a="304220183"
Date: Mon, 18 Mar 2013 01:11:02 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: New MFD tree for linux-next
Message-ID: <20130318001102.GC4809@zurbaran>
References: <20130314000201.GA4425@zurbaran>
 <20130315164625.GA29531@zurbaran>
 <20130316132753.591db4c078d06db297ba46a8@canb.auug.org.au>
 <20130317233907.GB4809@zurbaran>
 <20130318104520.06b6a22c577be324880a4d06@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130318104520.06b6a22c577be324880a4d06@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 10:45:20AM +1100, Stephen Rothwell wrote:
> On Mon, 18 Mar 2013 00:39:07 +0100 Samuel Ortiz <sameo@linux.intel.com> wrote:
> >
> > > I assume that you are still using the for-next branch?
> > I will update for-next branch to be in sync with mfd-next until the 3.10 merge
> > window closes. After that I'll probably delete the mfd-2.6.git tree.
> 
> I meant "I assume that I should still fetch the for-next branch
> of ...sameo/mfd-next.git".  If that has changed, please let me know.
Sorry for the misunderstanding, I was not clear enough: mfd-next master is
replacing mfd-2.6 for-next and mfd-fixes master is replacing mfd-2.6 for-linus.
So no need to pull mfd-next for-next.

I deleted all branches but master from both mfd-next and mfd-fixes, so things
should be clearer now.

 
> > > What branch should I use of that?
> > Ah, I didn't see that the remote tree still carries the mfd-2.6 branches, I'll
> > remove them.
> > Please use master.
> 
> OK.  I will do that from tomorrow.
Thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
