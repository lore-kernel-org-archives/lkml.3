Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab3IZCXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:23:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:11031 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab3IZCXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:23:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,982,1371106800"; 
   d="scan'208";a="401180618"
Date: Thu, 26 Sep 2013 10:23:10 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Bob Liu <lliubbo@gmail.com>
Cc: Bob Liu <bob.liu@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [munlock] BUG: Bad page map in process killall5 pte:cf17e720
 pmd:05a22067
Message-ID: <20130926022310.GA12047@localhost>
References: <20130926004028.GB9394@localhost>
 <52439258.3010904@oracle.com>
 <20130926015924.GA10453@localhost>
 <CAA_GA1frX9rCc8i=8nJFLu+BTPjTP6ZkEvGdMph4TXqH0_yaDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA_GA1frX9rCc8i=8nJFLu+BTPjTP6ZkEvGdMph4TXqH0_yaDg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 10:17:59AM +0800, Bob Liu wrote:
> On Thu, Sep 26, 2013 at 9:59 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > Hi Bob,
> >
> > On Thu, Sep 26, 2013 at 09:48:08AM +0800, Bob Liu wrote:
> >> Hi Fengguang,
> >>
> >> Would you please have a try with the attached patch?
> >> It added a small fix based on Vlastimil's patch.
> >
> > Thanks for the quick response! I just noticed Andrew added this patch
> > to -mm tree:
> >
> > ------------------------------------------------------
> > From: Vlastimil Babka <vbabka@suse.cz>
> > Subject: mm/mlock.c: prevent walking off the end of a pagetable in no-pmd configuration
> >
> > What's the git tree your v2 patch based on? If you already had a git
> 
> It's based on v3.12-rc1.  Should I send you a new one based on latest mmotm?

Not necessary for now. However it'd be good to know whether Vlastimil
has reviewed your v2 fix.

Thanks,
Fengguang
