Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab3GVKEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 06:04:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756687Ab3GVKE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 06:04:29 -0400
Date: Mon, 22 Jul 2013 12:02:43 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 15/23] perf tools: Add perf data version 3 header read
Message-ID: <20130722100243.GC14350@krava.brq.redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
 <1374083403-14591-16-git-send-email-jolsa@redhat.com>
 <8738rawxz8.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738rawxz8.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 09:11:39PM +0900, Namhyung Kim wrote:
> On Wed, 17 Jul 2013 19:49:55 +0200, Jiri Olsa wrote:
> > Adding perf data version 3 header read code to load
> > data for v3 format.
> >
> [SNIP]
> > +
> > +	session = container_of(header, struct perf_session, header);
> > +	if (session->evlist)
> > +		return 0;
> 
> I guess we need version check here.  The v2 format still needs to
> process it even though it's session already has a evlist, right?

right, we need it for event names.. will fix

thanks,
jirka
