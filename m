Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760129Ab3LIAls (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 19:41:48 -0500
Received: from ozlabs.org ([203.10.76.45]:40569 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760070Ab3LIAlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 19:41:47 -0500
Message-ID: <1386549703.4477.8.camel@concordia>
Subject: Re: [PATCH V4 00/10] perf: New conditional branch filter
From: Michael Ellerman <mpe@ellerman.id.au>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, peterz@infradead.org,
        mingo@kernel.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, mikey@neuling.org,
        ak@linux.intel.com, eranian@google.com, sukadev@linux.vnet.ibm.com,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Date: Mon, 09 Dec 2013 11:41:43 +1100
In-Reply-To: <20131206131817.GB2279@ghostprotocols.net>
References: <1386153162-11225-1-git-send-email-khandual@linux.vnet.ibm.com>
	 <1386218874.6009.7.camel@concordia>
	 <20131206131817.GB2279@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-06 at 10:18 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Dec 05, 2013 at 03:47:54PM +1100, Michael Ellerman escreveu:
> > On Wed, 2013-12-04 at 16:02 +0530, Anshuman Khandual wrote:
> > > 		This patchset is the re-spin of the original branch stack sampling
> > > patchset which introduced new PERF_SAMPLE_BRANCH_COND branch filter. This patchset
> > > also enables SW based branch filtering support for book3s powerpc platforms which
> > > have PMU HW backed branch stack sampling support. 
> > > 
> > > Summary of code changes in this patchset:
> > > 
> > > (1) Introduces a new PERF_SAMPLE_BRANCH_COND branch filter
> > > (2) Add the "cond" branch filter options in the "perf record" tool
> > > (3) Enable PERF_SAMPLE_BRANCH_COND in X86 platforms
> > > (4) Enable PERF_SAMPLE_BRANCH_COND in POWER8 platform 
> > > (5) Update the documentation regarding "perf record" tool
> > 
> > 
> > Hi Arnaldo,
> > 
> > Can you please take just patches 1-5 into the perf tree? And do you mind
> > putting them in a topic branch so Benh can merge that.
> 
> This is mostly kernel code, I process the userspace ones, so I think either
> Ingo or PeterZ should pick these, Ingo, Peter?

Urgh, sorry. MAINTAINERS just lists all of you in a block.

Added PeterZ to CC.

Peter/Ingo can you please take just patches 1-5 into the perf tree? And
do you mind putting them in a topic branch so Benh can merge that.

The generic & x86 changes have a Reviewed-by from Stephane, and the change to
tools/perf has an ack-of-sorts from Arnaldo:

> Only:
> 
> Subject: [PATCH V4 03/10] perf, tool: Conditional branch filter 'cond' added to perf record
> 
> Which is a one liner, touches tools/perf/, and I'm ok with it.


cheers


