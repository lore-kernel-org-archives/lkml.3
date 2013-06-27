Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab3F0KtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 06:49:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53792 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab3F0KtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 06:49:07 -0400
Date: Thu, 27 Jun 2013 12:48:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 2/8] perf,x86: drop event->flags and use
 hw.constraint->flags
Message-ID: <20130627104833.GC27378@dyad.programming.kicks-ass.net>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
 <1371824448-7306-3-git-send-email-eranian@google.com>
 <20130624084510.GK28407@twins.programming.kicks-ass.net>
 <CABPqkBQRchnjhnEC05w-noizoeSRnNio7NDQ6_+vXym_7rkGaw@mail.gmail.com>
 <20130626103653.GC28407@twins.programming.kicks-ass.net>
 <CABPqkBQuYy3TeE81tTXVruMG4D84TQ2U5g69T2ResGgjPjK4Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQuYy3TeE81tTXVruMG4D84TQ2U5g69T2ResGgjPjK4Cg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 12:23:00PM +0200, Stephane Eranian wrote:
> Peter,
> 
> I don't this see patch in tip.git yet.

Didn't apply and I didn't get around to beating it into shape; could you resend
against tip/master. Ingo just pushed out all the other bits.
