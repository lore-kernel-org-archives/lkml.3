Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab3FYP3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:29:45 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52469 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab3FYP3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:29:43 -0400
Date: Tue, 25 Jun 2013 17:29:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 03/14] perf: Add persistent event facilities
Message-ID: <20130625152941.GD4855@pd.tnic>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
 <1370968960-22527-4-git-send-email-rric@kernel.org>
 <20130624094830.GP28407@twins.programming.kicks-ass.net>
 <20130624192616.GB24827@pd.tnic>
 <20130625074401.GY28407@twins.programming.kicks-ass.net>
 <20130625092439.GD21579@rric.localhost>
 <20130625093706.GA18612@pd.tnic>
 <20130625105135.GF21579@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130625105135.GF21579@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 12:51:35PM +0200, Robert Richter wrote:
> On 25.06.13 11:37:06, Borislav Petkov wrote:
> > On Tue, Jun 25, 2013 at 11:24:39AM +0200, Robert Richter wrote:
> > > I also see 'pers_' not as an optimum since it could be mixed-up easily
> > > with 'perf_'. Maybe we take 'persist_' instead?
> > 
> > Yep, although it reads wrong:
> > 
> > perf_add_persist_event
> 
> We could use persist_ as prefix for static functions and use the long
> versions for the interface only.
> 
> But all this is a bit bikeshedding. I am sure we find something.

How about

perf_add_pevent?

It is nice and short, although maybe too short but "pevent" is almost
like a special term and the name shows that it is a special type of
event, i.e. a p-event.

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
