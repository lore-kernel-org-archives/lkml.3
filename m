Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab3DWNZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:25:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755907Ab3DWNZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:25:18 -0400
Date: Tue, 23 Apr 2013 15:22:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/4] perf/x86/amd: AMD implementation for hardware
	breakpoint address mask
Message-ID: <20130423132207.GB24467@redhat.com>
References: <1366703825-19373-1-git-send-email-jacob.shin@amd.com> <1366703825-19373-3-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366703825-19373-3-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23, Jacob Shin wrote:
>
> +int arch_validate_hwbkpt_addr_mask(struct perf_event *bp)
> +{
> +	if (!cpu_has_bpext)
> +		return -EOPNOTSUPP;

I must have missed something...

But it shouldn't fail if bp_addr_mask == 0?

Oleg.

