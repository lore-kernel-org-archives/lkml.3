Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbaJWLaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:30:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:36208 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbaJWLaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:30:04 -0400
Date: Thu, 23 Oct 2014 13:30:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Joe Mario <jmario@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        eranian@google.com, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com, rfowles@redhat.com
Subject: Re: perf:  Translating mmap2 ids into socket info?
Message-ID: <20141023113001.GA12706@worktop.programming.kicks-ass.net>
References: <20141022162026.GG135937@redhat.com>
 <20141022164510.GJ21513@worktop.programming.kicks-ass.net>
 <5447F2DF.3000506@redhat.com>
 <20141022200219.GM21513@worktop.programming.kicks-ass.net>
 <20141022203834.GL135937@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022203834.GL135937@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 04:38:34PM -0400, Don Zickus wrote:
> Ha!  I have been telling myself for a year I would try to learn more about
> those offcore/uncore counters.  Is there documentation for how to access
> the uncore stuff?  Do I have to long hand it with 'perf record -e
> uncore_qpi_1/<stuff>/ foo'?

For uncore there is some in the SDM and there are these documents; there
might be more but who knows.

http://www.intel.com/Assets/PDF/designguide/323535.pdf 
http://www.intel.com/content/dam/www/public/us/en/documents/design-guides/xeon-e5-2600-uncore-guide.pdf 

