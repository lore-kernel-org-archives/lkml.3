Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbaCXUUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:20:48 -0400
Received: from one.firstfloor.org ([193.170.194.197]:42185 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbaCXUUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:20:47 -0400
Date: Mon, 24 Mar 2014 21:20:45 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@ghostprotocols.net,
        peterz@infradead.org, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        eranian@google.com, andi.kleen@intel.com
Subject: Re: [PATCH 4/6] perf, sort:  Add physid sorting based on mmap2 data
Message-ID: <20140324202045.GT22728@two.firstfloor.org>
References: <1395689676-214799-1-git-send-email-dzickus@redhat.com>
 <1395689676-214799-5-git-send-email-dzickus@redhat.com>
 <8761n3pe2w.fsf@tassilo.jf.intel.com>
 <20140324201757.GC25953@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140324201757.GC25953@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 04:17:57PM -0400, Don Zickus wrote:
> On Mon, Mar 24, 2014 at 12:54:31PM -0700, Andi Kleen wrote:
> > Don Zickus <dzickus@redhat.com> writes:
> > 
> > > In order for the c2c tool to work correctly, it needs to properly
> > > sort all the records on uniquely identifiable data addresses.  These
> > > unique addresses are converted from virtual addresses provided by the
> > > hardware into a kernel address using an mmap2 record as the decoder.
> > 
> > No documentation for the new option?
> > 
> > Probably the new mode should be also supported by --sort
> 
> I hid the new option further in the changelog, so it isn't obvious.  Sorry
> about that.

I meant there's no manpage change

-Andi
