Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab3DZQuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 12:50:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756588Ab3DZQui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 12:50:38 -0400
Date: Fri, 26 Apr 2013 18:47:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will.deacon@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/4] perf: Add hardware breakpoint address mask
Message-ID: <20130426164716.GA30402@redhat.com>
References: <20130423095437.GD17593@mudshark.cambridge.arm.com> <20130423143423.GB17021@jshin-Toonie> <20130423144057.GA19644@jshin-Toonie> <20130423150240.GD18616@mudshark.cambridge.arm.com> <20130423151846.GA22052@jshin-Toonie> <20130424094853.GB21850@mudshark.cambridge.arm.com> <20130424163038.GA29816@jshin-Toonie> <20130425170635.GA1324@redhat.com> <5179652F.8080507@zytor.com> <20130425231911.GB31751@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130425231911.GB31751@jshin-Toonie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, Jacob Shin wrote:
>
> Right now perf
> userland tool hard codes bp_len to 4, so I need to modify it to allow
> user to override the length if desired.

imho this itself looks like a good change...

> Oleg, Frederic, et al.
>
> Which syntax do you prefer?
>
>   $ perf stat -e mem:0x1000/16

Personally I like this a bit more, but I won't argue in any case.

Oleg.

