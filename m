Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab3FYKvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 06:51:44 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:54482 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab3FYKvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 06:51:41 -0400
Date: Tue, 25 Jun 2013 12:51:35 +0200
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 03/14] perf: Add persistent event facilities
Message-ID: <20130625105135.GF21579@rric.localhost>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
 <1370968960-22527-4-git-send-email-rric@kernel.org>
 <20130624094830.GP28407@twins.programming.kicks-ass.net>
 <20130624192616.GB24827@pd.tnic>
 <20130625074401.GY28407@twins.programming.kicks-ass.net>
 <20130625092439.GD21579@rric.localhost>
 <20130625093706.GA18612@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625093706.GA18612@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.06.13 11:37:06, Borislav Petkov wrote:
> On Tue, Jun 25, 2013 at 11:24:39AM +0200, Robert Richter wrote:
> > I also see 'pers_' not as an optimum since it could be mixed-up easily
> > with 'perf_'. Maybe we take 'persist_' instead?
> 
> Yep, although it reads wrong:
> 
> perf_add_persist_event

We could use persist_ as prefix for static functions and use the long
versions for the interface only.

But all this is a bit bikeshedding. I am sure we find something.

-Robert
