Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795Ab3EGMpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 08:45:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757388Ab3EGMpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 08:45:49 -0400
Date: Tue, 7 May 2013 14:29:48 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCHv3 0/4] perf, signal x86: Fix breakpoint events overflow
 handling
Message-ID: <20130507122948.GD1076@krava.brq.redhat.com>
References: <1367421944-19082-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367421944-19082-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 05:25:40PM +0200, Jiri Olsa wrote:
> hi,
> sending v3 for initial patchset:
> https://lkml.org/lkml/2013/3/1/324
> 
> basically just sending remaining (not pulled) patches,
> with '*-by: *' tags updated.
> 
> v3 changes:
>   - perf test patches already pulled in
>   - added Oleg's Tested-by for signal related patches
>   - added Frederic's Reviewed-by for signal related patches
>   - added Peter's Reviewed-by for perf patch.

hi,

Thomas, Peter,
any chance you could pull this in?

Ingo,
could you please take the perf change (4/4)?
it's reviewed by PeterZ

thanks,
jirka
