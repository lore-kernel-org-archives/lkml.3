Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbaJULSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 07:18:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:51082 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbaJULSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 07:18:10 -0400
Date: Tue, 21 Oct 2014 13:18:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        jolsa@redhat.com, kan.liang@intel.com, bp@alien8.de,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH v2 05/12] perf/x86: add cross-HT counter exclusion
 infrastructure
Message-ID: <20141021111806.GX23531@worktop.programming.kicks-ass.net>
References: <1412872486-2930-1-git-send-email-eranian@google.com>
 <1412872486-2930-6-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412872486-2930-6-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 06:34:39PM +0200, Stephane Eranian wrote:
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -71,6 +71,7 @@ struct event_constraint {
>  #define PERF_X86_EVENT_COMMITTED	0x8 /* event passed commit_txn */
>  #define PERF_X86_EVENT_PEBS_LD_HSW	0x10 /* haswell style datala, load */
>  #define PERF_X86_EVENT_PEBS_NA_HSW	0x20 /* haswell style datala, unknown */
> +#define PERF_X86_EVENT_EXCL		0x40 /* HT exclusivity on counter */
>  

lkml.kernel.org/r/CAHzUATgam8qrma+B-d=9jOHpmmiwNwk-717roNY=ndbJAZefjw@mail.gmail.com
