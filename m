Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934431AbaFSU41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:56:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:7227 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343AbaFSU40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:56:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,508,1400050800"; 
   d="scan'208";a="447688939"
Date: Thu, 19 Jun 2014 13:56:24 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        jmario@redhat.com, dzickus@redhat.com, jolsa@redhat.com,
        acme@redhat.com
Subject: Re: [PATCH 2/2] perf/x86: fix constraints for load latency and
 precise events
Message-ID: <20140619205624.GZ8178@tassilo.jf.intel.com>
References: <1403193509-22393-1-git-send-email-eranian@google.com>
 <1403193509-22393-3-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403193509-22393-3-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 05:58:29PM +0200, Stephane Eranian wrote:
> The load latency does not have to be constrained to counter 3
> on any of SNB, IVB, HSW. It operates fine on any PEBS-capable
> counter.
> 
> The precise store event for SNB, IVB needs to be on counter 3.
> But on Haswell, precise store is implemented differently and
> the constraint is not needed anymore, so we remove it.

Looks good to me.

-Andi
