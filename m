Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab3IZSYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:24:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab3IZSYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:24:10 -0400
Date: Thu, 26 Sep 2013 20:23:34 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: mmap output file - RFC
Message-ID: <20130926182334.GC9121@krava.brq.redhat.com>
References: <1379901959-5285-1-git-send-email-dsahern@gmail.com>
 <20130926175105.GB9121@krava.brq.redhat.com>
 <524478F2.8040609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524478F2.8040609@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 12:12:02PM -0600, David Ahern wrote:
> On 9/26/13 11:51 AM, Jiri Olsa wrote:
> >but it's still faster, since we finally get perf a chance to sleep ;-)
> >
> >new time:
> >	real    0m30.392s
> >	user    0m0.041s
> >	sys     0m0.389s
> >
> >old time:
> >	real    0m32.235s
> >	user    0m3.080s
> >	sys     0m14.444s
> 
> excellent.
> 
> >
> >
> >>[ perf record: Captured and wrote 8.203 MB /tmp/perf.data (~358388 samples) ]
> >>
> >>Before I get too far down this path I wanted to get comments on the approach.
> >
> >I think it's worthwhile doing this
> 
> If you can toss it onto your queue to run through it other use cases
> -- like the 'make -j' on kernel builds. I am doing the same here and
> if all goes well I submit with some other patches next week.

ok, np

jirka
