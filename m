Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbaH2PTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 11:19:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbaH2PTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 11:19:51 -0400
Date: Fri, 29 Aug 2014 17:18:59 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/24] perf tools: Add a test for tracking with
 sched_switch
Message-ID: <20140829151859.GA11558@krava.brq.redhat.com>
References: <1408129739-17368-1-git-send-email-adrian.hunter@intel.com>
 <1408129739-17368-2-git-send-email-adrian.hunter@intel.com>
 <20140820194813.GI2892@kernel.org>
 <54008590.7000507@intel.com>
 <20140829150634.GF3330@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140829150634.GF3330@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 12:06:34PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Aug 29, 2014 at 04:52:16PM +0300, Adrian Hunter escreveu:
> > On 08/20/2014 10:48 PM, Arnaldo Carvalho de Melo wrote:
> > > But, for the current architecture, that should be just a clarification,
> > > not a requirement for this specific test.
>  
> > I will keep that in mind.
>  
> > > Applying!
>  
> > Thank you!
>  
> > AFAICT the other 20 patches still apply cleanly to your tree, so I am not
> > going to send any more for now.
> 
> Ok, I'll try to process more of those, the db interface probably, after
> I try using it for some simple tests.
> 
> About the PMU ones, that I would like to hear from other people dealing
> with that area, like Jiri or even PeterZ, that IIRC discussed sysfs
> interface aspects in the past, Jiri, Peter?

I reviewed those, but I remember not getting an answer
for my question about that
  http://marc.info/?t=140533254600001&r=1&w=2

jirka
