Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbaIKOep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:34:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbaIKOeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:34:44 -0400
Date: Thu, 11 Sep 2014 10:33:52 -0400
From: Dave Jones <davej@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: mm: BUG in unmap_page_range
Message-ID: <20140911143352.GA3008@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Rik van Riel <riel@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Cyrill Gorcunov <gorcunov@gmail.com>
References: <20140908171853.GN17501@suse.de>
 <540DEDE7.4020300@oracle.com>
 <20140909213309.GQ17501@suse.de>
 <540F7D42.1020402@oracle.com>
 <alpine.LSU.2.11.1409091903390.10989@eggly.anvils>
 <20140910124732.GT17501@suse.de>
 <alpine.LSU.2.11.1409101210520.1744@eggly.anvils>
 <54110C62.4030702@oracle.com>
 <alpine.LSU.2.11.1409110356280.2116@eggly.anvils>
 <5411B032.7050205@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5411B032.7050205@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 10:22:42AM -0400, Sasha Levin wrote:

 > > The fixed trinity may be counter-productive for now, since we think
 > > there is an understandable pte_mknuma() bug coming from that direction,
 > > but have not posted a patch for it yet.
 > 
 > I'm still seeing the bug with fixed trinity, it was a matter of adding more flags
 > to mbind.
 
What did I miss ? Anything not in the MPOL_MF_VALID mask should be -EINVAL

	Dave

