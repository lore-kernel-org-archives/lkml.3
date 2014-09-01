Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbaIARRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 13:17:19 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:20819 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751195AbaIARRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 13:17:17 -0400
Message-ID: <1409591843.4343.65.camel@hornet>
Subject: Re: [PATCH v4 00/22] perf: Add infrastructure and support for Intel
 PT
From: Pawel Moll <pawel.moll@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        "kan.liang@intel.com" <kan.liang@intel.com>,
        Michael Williams <Michael.Williams@arm.com>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Date: Mon, 01 Sep 2014 18:17:23 +0100
In-Reply-To: <20140901163039.GV27892@worktop.ger.corp.intel.com>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
	 <20140901163039.GV27892@worktop.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-01 at 17:30 +0100, Peter Zijlstra wrote:
> On Wed, Aug 20, 2014 at 03:35:57PM +0300, Alexander Shishkin wrote:
> > This patchset adds support for Intel Processor Trace (PT) extension [1] of
> > Intel Architecture that allows the capture of information about software
> > execution flow, to the perf kernel infrastructure.

I'm particularly excited about the "to the perf kernel
infrastructure" :-)

> It would also be good if some other archs can comment on this (the
> generic parts obviously). There is the ARM CoreSight stuff 

We've got Mathieu Poirier at Linaro working on the drivers for CoreSight
components, with the latest (v5) version here:

http://thread.gmane.org/gmane.linux.ports.arm.kernel/351654

but it was mostly intended to have the processor trace decoded using a
separate tool in userspace. I must say that an idea of getting it all
into perf sounds really interesting.

I've copied Mathieu so he can have a look as well. As for me personally,
I'd like to have 48 hours to digest it all. I've just got back from a
very distant time zone and am suffering a monumental jet lag... 

Paweł

