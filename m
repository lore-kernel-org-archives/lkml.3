Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899Ab3DYRJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:09:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758845Ab3DYRJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:09:49 -0400
Date: Thu, 25 Apr 2013 19:06:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/4] perf: Add hardware breakpoint address mask
Message-ID: <20130425170635.GA1324@redhat.com>
References: <1366703825-19373-1-git-send-email-jacob.shin@amd.com> <1366703825-19373-2-git-send-email-jacob.shin@amd.com> <20130423095437.GD17593@mudshark.cambridge.arm.com> <20130423143423.GB17021@jshin-Toonie> <20130423144057.GA19644@jshin-Toonie> <20130423150240.GD18616@mudshark.cambridge.arm.com> <20130423151846.GA22052@jshin-Toonie> <20130424094853.GB21850@mudshark.cambridge.arm.com> <20130424163038.GA29816@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130424163038.GA29816@jshin-Toonie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24, Jacob Shin wrote:
>
> And only x86
> hw_breakpoint will know what .config = 0xf means for x86 and do the right
> thing. For ARM, 0xf will mean something different.
>
> The downside is that in userland perf tool we need differing documentation
> on what the mask syntax means for each architecture.

Personally I think this is acceptable.

But I am new to this code, so...

Oleg.

