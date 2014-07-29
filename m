Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbaG2NGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 09:06:55 -0400
Received: from mail.kernel.org ([198.145.19.201]:49147 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbaG2NGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 09:06:54 -0400
Date: Tue, 29 Jul 2014 10:06:50 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Andres Freund <andres@anarazel.de>
Cc: Namhyung Kim <namhyung@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH 22/27] perf tools: Enable --children option by default
Message-ID: <20140729130650.GP7831@kernel.org>
References: <1401335910-16832-1-git-send-email-namhyung@kernel.org>
 <1401335910-16832-23-git-send-email-namhyung@kernel.org>
 <20140728192326.GS17793@alap3.anarazel.de>
 <8738dkirlt.fsf@sejong.aot.lge.com>
 <20140729114548.GA27368@alap3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729114548.GA27368@alap3.anarazel.de>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jul 29, 2014 at 01:45:48PM +0200, Andres Freund escreveu:
> On 2014-07-29 15:52:46 +0900, Namhyung Kim wrote:
> > Yes, I knew it'd annoy some existing users like you :)

And me :-)

> > But I hoped it'd be useful for new and (at least, some of) old users
> > to see children/ cumulative overheads by default.  If it lies under
> > an option, it wouldn't have a chance to be used by normal users who
> > simply run perf record and report most of time.
 
> By that argument every new feature would need to be enabled by
> default. Which normally isn't what happens.
 
> > If you think it's entirely useless for you cases, you can set it to off
> > using ~/.perfconfig file:

> >   [report]
> >   children = false
 
> Already done that ;).

:-)
 
> The problem is still that I can't use --no-children on older systems, so
> I can't write benchmarking scripts anymore that don't take depend on the
> perf version...
 
> I guess it's too late to argue effectively though :)

yeah, changing the output people are used to in such a big way is not
nice.

Perhaps next time we should instead present a dialog box at 'perf
report' start allowing people to opt-in, having a nice explanation about
why one would want to switch the default while alowing people to say:

[x] No, Thanks

- Arnaldo
