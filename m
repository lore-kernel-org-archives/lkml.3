Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbaFOQLk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 12:11:40 -0400
Received: from one.firstfloor.org ([193.170.194.197]:36007 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaFOQLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 12:11:39 -0400
Date: Sun, 15 Jun 2014 18:11:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 9/9] perf, tools: Add a --quiet flag to perf list
Message-ID: <20140615161138.GH5714@two.firstfloor.org>
References: <1402700580-26939-1-git-send-email-andi@firstfloor.org>
 <1402700580-26939-10-git-send-email-andi@firstfloor.org>
 <1402838261.1684.39.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402838261.1684.39.camel@leonhard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 10:17:41PM +0900, Namhyung Kim wrote:
> > It's still default to print descriptions as that is the more useful
> > default for most users.  Requested by Namhyung Kim.
> 
> Did I request the --quiet thing?  It seems like there's a
> miscommunication.. :-/

Well it was done based on your feedback, and gets the closest
to your original request as possible.

> Btw, it'd better if it can support event glob on the pmu events (or
> simply all events) too as this will increase the number of events
> significantly.  But this can be a further work.

That already works.

% perf list icache*
List of pre-defined events (to be used in -e):
  icache.ifetch_stall                                [Cycles where a code-fetch
                                                      stalled due to L1
                                                      instruction-cache miss
                                                      or an iTLB miss]
  icache.misses                                      [Number of Instruction
                                                      Cache, Streaming Buffer
                                                      and Victim Cache
                                                      Misses. Includes
                                                      Uncacheable accesses]
%

-Andi
