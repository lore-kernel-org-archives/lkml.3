Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbaBUDgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 22:36:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbaBUDgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 22:36:16 -0500
Date: Thu, 20 Feb 2014 22:35:51 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        davidlohr@hp.com, isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] hugetlb: add hugepages_node= command-line option
Message-ID: <20140220223551.4a9644ba@redhat.com>
In-Reply-To: <alpine.DEB.2.02.1402201502580.30647@chino.kir.corp.google.com>
References: <1392339728-13487-5-git-send-email-lcapitulino@redhat.com>
	<alpine.DEB.2.02.1402141511200.13935@chino.kir.corp.google.com>
	<20140214225810.57e854cb@redhat.com>
	<alpine.DEB.2.02.1402150159540.28883@chino.kir.corp.google.com>
	<20140217085622.39b39cac@redhat.com>
	<alpine.DEB.2.02.1402171518080.25724@chino.kir.corp.google.com>
	<20140218123013.GA20609@amt.cnet>
	<alpine.DEB.2.02.1402181407510.20772@chino.kir.corp.google.com>
	<20140220022254.GA25898@amt.cnet>
	<alpine.DEB.2.02.1402191941330.29913@chino.kir.corp.google.com>
	<20140220213407.GA11048@amt.cnet>
	<alpine.DEB.2.02.1402201502580.30647@chino.kir.corp.google.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014 15:15:46 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> Do I really need to do your work for you and work on 1GB hugepages at 
> runtime, which many more people would be interested in?  Or are we just 
> seeking the easiest way out here with something that shuts the customer up 
> and leaves a kernel command line option that we'll need to maintain to 
> avoid breaking backwards compatibility in the future?

We're seeking a pragmatic solution.

I've said many times in this thread that we're also interested on being
able to allocate 1GB at runtime and would work on it on top of the
command-line option, which is ready, works and solves a real world problem.
