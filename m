Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162325Ab3LFNS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:18:28 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:41177 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955Ab3LFNSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:18:25 -0500
Date: Fri, 6 Dec 2013 10:18:17 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, mikey@neuling.org,
        ak@linux.intel.com, eranian@google.com, sukadev@linux.vnet.ibm.com,
        mingo@kernel.org, Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [PATCH V4 00/10] perf: New conditional branch filter
Message-ID: <20131206131817.GB2279@ghostprotocols.net>
References: <1386153162-11225-1-git-send-email-khandual@linux.vnet.ibm.com>
 <1386218874.6009.7.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386218874.6009.7.camel@concordia>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 05, 2013 at 03:47:54PM +1100, Michael Ellerman escreveu:
> On Wed, 2013-12-04 at 16:02 +0530, Anshuman Khandual wrote:
> > 		This patchset is the re-spin of the original branch stack sampling
> > patchset which introduced new PERF_SAMPLE_BRANCH_COND branch filter. This patchset
> > also enables SW based branch filtering support for book3s powerpc platforms which
> > have PMU HW backed branch stack sampling support. 
> > 
> > Summary of code changes in this patchset:
> > 
> > (1) Introduces a new PERF_SAMPLE_BRANCH_COND branch filter
> > (2) Add the "cond" branch filter options in the "perf record" tool
> > (3) Enable PERF_SAMPLE_BRANCH_COND in X86 platforms
> > (4) Enable PERF_SAMPLE_BRANCH_COND in POWER8 platform 
> > (5) Update the documentation regarding "perf record" tool
> 
> 
> Hi Arnaldo,
> 
> Can you please take just patches 1-5 into the perf tree? And do you mind
> putting them in a topic branch so Benh can merge that.

This is mostly kernel code, I process the userspace ones, so I think either
Ingo or PeterZ should pick these, Ingo, Peter?

Only:

Subject: [PATCH V4 03/10] perf, tool: Conditional branch filter 'cond' added to perf record

Which is a one liner, touches tools/perf/, and I'm ok with it.


- Arnaldo
 
> The remaining patches are powerpc specific and still need some more review.
> 
> cheers
> 
