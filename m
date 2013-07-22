Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab3GVKAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 06:00:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910Ab3GVKAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 06:00:45 -0400
Date: Mon, 22 Jul 2013 12:00:06 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 13/23] perf tools: Introduce perf.data version 3 format
Message-ID: <20130722100006.GB14350@krava.brq.redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
 <1374083403-14591-14-git-send-email-jolsa@redhat.com>
 <877ggmwy81.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877ggmwy81.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 09:06:22PM +0900, Namhyung Kim wrote:
> On Wed, 17 Jul 2013 19:49:53 +0200, Jiri Olsa wrote:
> > Introducing perf.data version 3 format. No functional change,
> > just introducing doc, magic bytes and the struct.
> >
> [SNIP]
> 
> > +perf-data-file-v3(1)
> 
> s/(1)/(5)/
> 
> The same goes to v2 doc.
ok

> 
> 
> > +====================
> > +Following text describes version 3 of the perf data file format,
> > +which is version that is currently used by perf tool.
> > +
> > +In version 3 we got rid of following sections:
> > +  EVENT IDS
> > +  EVENT ATTRIBUTES
> > +  EVENT TYPES
> > +
> > +and keep only data and features sections. All the data
> > +from above listed sections are now read from specific
> > +FEATURES sections.
> > +
> > +benefits:
> > +  - siplified header storage at the time the file is closed
> 
> s/siplified/simplified/
ok

> 
> 
> > +  - allowing cpu hotpluged addition/removal event IDs
> > +    during the session due to 1)

it's the first '-' before I switched from numbering to '-' ;-) will fix

thanks,
jirka
