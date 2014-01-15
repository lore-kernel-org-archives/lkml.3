Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaAOPps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:45:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbaAOPpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:45:46 -0500
Date: Wed, 15 Jan 2014 16:45:00 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, namhyung@kernel.org, mingo@kernel.org,
        dsahern@gmail.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/6] perf, tools: Support handling complete branch stacks
 as histograms v3
Message-ID: <20140115154500.GE17358@krava.redhat.com>
References: <1389661461-18996-1-git-send-email-andi@firstfloor.org>
 <1389661461-18996-3-git-send-email-andi@firstfloor.org>
 <20140115144842.GA17358@krava.redhat.com>
 <20140115152729.GP20765@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115152729.GP20765@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 04:27:29PM +0100, Andi Kleen wrote:
> > this option is not added in this patch, I tried:
> >   $ perf report --call-graph=fractal,0.5,callee,function,branch
> 
> Of course not, it's in the next patch.
> 
> But I was not putting the cumbersome long command line into this
> example.
> 
> If you really feel strongly about it I guess the two patches could be merged,
> but seems cleaner separated.
> 
> > 
> > but as I already said in reply for patch 3, it's not working
> > please update the doc in Documentation/perf-report.txt with an example
> 
> What kind of example? Full output for a command?
> 
> I don't think any other option has that in the man page. It would be
> unique.
> 
> Having a illustrated `perf tutorial' with examples would probably be a 
> good idea, but I'm not sure the man page is the right place for that.
> 

yea.. example would be too much ;-) but at least all available options
are mentioned in '--call-graph::' section in Documentation/perf-report.txt
and 'branch' is missing

jirka
