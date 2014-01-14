Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbaANODc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:03:32 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:38963 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaANODa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:03:30 -0500
Date: Tue, 14 Jan 2014 11:03:16 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        linaro-kernel@lists.linaro.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        patches@linaro.org, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Yann Droneaud <ydroneaud@opteya.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL 00/38] perf/core improvements and fixes
Message-ID: <20140114140316.GB29798@ghostprotocols.net>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
 <20140114134101.GB25671@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114134101.GB25671@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 14, 2014 at 02:41:01PM +0100, Ingo Molnar escreveu:
> * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> > Andi Kleen (2):
> >       perf stat: Fix --delay option in man page
> >       perf record: Add --initial-delay option

> Hm, so we now have two options that do something similar, one named
> --delay, the other --initial-delay? That looks rather inconsistent.

> Furthermore, it looks silly to rename things --initial-delay just to
> preserve a rarely used option, --no-delay. Instead the better option
> would be to rename --no-delay to --no-buffering, and use --delay and
> use it consistently within the tools.

Ok, agreed, I'll do that, adding a patch that renames the old option,
then reworking Andi's patches to use --delay consistently.

- Arnaldo
