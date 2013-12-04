Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972Ab3LDSIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 13:08:23 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:35672 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569Ab3LDSIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 13:08:20 -0500
Date: Wed, 4 Dec 2013 15:08:10 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 6/7] perf tools: Do not need to read symbols for source
 line lookup
Message-ID: <20131204180810.GB14788@ghostprotocols.net>
References: <1386055390-13757-1-git-send-email-adrian.hunter@intel.com>
 <1386055390-13757-7-git-send-email-adrian.hunter@intel.com>
 <20131203202421.GA23729@ghostprotocols.net>
 <529F3572.703@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529F3572.703@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 04, 2013 at 04:00:18PM +0200, Adrian Hunter escreveu:
> On 03/12/13 22:24, Arnaldo Carvalho de Melo wrote:
> > Em Tue, Dec 03, 2013 at 09:23:09AM +0200, Adrian Hunter escreveu:
> >> When using libbfd to lookup source filename and line number,
> >> libbfd does not need the symbol table.  Removing the symbol
> >> table reading, doubles the speed of 'perf script' with the
> >> 'srcline' option.
> > 
> > [root@zoo ~]# gdb perf
> > run report -s srcline
> > 
> > b00000m
> 
> I wasn't able to reproduce this but I noticed the line numbers
> were not found for kernel modules with this patch - so it seems
> some binaries need the symbol information and some don't.
> 
> So please disregard this patch, sorry for your trouble.

No problem, disregarding it.

- Arnaldo
