Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbaBKRKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:10:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbaBKRKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:10:39 -0500
Date: Tue, 11 Feb 2014 17:10:35 +0000
From: Mel Gorman <mgorman@suse.de>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: David Rientjes <rientjes@google.com>,
        Luiz Capitulino <lcapitulino@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 0/4] hugetlb: add hugepagesnid= command-line option
Message-ID: <20140211171035.GN6732@suse.de>
References: <1392053268-29239-1-git-send-email-lcapitulino@redhat.com>
 <alpine.DEB.2.02.1402101851190.3447@chino.kir.corp.google.com>
 <20140211092514.GH6732@suse.de>
 <20140211152629.GA28210@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140211152629.GA28210@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 01:26:29PM -0200, Marcelo Tosatti wrote:
> > Or take a stab at allocating 1G pages at runtime. It would require
> > finding properly aligned 1Gs worth of contiguous MAX_ORDER_NR_PAGES at
> > runtime. I would expect it would only work very early in the lifetime of
> > the system but if the user is willing to use kernel parameters to
> > allocate them then it should not be an issue.
> 
> Can be an improvement on top of the current patchset? Certain use-cases
> require allocation guarantees (even if that requires kernel parameters).
> 

Sure, they're not mutually exclusive. It would just avoid the need to
create a new kernel parameter and use the existing interfaces.

-- 
Mel Gorman
SUSE Labs
