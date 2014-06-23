Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbaFWHMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:12:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:45945 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaFWHML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:12:11 -0400
Date: Mon, 23 Jun 2014 09:12:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        jmario@redhat.com, dzickus@redhat.com, jolsa@redhat.com,
        acme@redhat.com
Subject: Re: [PATCH 1/2] perf/x86: update Haswell PEBS event constraints
Message-ID: <20140623071208.GH19860@laptop.programming.kicks-ass.net>
References: <1403193509-22393-1-git-send-email-eranian@google.com>
 <1403193509-22393-2-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403193509-22393-2-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 05:58:28PM +0200, Stephane Eranian wrote:
> +	INTEL_EVENT_CONSTRAINT(0xd1, 0xf), /* MEM_LOAD_UOPS_RETIRED.* */
> +	/* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
> +	INTEL_EVENT_CONSTRAINT(0xd2, 0xf),
> +	/* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
> +	INTEL_EVENT_CONSTRAINT(0xd3, 0xf),
>  	INTEL_UEVENT_CONSTRAINT(0x04c8, 0xf), /* HLE_RETIRED.Abort */
>  	INTEL_UEVENT_CONSTRAINT(0x04c9, 0xf), /* RTM_RETIRED.Abort */

Please keep the event and comment on the same line, screw 80 chars, this
interleaves stuff is impossible to read.
