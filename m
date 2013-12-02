Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348Ab3LBURR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:17:17 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:59843 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab3LBURN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 15:17:13 -0500
Date: Mon, 2 Dec 2013 17:17:05 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/3] perf report: Add --show-time-info option
Message-ID: <20131202201705.GE17149@ghostprotocols.net>
References: <20131202192315.GA17149@ghostprotocols.net>
 <529CDEA6.8000807@gmail.com>
 <20131202193850.GC17149@ghostprotocols.net>
 <529CE66B.5070209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529CE66B.5070209@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 02, 2013 at 12:58:35PM -0700, David Ahern escreveu:
> On 12/2/13, 12:38 PM, Arnaldo Carvalho de Melo wrote:
> >Can you suggest a better name for the option being discussed?

> >Perhaps one of:

> >--show-event-time
> >--event-time

> >?
> 
> Why not just --event-time?

 
> Really should have dropped the 'show' from the recent perf-script
> change (just --task-events and --mmap-events).

Probably, yeah, Ingo made some point about using --show- for some reason,
Ingo?

One I can think of is that, in general, plain --feature can mean, at
least, one of --enable-feature and --show-feature, so perhaps that is
the point.

But then, perhaps that may be implied by the context, i.e.  when
recording, --feature means enable it, while when reporting, what we're
doing is basically _showing_ things, so --feature means just that.

- Arnaldo
 
> >
> >As a policy I think we should go on adding just long options and only
> >after there is a really strong case we should use a short option for
> >really, really popular options.
> 
> And adding options to .perfconfig. Need to use that more.
> 
> David
