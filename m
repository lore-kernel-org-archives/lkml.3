Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaJXB5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 21:57:05 -0400
Received: from mail.kernel.org ([198.145.19.201]:59404 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbaJXB5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 21:57:03 -0400
Date: Thu, 23 Oct 2014 22:56:54 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 0/5] perf tools: Speed up dwarf callchain
 post-unwinding for libunwind (v4)
Message-ID: <20141024015654.GV14687@kernel.org>
References: <1412556363-26229-1-git-send-email-namhyung@kernel.org>
 <20141013181158.GA28191@krava.redhat.com>
 <20141015192441.GR3198@kernel.org>
 <20141015200630.GT3198@kernel.org>
 <87iojcga58.fsf@sejong.aot.lge.com>
 <20141023233542.GR14687@kernel.org>
 <877fzqe1pa.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877fzqe1pa.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Oct 24, 2014 at 09:44:17AM +0900, Namhyung Kim escreveu:
> On Thu, 23 Oct 2014 20:35:42 -0300, Arnaldo Carvalho de Melo wrote:
> > I'll push later and will drop you a note, so that you can, please, check
> > if the end result is sane.
> 
> Thank you!

It should be on my perf/core branch by now.
 
> > Sorry for the slip up,
> 
> No problem. :)

:-)

- Arnaldo
