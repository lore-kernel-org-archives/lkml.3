Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab3HEHrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 03:47:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097Ab3HEHrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 03:47:46 -0400
Date: Mon, 5 Aug 2013 09:47:26 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf tools: Renaming 'time' variable in perf_time_to_tsc
 due to name shadowing error
Message-ID: <20130805074726.GA18719@krava.redhat.com>
References: <1375175954-798-1-git-send-email-namhyung@kernel.org>
 <20130801120251.GB1032@krava.brq.redhat.com>
 <51FB2B90.6090602@gmail.com>
 <20130802133346.GD1711@krava.brq.redhat.com>
 <51FD5899.6060100@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51FD5899.6060100@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 03, 2013 at 10:23:05PM +0300, Adrian Hunter wrote:
> On 2/08/2013 4:33 p.m., Jiri Olsa wrote:
> >The perf compilation fails with following error:
> >       ...
> >       CC arch/x86/util/tsc.o
> >   arch/x86/util/tsc.c: In function ‘perf_time_to_tsc’:
> >   arch/x86/util/tsc.c:13:6: error: declaration of ‘time’ shadows a global declaration [-Werror=shadow]
> >   cc1: all warnings being treated as errors
> >
> >Renaming the 'time' variable to prevent this.
> 
> Did you see David did the same patch.
> 
> Although David noted the gcc version.  It doesn't happen for gcc
> 4.7.3.  The commit message should probably reflect that it depends
> on the gcc version.

I haven't noticed Daivd's patch.. screw this one then

jirka
