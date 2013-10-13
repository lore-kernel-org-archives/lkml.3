Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab3JMVcy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 17:32:54 -0400
Received: from one.firstfloor.org ([193.170.194.197]:59348 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab3JMVcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 17:32:52 -0400
Date: Sun, 13 Oct 2013 23:32:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] perf record,top: Add callchain option into .perfconfig
Message-ID: <20131013213251.GC2592@two.firstfloor.org>
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org>
 <20131011055829.GA4975@gmail.com>
 <20131011073448.GA11064@krava.redhat.com>
 <52581511.2010909@gmail.com>
 <52581737.8090309@gmail.com>
 <87wqljxyqg.fsf@tassilo.jf.intel.com>
 <525875FB.1090104@gmail.com>
 <20131013102521.GA1044@krava.brq.redhat.com>
 <20131013211805.GA1018@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131013211805.GA1018@krava>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 13, 2013 at 11:18:05PM +0200, Jiri Olsa wrote:
> On Sun, Oct 13, 2013 at 12:25:21PM +0200, Jiri Olsa wrote:
> 
> SNIP
> 
> > 
> > I'll try to come up with something later today
> > 
> > jirka
> 
> 
> hi,
> here it is.. not fully tested, no doc updates, dont want
> to go too far before we agreed on this ;-)

I don't think that's a good idea. Still need some way to control
dwarf from the command line.

-Andi
