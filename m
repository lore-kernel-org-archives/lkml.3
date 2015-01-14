Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbbANOih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:38:37 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:54183 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbbANOig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:38:36 -0500
Date: Wed, 14 Jan 2015 15:38:24 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com,
        markus.t.metzger@intel.com, mathieu.poirier@linaro.org,
        Kaixu Xia <kaixu.xia@linaro.org>, acme@infradead.org
Subject: Re: [PATCH v9 00/14] perf: Add infrastructure and support for Intel
 PT
Message-ID: <20150114143824.GG22386@worktop.programming.kicks-ass.net>
References: <1421237903-181015-1-git-send-email-alexander.shishkin@linux.intel.com>
 <87h9vtmt1u.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h9vtmt1u.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 02:43:25PM +0200, Alexander Shishkin wrote:
> Alexander Shishkin <alexander.shishkin@linux.intel.com> writes:
> 
> >   * added a comment for the ITRACE_START record.
> 
> ...and I messed it up so the last change didn't make it,
> apologies. Should I resend the whole series as v10, for consistency?

Nah, just the one patch affected would do.

Thanks!
