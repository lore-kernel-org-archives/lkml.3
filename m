Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbbAZO0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:26:30 -0500
Received: from smtprelay0150.hostedemail.com ([216.40.44.150]:46560 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752517AbbAZO01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:26:27 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:3138:3139:3140:3141:3142:3352:3622:3865:3867:3871:3872:3874:5007:6119:6261:7875:7996:8526:9010:9040:10004:10400:10848:10967:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cream36_37d580db8862a
X-Filterd-Recvd-Size: 1799
Date: Mon, 26 Jan 2015 09:26:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 2/5] tools lib api fs: Add tracefs mount helper
 functions
Message-ID: <20150126092621.263160aa@gandalf.local.home>
In-Reply-To: <20150126090255.GC13287@krava.brq.redhat.com>
References: <20150124181330.195149364@goodmis.org>
	<20150124181448.680347393@goodmis.org>
	<20150125165619.GF31987@krava.brq.redhat.com>
	<20150125142645.3c5156e7@gandalf.local.home>
	<20150126090255.GC13287@krava.brq.redhat.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015 10:02:55 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> > Note, WTF is perf checking the magic number for debugfs?? If events
> > move, even if its at the same path, this will break perf!
> 
> good question.. it's there since 2009:
>   f6bdafef2ab9 perf_counter: Add tracepoint support to perf list, perf stat
> 
> I guess we didn't want anyone to trick us with fake tracepoints ;-)

But that would be a feature not a bug. I could imagine admins doing
this for some work around.

But can we nuke that check? I don't think it's very useful.

-- Steve
