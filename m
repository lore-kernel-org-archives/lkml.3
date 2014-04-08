Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbaDHQrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 12:47:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756894AbaDHQrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 12:47:48 -0400
Date: Tue, 8 Apr 2014 17:47:44 +0100
From: Mel Gorman <mgorman@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Steven Noonan <steven@uplinklabs.net>,
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
Message-ID: <20140408164744.GM7292@suse.de>
References: <20140407161910.GJ1444@moon>
 <20140407182854.GH7292@suse.de>
 <5342FC0E.9080701@zytor.com>
 <20140407193646.GC23983@moon>
 <5342FFB0.6010501@zytor.com>
 <20140407212535.GJ7292@suse.de>
 <CAKbGBLhsWKVYnBqR0ZJ2kfaF_h=XAYkjq=v3RLoRBDkF_w=6ag@mail.gmail.com>
 <e9801da2-3aa4-4c23-9a64-90c890b9ebbc@email.android.com>
 <20140408160250.GE31554@phenom.dumpdata.com>
 <534420F1.3030301@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <534420F1.3030301@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 09:16:49AM -0700, H. Peter Anvin wrote:
> On 04/08/2014 09:02 AM, Konrad Rzeszutek Wilk wrote:
> >>>
> >>> Amazon EC2 does have large memory instance types with NUMA exposed to
> >>> the guest (e.g. c3.8xlarge, i2.8xlarge, etc), so it'd be preferable
> >>> (to me anyway) if we didn't require !XEN.
> > 
> > What about the patch that David Vrabel posted:
> > 
> > http://osdir.com/ml/general/2014-03/msg41979.html
> > 
> > Has anybody taken it for a spin?
> > 
> 
> Oh lovely, more pvops in low level paths.  I'm so thrilled.
> 
> Incidentally, I wasn't even Cc:'d on that patch and was only added to
> the thread by Linus, but never saw the early bits of the thread
> including the actual patch.
> 

I posted an alternative to that patch that confines the damage to the
NUMA pte helpers.

-- 
Mel Gorman
SUSE Labs
