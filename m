Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbaBKVb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:31:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbaBKVb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:31:27 -0500
Date: Tue, 11 Feb 2014 16:31:08 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mtosatti@redhat.com, mgorman@suse.de,
        aarcange@redhat.com, riel@redhat.com
Subject: Re: [PATCH 0/4] hugetlb: add hugepagesnid= command-line option
Message-ID: <20140211163108.3136d55a@redhat.com>
In-Reply-To: <20140211211732.GS11821@two.firstfloor.org>
References: <1392053268-29239-1-git-send-email-lcapitulino@redhat.com>
	<20140211211732.GS11821@two.firstfloor.org>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014 22:17:32 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> On Mon, Feb 10, 2014 at 12:27:44PM -0500, Luiz Capitulino wrote:
> > HugeTLB command-line option hugepages= allows the user to specify how many
> > huge pages should be allocated at boot. On NUMA systems, this argument
> > automatically distributes huge pages allocation among nodes, which can
> > be undesirable.
> > 
> > The hugepagesnid= option introduced by this commit allows the user
> > to specify which NUMA nodes should be used to allocate boot-time HugeTLB
> > pages. For example, hugepagesnid=0,2,2G will allocate two 2G huge pages
> > from node 0 only. More details on patch 3/4 and patch 4/4.
> 
> The syntax seems very confusing. Can you make that more obvious?

I guess that my bad description in this email may have contributed to make
it look confusing.

The real syntax is hugepagesnid=nid,nr-pages,size. Which looks straightforward
to me. I honestly can't think of anything better than that, but I'm open for
suggestions.
