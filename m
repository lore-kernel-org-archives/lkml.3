Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbbA2P26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:28:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:55855 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbbA2P25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:28:57 -0500
Date: Thu, 29 Jan 2015 16:28:52 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com,
        markus.t.metzger@intel.com, mathieu.poirier@linaro.org,
        Kaixu Xia <kaixu.xia@linaro.org>, acme@infradead.org
Subject: Re: [PATCH v9 12/14] x86: perf: intel_pt: Intel PT PMU driver
Message-ID: <20150129152852.GD24151@twins.programming.kicks-ass.net>
References: <1421237903-181015-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1421237903-181015-13-git-send-email-alexander.shishkin@linux.intel.com>
 <20150115090659.GQ23965@worktop.programming.kicks-ass.net>
 <87egqwmdhe.fsf@ashishki-desk.ger.corp.intel.com>
 <87twzllhbz.fsf@ashishki-desk.ger.corp.intel.com>
 <20150126165536.GA23038@twins.programming.kicks-ass.net>
 <87zj9485j0.fsf@ashishki-desk.ger.corp.intel.com>
 <20150129115918.GA26304@twins.programming.kicks-ass.net>
 <CAB7JpEFo=gmx9mFxDi06fueunFrpqgsKtg4_eC-PuUeuCHre1g@mail.gmail.com>
 <20150129152022.GC26304@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150129152022.GC26304@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2015 at 04:20:22PM +0100, Peter Zijlstra wrote:
> event->ctx is never NULL,

With the one exception of partially initialized events, that is.
