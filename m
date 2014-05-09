Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbaEINdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 09:33:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbaEINds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 09:33:48 -0400
Date: Fri, 9 May 2014 09:33:18 -0400
From: Don Zickus <dzickus@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCHSET 00/17] perf report: Add -F option for specifying
 output fields (v4)
Message-ID: <20140509133318.GC39568@redhat.com>
References: <1398346899.1681.18.camel@leonhard>
 <20140424210015.GJ8488@redhat.com>
 <20140428194642.GQ5328@redhat.com>
 <878uqpos3k.fsf@sejong.aot.lge.com>
 <20140429172735.GD32375@redhat.com>
 <874n1bpuzh.fsf@sejong.aot.lge.com>
 <20140430133554.GB61249@redhat.com>
 <87mweunv8p.fsf@sejong.aot.lge.com>
 <20140507152219.GN39568@redhat.com>
 <87y4ybmqgf.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y4ybmqgf.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 03:11:28PM +0900, Namhyung Kim wrote:
> >> > I am willing to believe I missed scenario when sorting, I just can't think
> >> > of it (so I wouldn't know how to fix it).  That's why I was looking for an
> >> > example to make it more obvious to me.  Sorry for being slow..
> >> 
> >> I'm also sorry for being late.  Looking at the code, it seems to use
> >> identity__map_ip() for anon maps so my concern is bogus.  Please just
> >> forget about it and keep going.  Sorry for interrupting your work..
> >
> > No worries.  Always good to have an extra pair of eyes.
> >
> > I am a little stuck about where to go.  I think it might make sense to
> > submit this as a standalone patch (despite the possible group limitation
> > we are discussing).  Thoughts?
> 
> You meant to submit the 'dcacheline' sort key patch?  I'm okay with it.

Ok.  I'll try to put together a patchset next week for that piece.

> 
> Things are getting more confusing when thinking about complex
> scenarios..  so I'd rather finish this -F option patchset and start to
> think about how to integrate group sorting with it.

Hehe.  I understand.  That's fine.

Cheers,
Don
