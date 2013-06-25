Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab3FYIrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:47:48 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:58721 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab3FYIrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:47:45 -0400
Date: Tue, 25 Jun 2013 10:47:40 +0200
From: Robert Richter <rric@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 03/14] perf: Add persistent event facilities
Message-ID: <20130625084740.GC21579@rric.localhost>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
 <1370968960-22527-4-git-send-email-rric@kernel.org>
 <20130624093204.GN28407@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624093204.GN28407@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.06.13 11:32:04, Peter Zijlstra wrote:
> I generally disapprove of indented labels. None of the perf code has
> that and the tools are easy to 'fix'.
> 
> My quiltrc contains:
> 
> QUILT_DIFF_OPTS="-F ^[[:alpha:]\$_].*[^:]\$"
> 
> my .gitconfig contains:
> 
> [diff "default"]
>                 xfuncname = "^[[:alpha:]$_].*[^:]$"
> 
> Both avoid diff thinking labels are function names.

Right, we will use your coding style. ;)

-Robert
