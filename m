Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab3GHQZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:25:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab3GHQZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:25:12 -0400
Date: Mon, 8 Jul 2013 18:24:52 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Greg Price <price@mit.edu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v2] perf report/top: Add option to collapse undesired
 parts of call graph
Message-ID: <20130708162452.GB2957@krava.brq.redhat.com>
References: <20130701142841.GE22203@biohazard-cafe.mit.edu>
 <20130707131340.GA23433@krava.brq.redhat.com>
 <20130708115746.GO22203@biohazard-cafe.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130708115746.GO22203@biohazard-cafe.mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 07:57:46AM -0400, Greg Price wrote:
> On Sun, Jul 07, 2013 at 03:13:40PM +0200, Jiri Olsa wrote:
> > On Mon, Jul 01, 2013 at 10:28:45AM -0400, Greg Price wrote:
> > > For example, in an application with an expensive function
> > > implemented with deeply nested recursive calls, the default
> > > call-graph presentation is dominated by the different callchains
> > > within that function.  By ignoring these callees, we can collect
> > > the callchains leading into the function and compactly identify
> > > what to blame for expensive calls.
> > 
> > hi,
> > what's this one based on? I cannot get it applied on acme's perf/core
> 
> That was on v3.10.  Here it is on 6d895ece5, which is currently acme's
> perf/core.
> 
> Cheers,
> Greg
> 
> 
> -- >8 --
> Date: Thu, 6 Dec 2012 21:48:05 -0800
> 
> For example, in an application with an expensive function
> implemented with deeply nested recursive calls, the default
> call-graph presentation is dominated by the different callchains
> within that function.  By ignoring these callees, we can collect
> the callchains leading into the function and compactly identify
> what to blame for expensive calls.

change looks ok, but I'm not that confident in this part, so at least:

Tested-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka
