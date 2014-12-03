Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaLCPwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 10:52:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33390 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaLCPwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 10:52:50 -0500
Date: Wed, 3 Dec 2014 15:52:43 +0000
From: Mel Gorman <mgorman@suse.de>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
        Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 03/10] mm: Convert p[te|md]_numa users to
 p[te|md]_protnone_numa
Message-ID: <20141203155242.GE6043@suse.de>
References: <1416578268-19597-1-git-send-email-mgorman@suse.de>
 <1416578268-19597-4-git-send-email-mgorman@suse.de>
 <1417473762.7182.8.camel@kernel.crashing.org>
 <87k32ah5q3.fsf@linux.vnet.ibm.com>
 <1417551115.27448.7.camel@kernel.crashing.org>
 <87lhmobvuu.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <87lhmobvuu.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 08:53:37PM +0530, Aneesh Kumar K.V wrote:
> Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
> 
> > On Tue, 2014-12-02 at 12:57 +0530, Aneesh Kumar K.V wrote:
> >> Now, hash_preload can possibly insert an hpte in hash page table even if
> >> the access is not allowed by the pte permissions. But i guess even that
> >> is ok. because we will fault again, end-up calling hash_page_mm where we
> >> handle that part correctly.
> >
> > I think we need a test case...
> >
> 
> I ran the subpageprot test that Paul had written. I modified it to ran
> with selftest. 
> 

It's implied but can I assume it passed? If so, Ben and Paul, can I
consider the series to be acked by you other than the minor comment
updates?

Thanks.

-- 
Mel Gorman
SUSE Labs
