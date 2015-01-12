Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbbALRLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:11:30 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:60320 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbbALRL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:11:28 -0500
Date: Mon, 12 Jan 2015 17:40:40 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com,
        markus.t.metzger@intel.com, mathieu.poirier@linaro.org,
        acme@infradead.org
Subject: Re: [PATCH v8 12/14] x86: perf: intel_pt: Intel PT PMU driver
Message-ID: <20150112164040.GG25256@twins.programming.kicks-ass.net>
References: <1415972627-37514-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1415972627-37514-13-git-send-email-alexander.shishkin@linux.intel.com>
 <20150109140947.GN3337@twins.programming.kicks-ass.net>
 <87sifg9cq7.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sifg9cq7.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 06:37:36PM +0200, Alexander Shishkin wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > Also, if its already enabled, should we not return ENODEV as well, no
> > saying who or what programmed it, we should not be touching it.
> 
> Or EBUSY?

Sure, same end result I imagine, driver doesn't load.
