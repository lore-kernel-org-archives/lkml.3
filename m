Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab3IZVo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 17:44:56 -0400
Received: from relay3.sgi.com ([192.48.152.1]:52556 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754607Ab3IZVoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 17:44:55 -0400
Date: Thu, 26 Sep 2013 16:44:59 -0500
From: Alex Thorlton <athorlton@sgi.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Dave Jones <davej@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>, Robin Holt <robinmholt@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCHv2 0/9] split page table lock for PMD tables
Message-ID: <20130926214459.GB22939@sgi.com>
References: <1379330740-5602-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20130919171727.GC6802@sgi.com>
 <20130920123137.BE2F7E0090@blue.fi.intel.com>
 <20130924164443.GB2940@sgi.com>
 <20130926105052.0205AE0090@blue.fi.intel.com>
 <20130926211935.GJ2940@sgi.com>
 <20130926213807.1D82AE0090@blue.fi.intel.com>
 <20130926214246.32EDCE0090@blue.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130926214246.32EDCE0090@blue.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 12:42:46AM +0300, Kirill A. Shutemov wrote:
> Kirill A. Shutemov wrote:
> > Alex Thorlton wrote:
> > > > Let me guess: you have HUGETLBFS enabled in your config, right? ;)
> > > > 
> > > > HUGETLBFS hasn't converted to new locking and we disable split pmd lock if
> > > > HUGETLBFS is enabled.
> > > 
> > > Ahhhhh, that's got it!  I double checked my config a million times to
> > > make sure that I wasn't going crazy, but I must've missed that. With
> > > that fixed, it's performing exactly how I thought it should.  Looking
> > > great to me!
> > 
> > Can I use your Reviewed-by?
> 
> s/Reviewed-by/Tested-by/

That too.  Whatever you need, haha.

- Alex
