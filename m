Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaIXHte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:49:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:38390 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaIXHtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:49:33 -0400
Date: Wed, 24 Sep 2014 09:49:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        jolsa@redhat.com, acme@redhat.com, cebbert.lkml@gmail.com
Subject: Re: [PATCH v6 0/6] perf: add ability to sample interrupted machine
 state
Message-ID: <20140924074927.GS16043@twins.programming.kicks-ass.net>
References: <1411484269-32311-1-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411484269-32311-1-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 04:57:43PM +0200, Stephane Eranian wrote:
> In V6, we added the missing copy of the eflags from the PEBS
> mahcine state (reported by Andi). We fixed some formatting
> issues. We rebased to 3.17-rc6.

../arch/x86/kernel/cpu/perf_event_intel_ds.c: In function ‘__intel_pmu_pebs_event’:
../arch/x86/kernel/cpu/perf_event_intel_ds.c:899:7: error: ‘struct pt_regs’ has no member named ‘eflags’

You mean that?


