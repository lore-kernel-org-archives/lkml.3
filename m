Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbaCXU12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:27:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbaCXU10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:27:26 -0400
Date: Mon, 24 Mar 2014 16:26:27 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@ghostprotocols.net, peterz@infradead.org,
        LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com,
        andi.kleen@intel.com
Subject: Re: [PATCH 4/6] perf, sort:  Add physid sorting based on mmap2 data
Message-ID: <20140324202627.GD25953@redhat.com>
References: <1395689676-214799-1-git-send-email-dzickus@redhat.com>
 <1395689676-214799-5-git-send-email-dzickus@redhat.com>
 <8761n3pe2w.fsf@tassilo.jf.intel.com>
 <20140324201757.GC25953@redhat.com>
 <20140324202045.GT22728@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140324202045.GT22728@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 09:20:45PM +0100, Andi Kleen wrote:
> On Mon, Mar 24, 2014 at 04:17:57PM -0400, Don Zickus wrote:
> > On Mon, Mar 24, 2014 at 12:54:31PM -0700, Andi Kleen wrote:
> > > Don Zickus <dzickus@redhat.com> writes:
> > > 
> > > > In order for the c2c tool to work correctly, it needs to properly
> > > > sort all the records on uniquely identifiable data addresses.  These
> > > > unique addresses are converted from virtual addresses provided by the
> > > > hardware into a kernel address using an mmap2 record as the decoder.
> > > 
> > > No documentation for the new option?
> > > 
> > > Probably the new mode should be also supported by --sort
> > 
> > I hid the new option further in the changelog, so it isn't obvious.  Sorry
> > about that.
> 
> I meant there's no manpage change

Ah, right.  I missed that.  Thanks for noticing.  Let me respin that.

Cheers,
Don
