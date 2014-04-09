Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945AbaDIPTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:19:19 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40569 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933420AbaDIPTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:19:14 -0400
Date: Wed, 9 Apr 2014 11:18:27 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Mel Gorman <mgorman@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Steven Noonan <steven@uplinklabs.net>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        Linux-X86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH 2/3] x86: Define _PAGE_NUMA with unused physical address
 bits PMD and PTE levels
Message-ID: <20140409151827.GA6445@phenom.dumpdata.com>
References: <20140407161910.GJ1444@moon>
 <20140407182854.GH7292@suse.de>
 <5342FC0E.9080701@zytor.com>
 <20140407193646.GC23983@moon>
 <5342FFB0.6010501@zytor.com>
 <20140407212535.GJ7292@suse.de>
 <CAKbGBLhsWKVYnBqR0ZJ2kfaF_h=XAYkjq=v3RLoRBDkF_w=6ag@mail.gmail.com>
 <e9801da2-3aa4-4c23-9a64-90c890b9ebbc@email.android.com>
 <20140408160250.GE31554@phenom.dumpdata.com>
 <20140408165123.GN7292@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140408165123.GN7292@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 05:51:23PM +0100, Mel Gorman wrote:
> On Tue, Apr 08, 2014 at 12:02:50PM -0400, Konrad Rzeszutek Wilk wrote:
> > .snip..
> > > >>> David Vrabel has a patchset which I presumed would be pulled through
> > > >the
> > > >>> Xen tree this merge window:
> > > >>>
> > > >>> [PATCHv5 0/8] x86/xen: fixes for mapping high MMIO regions (and
> > > >remove
> > > >>> _PAGE_IOMAP)
> > > >>>
> > > >>> That frees up this bit.
> > > >>>
> > > >>
> > > >> Thanks, I was not aware of that patch.  Based on it, I intend to
> > > >force
> > > >> automatic NUMA balancing to depend on !XEN and see what the reaction
> > > >is. If
> > > >> support for Xen is really required then it potentially be re-enabled
> > > >if/when
> > > >> that series is merged assuming they do not need the bit for something
> > > >else.
> > > >>
> > > >
> > > >Amazon EC2 does have large memory instance types with NUMA exposed to
> > > >the guest (e.g. c3.8xlarge, i2.8xlarge, etc), so it'd be preferable
> > > >(to me anyway) if we didn't require !XEN.
> > 
> > What about the patch that David Vrabel posted:
> > 
> > http://osdir.com/ml/general/2014-03/msg41979.html
> > 
> > Has anybody taken it for a spin?
> 
> Alternatively "[PATCH 4/5] mm: use paravirt friendly ops for NUMA
> hinting ptes" which modifies the NUMA pte helpers instead of the main
> set/clear ones.

Ah nice! Looking forward to it being posted as non-RFC and could you also
please CC 'xen-devel@lists.xenproject.org' on it?

Thank you!
