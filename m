Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab3J2Mmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 08:42:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047Ab3J2Mmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 08:42:50 -0400
Date: Tue, 29 Oct 2013 10:42:07 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 1/4] perf tools: Split -g and --call-graph for record
 command
Message-ID: <20131029124207.GB6944@infradead.org>
References: <20131026120336.GA24439@gmail.com>
 <1382797536-32303-1-git-send-email-jolsa@redhat.com>
 <1382797536-32303-2-git-send-email-jolsa@redhat.com>
 <87k3gx967f.fsf@sejong.aot.lge.com>
 <20131029101850.GB1093@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029101850.GB1093@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 29, 2013 at 11:18:50AM +0100, Jiri Olsa escreveu:
> On Mon, Oct 28, 2013 at 04:59:16PM +0900, Namhyung Kim wrote:
> > > All current '-g' arguments is overtaken by --call-graph option.

> >   $ perf record --call-graph none -- true

> > 
> > It should be

> >   callchain: Unknown --call-graph option value: none

> ok

I fixed this one, patch went thru perf/urgent, Ingo already merged.

- Arnaldo
