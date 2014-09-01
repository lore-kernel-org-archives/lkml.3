Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbaIAQVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 12:21:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:57918 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbaIAQVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 12:21:45 -0400
Date: Mon, 1 Sep 2014 18:21:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v4 00/22] perf: Add infrastructure and support for Intel
 PT
Message-ID: <20140901162143.GU27892@worktop.ger.corp.intel.com>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
 <53FAD5E3.1060600@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FAD5E3.1060600@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 09:21:23AM +0300, Adrian Hunter wrote:
> On 08/20/2014 03:35 PM, Alexander Shishkin wrote:
> > This patchset adds support for Intel Processor Trace (PT) extension [1] of
> > Intel Architecture that allows the capture of information about software
> > execution flow, to the perf kernel infrastructure.
> > 
> 
> Alex is away, so I would like to know if anyone (Peter?) plans to review or
> comment on these patches.

I'll get to it (eventually), I had a week of down-time after KS/Linuxcon
and have now returned to a copiously overflown inbox.
