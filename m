Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080Ab3FRNOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 09:14:39 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36001 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753919Ab3FRNOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 09:14:38 -0400
Date: Tue, 18 Jun 2013 14:13:19 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jed Davis <jld@mozilla.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: ARM: Record the user-mode PC in the call chain.
Message-ID: <20130618131319.GC6801@mudshark.cambridge.arm.com>
References: <20130613232111.GA12536@mozilla.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613232111.GA12536@mozilla.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 12:21:11AM +0100, Jed Davis wrote:
> With this change, we no longer lose the innermost entry in the user-mode
> part of the call chain.  See also the x86 port, which includes the ip.
> 
> It's possible to partially work around this problem by post-processing
> the data to use the PERF_SAMPLE_IP value, but this works only if the CPU
> wasn't in the kernel when the sample was taken.

Thanks. I guess we need something similar for arm64 too. Could you cook a
similar patch please?

Will
