Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbaBVEDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 23:03:53 -0500
Received: from one.firstfloor.org ([193.170.194.197]:40872 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaBVEDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 23:03:52 -0500
Date: Sat, 22 Feb 2014 05:03:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, David Rientjes <rientjes@google.com>,
        Luiz Capitulino <lcapitulino@redhat.com>, mtosatti@redhat.com,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] hugetlb: add hugepages_node= command-line option
Message-ID: <20140222040350.GI22728@two.firstfloor.org>
References: <1392339728-13487-1-git-send-email-lcapitulino@redhat.com>
 <1392339728-13487-5-git-send-email-lcapitulino@redhat.com>
 <alpine.DEB.2.02.1402141511200.13935@chino.kir.corp.google.com>
 <20140214225810.57e854cb@redhat.com>
 <alpine.DEB.2.02.1402150159540.28883@chino.kir.corp.google.com>
 <1392702456.2468.4.camel@buesod1.americas.hpqcorp.net>
 <20140221155423.6c6689e27fa10ed394f01843@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140221155423.6c6689e27fa10ed394f01843@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But I think it would be better if it made hugepages= and hugepagesz=
> obsolete, so we can emit a printk if people use those, telling them
> to migrate because the old options are going away.

Not sure why everyone wants to break existing systems. These options
have existed for many years, you cannot not just remove them.

Also the old options are totally fine and work adequately for the
vast majority of users who do not need to control node assignment
fine grained.

-Andi
