Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbaBEJQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 04:16:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbaBEJQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 04:16:17 -0500
Date: Wed, 5 Feb 2014 10:15:57 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [RFC 00/22] perf tools: Display tracepoint enahncements
Message-ID: <20140205091557.GD1201@krava.brq.redhat.com>
References: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
 <20140202214550.GA2694@krava.redhat.com>
 <87r47i1gmd.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r47i1gmd.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 10:40:42AM +0900, Namhyung Kim wrote:
> On Sun, 2 Feb 2014 22:45:50 +0100, Jiri Olsa wrote:
> > On Sun, Feb 02, 2014 at 10:38:48PM +0100, Jiri Olsa wrote:
> >> hi,
> >> sending out tracepoint (mostly) events display enahncements.
> >
> > forgot to mention.. the branch is in here:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
> >   perf/core_tp
> 
> It's segfaulted with --group --tui option since the hpp->ptr is not
> setup to point an evsel.  Not sure whose problem.. ;-)

will check ;-) thanks

jirka
