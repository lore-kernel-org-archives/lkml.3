Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030461Ab3DSM13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:27:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37586 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030384Ab3DSM1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:27:25 -0400
Message-ID: <1366374436.24945.6.camel@laptop>
Subject: Re: [PATCH 2/2] perf, amd: support for AMD NB and L2I "uncore"
 counters.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Date: Fri, 19 Apr 2013 14:27:16 +0200
In-Reply-To: <20130418163315.GA7903@jshin-Toonie>
References: <1366046483-1765-1-git-send-email-jacob.shin@amd.com>
	 <1366046483-1765-3-git-send-email-jacob.shin@amd.com>
	 <1366284534.19383.13.camel@laptop> <20130418163315.GA7903@jshin-Toonie>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-18 at 11:33 -0500, Jacob Shin wrote:

> Okay, here is V2 which does that. Thanks again in advance for taking
> the time to look it over.

Awesome, looks good on a first read.. I'm assuming you've tested things
and they actually work too? :-)

> From d68225744196d8b0d60a1bc33ae9abdbffbd9bc9 Mon Sep 17 00:00:00 2001
> From: Jacob Shin <jacob.shin@amd.com>
> Date: Sun, 14 Apr 2013 04:12:42 -0500
> Subject: [PATCH 2/2] perf, amd: support for AMD NB and L2I "uncore" counters.
> 
> Add support for AMD Family 15h [and above] northbridge performance
> counters. MSRs 0xc0010240 ~ 0xc0010247 are shared across all cores
> that share a common northbridge.
> 
> Add support for AMD Family 16h L2 performance counters. MSRs
> 0xc0010230 ~ 0xc0010237 are shared across all cores that share a
> common L2 cache.
> 
> We do not enable counter overflow interrupts. Sampling mode and
> per-thread events are not supported.
> 
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>


