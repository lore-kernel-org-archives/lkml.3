Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbaJBTIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:08:23 -0400
Received: from mta-out1.inet.fi ([62.71.2.197]:47304 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbaJBTIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:08:20 -0400
Date: Thu, 2 Oct 2014 22:07:34 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Mel Gorman <mgorman@suse.de>,
        Dave Jones <davej@redhat.com>, Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        Kirill A Shutemov <kirill.shutemov@linux.intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] mm: numa: Do not mark PTEs pte_numa when splitting
 huge pages
Message-ID: <20141002190734.GA15671@node.dhcp.inet.fi>
References: <1412256558-9995-1-git-send-email-mgorman@suse.de>
 <1412256558-9995-5-git-send-email-mgorman@suse.de>
 <CA+55aFzJtoEXEzoyYQ=j+AMxyZNL3Gr3bhXPr3twyuGzvES1PA@mail.gmail.com>
 <542DA038.9000908@oracle.com>
 <CA+55aFwybOYtuOn43idiikVDPfBO7pWb4vLjhcM0dYUxTx7odA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwybOYtuOn43idiikVDPfBO7pWb4vLjhcM0dYUxTx7odA@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 12:03:58PM -0700, Linus Torvalds wrote:
> On Thu, Oct 2, 2014 at 11:58 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
> >
> > You've also mentioned that while I can tell you if nothing dies, I can't
> > really tell you if everything is working well. Is there a reasonable way
> > to easily say if NUMA is working properly? Even something that would just
> > tell me "your NUMA balancing seems to be sane" would be good.
> 
> So not having a NUMA machine (and not really wanting one), I can't
> really test things like the migration even *working*.

I believe Sasha uses fakenuma in his KVM for that.

-- 
 Kirill A. Shutemov
