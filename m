Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbaE2C5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 22:57:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:11096 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755447AbaE2C5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 22:57:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,932,1392192000"; 
   d="scan'208";a="438356473"
Date: Wed, 28 May 2014 19:56:55 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [RFC] perf/x86: PMU IRQ handler issues
Message-ID: <20140529025655.GA8876@tassilo.jf.intel.com>
References: <CABPqkBTsiwicZNuU5BW6FZfB4aC=T=w9vFoxLqBTV3-PS4BnoA@mail.gmail.com>
 <53864517.3040503@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53864517.3040503@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> actual numbers describing the issues that you're seeing, including the
> ftrace that Andi was asking for?  There are also some handy tracepoints
> for NMI lengths that I stuck in.

Another good thing would be to plot the periods (from perf report -D)

-Andi
