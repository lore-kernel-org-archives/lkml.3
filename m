Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab3FYJhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 05:37:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52218 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab3FYJhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 05:37:12 -0400
Date: Tue, 25 Jun 2013 11:37:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 03/14] perf: Add persistent event facilities
Message-ID: <20130625093706.GA18612@pd.tnic>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
 <1370968960-22527-4-git-send-email-rric@kernel.org>
 <20130624094830.GP28407@twins.programming.kicks-ass.net>
 <20130624192616.GB24827@pd.tnic>
 <20130625074401.GY28407@twins.programming.kicks-ass.net>
 <20130625092439.GD21579@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130625092439.GD21579@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 11:24:39AM +0200, Robert Richter wrote:
> On 25.06.13 09:44:01, Peter Zijlstra wrote:
> > Elsewhere in this series you use 'pers' to shorten things; it reads a
> > bit odd to me because 'pers' is the Dutch word for press (both meanings
> > transfer) but that is just something I'll have to live with isn't it ;-)
> > 
> > As for tracepoint, it seems common to shorten that to tp; which always
> > reminds me of toilet paper, but I suppose more people suffer from that.
> > 
> > Yielding: perf_add_pers_tp() 
> > 
> > which I read as adding pressed toilet paper.. a well :-)
> 
> Better we avoid this, don't wonat you misread the code. ;)
> 
> I also see 'pers_' not as an optimum since it could be mixed-up easily
> with 'perf_'. Maybe we take 'persist_' instead?

Yep, although it reads wrong:

perf_add_persist_event

Another not really optimal idea would be to call them sticky events:

perf_add_sticky_event.

Also funny.

Then there's

perf_add_prstnt_event

Also, not really great.

Hmmm.. I got nothing so far...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
