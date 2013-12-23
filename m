Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab3LWNGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 08:06:15 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:45789 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757294Ab3LWNGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 08:06:14 -0500
Date: Mon, 23 Dec 2013 14:06:11 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHSET 0/7] perf tools: A couple of TUI improvements (v2)
Message-ID: <20131223130611.GB5076@gmail.com>
References: <1387516278-17024-1-git-send-email-namhyung@kernel.org>
 <20131220081357.GB12937@gmail.com>
 <87a9fsduan.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9fsduan.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> >  - it would be nice to have a hotkey to start/stop data collection on
> >    demand, and another hotkey to reset the data. SysProf has this 
> >    feature, and it's a convenient workflow to have a separate 'data 
> >    collection' period (possibly done without any screen refresh, so 
> >    that data collection does not disturb the measured workload), and 
> >    a quiet 'look at all the data that is not being changed' period. 
> >    Especially with fast changing workloads the latter can be useful.
> 
> I'm not sure I understood correctly.  So do you want start/stop the 
> 'record' part or 'report' part with hotkeys?

The 'record' part - a bit like SysProf.

> >  - it would be nice if 'perf report' had a 'view raw trace' window as 
> >    well, with filtering. That would be roughly equivalent to the 'perf
> >    report -D' output [but one line per trace entry, i.e. no hex dump
> >    shown by default], all available within the TUI. With filtering
> >    that would be a pretty good way to look at various details.
> 
> Do you want something like 'perf script'? :)

Or perf trace, just in a TUI ;-)

Thanks,

	Ingo
