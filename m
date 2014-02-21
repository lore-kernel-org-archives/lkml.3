Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbaBUWzM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 17:55:12 -0500
Received: from one.firstfloor.org ([193.170.194.197]:40470 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943AbaBUWzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 17:55:10 -0500
Date: Fri, 21 Feb 2014 23:55:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Rik van Riel <riel@redhat.com>, davidlohr@hp.com,
        isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] hugetlb: add hugepages_node= command-line option
Message-ID: <20140221225508.GH22728@two.firstfloor.org>
References: <20140220022254.GA25898@amt.cnet>
 <alpine.DEB.2.02.1402191941330.29913@chino.kir.corp.google.com>
 <20140220213407.GA11048@amt.cnet>
 <alpine.DEB.2.02.1402201502580.30647@chino.kir.corp.google.com>
 <20140221022800.GA30230@amt.cnet>
 <alpine.DEB.2.02.1402210158400.17851@chino.kir.corp.google.com>
 <20140221191055.GD19955@amt.cnet>
 <alpine.DEB.2.02.1402211358030.4682@chino.kir.corp.google.com>
 <20140221223616.GG22728@two.firstfloor.org>
 <alpine.DEB.2.02.1402211440120.20113@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402211440120.20113@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But, like I said, I'm not sure we'd ever be able to totally remove it 
> because of backwards compatibility, but the point is that nobody would 
> have to use it anymore as a hack for 1GB.

Again it's a perfectly fine and widely used interface. Any talk of removing
it is wrong.

-Andi
