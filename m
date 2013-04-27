Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab3D0PRt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 11:17:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646Ab3D0PRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 11:17:48 -0400
Date: Sat, 27 Apr 2013 17:14:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 1/3] perf/x86/amd: AMD support for bp_len >
	HW_BREAKPOINT_LEN_8
Message-ID: <20130427151434.GA25746@redhat.com>
References: <1367002666-6910-1-git-send-email-jacob.shin@amd.com> <1367002666-6910-2-git-send-email-jacob.shin@amd.com> <20130427150510.GA25109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130427150510.GA25109@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27, Oleg Nesterov wrote:
>
> Suppose that the kernel was compiled without CONFIG_CPU_SUP_AMD.
> Then perf_event_open(attr => { .bp_len == 16 }) will succeed,
                                                  ^^^^^^^^^^^^
sorry, I meant "can succeed" if CPU has X86_FEATURE_BPEXT.

Oleg.

