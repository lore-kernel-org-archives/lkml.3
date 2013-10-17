Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab3JQPLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 11:11:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55964 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab3JQPLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 11:11:33 -0400
Date: Thu, 17 Oct 2013 17:11:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: dave.hansen@linux.intel.com, eranian@google.com, ak@linux.intel.com,
        jmario@redhat.com, linux-kernel@vger.kernel.org, acme@infradead.org,
        mingo@kernel.org
Subject: Re: [PATCH] perf, x86: Optimize intel_pmu_pebs_fixup_ip()
Message-ID: <20131017151121.GD26785@twins.programming.kicks-ass.net>
References: <20131015101404.GD10651@twins.programming.kicks-ass.net>
 <20131015130226.GX26785@twins.programming.kicks-ass.net>
 <20131015143227.GY26785@twins.programming.kicks-ass.net>
 <20131015150736.GZ26785@twins.programming.kicks-ass.net>
 <20131015154104.GA227855@redhat.com>
 <20131016105755.GX10651@twins.programming.kicks-ass.net>
 <20131017144913.GM227855@redhat.com>
 <20131017145131.GP10651@twins.programming.kicks-ass.net>
 <20131017150358.GN227855@redhat.com>
 <20131017150944.GQ10651@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017150944.GQ10651@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 05:09:44PM +0200, Peter Zijlstra wrote:
> The patches you find in:
> 
> http://programming.kicks-ass.net/sekrit/patches.tar.bz2

# sha256sum patches.tar.bz2 
28e26d4a20004eee231a4c0c6067508a322241046b400a226af1cceed8854bfb  patches.tar.bz2

