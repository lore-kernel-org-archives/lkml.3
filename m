Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab3FYJYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 05:24:46 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:45964 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab3FYJYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 05:24:44 -0400
Date: Tue, 25 Jun 2013 11:24:39 +0200
From: Robert Richter <rric@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 03/14] perf: Add persistent event facilities
Message-ID: <20130625092439.GD21579@rric.localhost>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
 <1370968960-22527-4-git-send-email-rric@kernel.org>
 <20130624094830.GP28407@twins.programming.kicks-ass.net>
 <20130624192616.GB24827@pd.tnic>
 <20130625074401.GY28407@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625074401.GY28407@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.06.13 09:44:01, Peter Zijlstra wrote:
> Elsewhere in this series you use 'pers' to shorten things; it reads a
> bit odd to me because 'pers' is the Dutch word for press (both meanings
> transfer) but that is just something I'll have to live with isn't it ;-)
> 
> As for tracepoint, it seems common to shorten that to tp; which always
> reminds me of toilet paper, but I suppose more people suffer from that.
> 
> Yielding: perf_add_pers_tp() 
> 
> which I read as adding pressed toilet paper.. a well :-)

Better we avoid this, don't wonat you misread the code. ;)

I also see 'pers_' not as an optimum since it could be mixed-up easily
with 'perf_'. Maybe we take 'persist_' instead?

-Robert
