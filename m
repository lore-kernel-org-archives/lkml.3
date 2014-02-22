Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbaBVEb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 23:31:29 -0500
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:49807 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaBVEb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 23:31:28 -0500
Message-ID: <1393043471.2473.0.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 4/4] hugetlb: add hugepages_node= command-line option
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Luiz Capitulino <lcapitulino@redhat.com>, mtosatti@redhat.com,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Rik van Riel <riel@redhat.com>, isimatu.yasuaki@jp.fujitsu.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Fri, 21 Feb 2014 20:31:11 -0800
In-Reply-To: <20140222040350.GI22728@two.firstfloor.org>
References: <1392339728-13487-1-git-send-email-lcapitulino@redhat.com>
	 <1392339728-13487-5-git-send-email-lcapitulino@redhat.com>
	 <alpine.DEB.2.02.1402141511200.13935@chino.kir.corp.google.com>
	 <20140214225810.57e854cb@redhat.com>
	 <alpine.DEB.2.02.1402150159540.28883@chino.kir.corp.google.com>
	 <1392702456.2468.4.camel@buesod1.americas.hpqcorp.net>
	 <20140221155423.6c6689e27fa10ed394f01843@linux-foundation.org>
	 <20140222040350.GI22728@two.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-02-22 at 05:03 +0100, Andi Kleen wrote:
> > But I think it would be better if it made hugepages= and hugepagesz=
> > obsolete, so we can emit a printk if people use those, telling them
> > to migrate because the old options are going away.
> 
> Not sure why everyone wants to break existing systems. These options
> have existed for many years, you cannot not just remove them.
> 
> Also the old options are totally fine and work adequately for the
> vast majority of users who do not need to control node assignment
> fine grained.

Yes, please, why can't both options just coexist.

