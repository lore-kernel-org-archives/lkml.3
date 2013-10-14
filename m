Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab3JNIBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:01:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab3JNIBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:01:30 -0400
Date: Mon, 14 Oct 2013 10:01:08 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 0/8] perf tools: Fix scalability problem on callchain
 merging (v5)
Message-ID: <20131014080108.GA1590@krava.redhat.com>
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org>
 <20131013123444.GB1044@krava.brq.redhat.com>
 <87k3hgbgn2.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k3hgbgn2.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 01:50:09PM +0900, Namhyung Kim wrote:
> On Sun, 13 Oct 2013 14:34:44 +0200, Jiri Olsa wrote:
> > I put perf archive and data output in here if you're interested:
> > http://people.redhat.com/jolsa/cc/
> 
> I can't download the data output (but the archive is fine).
> 
>   $ curl http://people.redhat.com/jolsa/cc/perf.data
>   <!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
>   <html><head>
>   <title>403 Forbidden</title>
>   </head><body>
>   <h1>Forbidden</h1>
>   <p>You don't have permission to access /jolsa/cc/perf.data
>   on this server.</p>
>   <hr>
>   <address>Apache Server at people.redhat.com Port 80</address>
>   </body></html>

oops, should be fixed now.. haven't checked persmissions :-\

jirka
