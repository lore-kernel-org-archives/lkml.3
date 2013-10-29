Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab3J2KTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 06:19:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349Ab3J2KTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 06:19:11 -0400
Date: Tue, 29 Oct 2013 11:18:50 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 1/4] perf tools: Split -g and --call-graph for record
 command
Message-ID: <20131029101850.GB1093@krava.brq.redhat.com>
References: <20131026120336.GA24439@gmail.com>
 <1382797536-32303-1-git-send-email-jolsa@redhat.com>
 <1382797536-32303-2-git-send-email-jolsa@redhat.com>
 <87k3gx967f.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k3gx967f.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 04:59:16PM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> On Sat, 26 Oct 2013 16:25:33 +0200, Jiri Olsa wrote:
> > Splitting -g and --call-graph for record command, so we could
> > use '-g' with no option.
> >
> > The '-g' option now takes NO argument and enables the configured
> > unwind method, which is currently the frame pointers method.
> >
> > It will be possible to configure unwind method via config
> > file in upcoming patches.
> >
> > All current '-g' arguments is overtaken by --call-graph option.
> 
>   $ perf record --call-graph none -- true
>   callchain: Unknown -g option value: none
> 
> It should be
> 
>   callchain: Unknown --call-graph option value: none

ok
