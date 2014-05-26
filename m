Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaEZRhC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:37:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbaEZRhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 13:37:00 -0400
Date: Mon, 26 May 2014 19:36:46 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv2 00/14] perf tools: Speedup DWARF unwind
Message-ID: <20140526173646.GC2763@krava.brq.redhat.com>
References: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
 <20140523081357.GC1074@krava>
 <CAFrcx1k+dk2sjB4boHQtDSzTdutJ1pxMDnGTsFwh_2_gTgYa2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1k+dk2sjB4boHQtDSzTdutJ1pxMDnGTsFwh_2_gTgYa2g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 03:26:27PM +0200, Jean Pihet wrote:
> Jiri,
> 
> 
> On 23 May 2014 10:13, Jiri Olsa <jolsa@redhat.com> wrote:
> > ping ;-)
> This looks a ping to yourself ;-)

:-)

> 
> Here are the results on ARMv7:
> - libunwind: between -29% in execution time for light load (i.e. using
> not-so-deep backtraces from the stress app.) and -49% for deep
> backtrace (the 'stress_bt' app.),
> - libdw: no significant improvement (0-2% improvement).

nice, thanks for testing!

> 
> Cf. https://wiki.linaro.org/LEG/Engineering/TOOLS/perf-callstack-unwinding#Speed_improvement
> for more details.
> 
> FWIW:
> Acked-by: Jean Pihet <jean.pihet@linaro.org>

thanks,
jirka
