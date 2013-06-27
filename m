Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab3F0OLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 10:11:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58295 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab3F0OLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 10:11:20 -0400
Date: Thu, 27 Jun 2013 16:10:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 2/8] perf,x86: drop event->flags and use
 hw.constraint->flags
Message-ID: <20130627141040.GA29209@dyad.programming.kicks-ass.net>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
 <1371824448-7306-3-git-send-email-eranian@google.com>
 <20130624084510.GK28407@twins.programming.kicks-ass.net>
 <CABPqkBQRchnjhnEC05w-noizoeSRnNio7NDQ6_+vXym_7rkGaw@mail.gmail.com>
 <20130626103653.GC28407@twins.programming.kicks-ass.net>
 <CABPqkBQuYy3TeE81tTXVruMG4D84TQ2U5g69T2ResGgjPjK4Cg@mail.gmail.com>
 <20130627104833.GC27378@dyad.programming.kicks-ass.net>
 <CABPqkBSwrz_GSobSuXn+AvU1zp14nAccCer4o7DHmG2c90cxRA@mail.gmail.com>
 <20130627111445.GR28407@twins.programming.kicks-ass.net>
 <CABPqkBTU5kM_mgxj_3+Li+r=Ofq+xG4_PP2wu94pzeJ4y3m92Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTU5kM_mgxj_3+Li+r=Ofq+xG4_PP2wu94pzeJ4y3m92Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 02:33:58PM +0200, Stephane Eranian wrote:
> Peter,
> 
> Let's drop this patch.
> 
> It does not work anymore with the offcore-response
> scheduling fix. The constraint->flags are shared, so cannot
> use the flags there to store X86_COMMITTED. So we have
> to keep a copy in the event->hw.flags.
> 
> Sorry about the confusion.

n/p I've already forgotten all about it ;-)
