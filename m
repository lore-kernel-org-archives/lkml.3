Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbaBVEjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 23:39:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaBVEjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 23:39:09 -0500
Date: Fri, 21 Feb 2014 20:40:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, David Rientjes <rientjes@google.com>,
        Luiz Capitulino <lcapitulino@redhat.com>, mtosatti@redhat.com,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Rik van Riel <riel@redhat.com>, isimatu.yasuaki@jp.fujitsu.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] hugetlb: add hugepages_node= command-line option
Message-Id: <20140221204047.498041fb.akpm@linux-foundation.org>
In-Reply-To: <20140222040350.GI22728@two.firstfloor.org>
References: <1392339728-13487-1-git-send-email-lcapitulino@redhat.com>
	<1392339728-13487-5-git-send-email-lcapitulino@redhat.com>
	<alpine.DEB.2.02.1402141511200.13935@chino.kir.corp.google.com>
	<20140214225810.57e854cb@redhat.com>
	<alpine.DEB.2.02.1402150159540.28883@chino.kir.corp.google.com>
	<1392702456.2468.4.camel@buesod1.americas.hpqcorp.net>
	<20140221155423.6c6689e27fa10ed394f01843@linux-foundation.org>
	<20140222040350.GI22728@two.firstfloor.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Feb 2014 05:03:50 +0100 Andi Kleen <andi@firstfloor.org> wrote:

> > But I think it would be better if it made hugepages= and hugepagesz=
> > obsolete, so we can emit a printk if people use those, telling them
> > to migrate because the old options are going away.
> 
> Not sure why everyone wants to break existing systems. These options
> have existed for many years, you cannot not just remove them.

Because we care about the quality of kernel interfaces and
implementation.  Five years?  We'll still be around then.

> Also the old options are totally fine and work adequately for the
> vast majority of users who do not need to control node assignment
> fine grained.

It will be old, unneeded cruft.  Don't accumulate cruft.  If we
possibly can remove the old stuff, we should.  It's what we do.  Maybe
in five years we'll find we can't remove them.  We'll see.  At least we
tried.

Hopefully by then none of these interfaces will be in use anyway.
