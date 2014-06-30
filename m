Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbaF3HIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 03:08:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37602 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbaF3HH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 03:07:59 -0400
Date: Mon, 30 Jun 2014 09:07:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>, Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>
Subject: crazy idea (was: Re: [PATCH] perf tool: Carve out ctype.h et al)
Message-ID: <20140630070755.GA4766@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2014 at 01:28:19AM +0200, Borislav Petkov wrote:
> Ok, cool. So guys, can we apply this one so that I can continue with the
> next round?

Ok, I had this crazy idea recently:

How about we copy the perf tool code we need for the RAS daemon and
start hacking on it in a separate repo, somewhere else?

This way we can start adding features and stuff and finally do some real
work on it. The code which deals with opening a tracepoint and reading
from it should be pretty stable by now so we won't have to sync back
with perf too often. And if we do, we'll copy the changed bits.

In the meantime, we can still work on the splitting of the kernel code
if it is desired.

In any case, I would definitely like to parallelize the work because
if we wait for the split to happen, we won't have a RAS daemon with
persistent events by Christmas 2050 and by then who knows whether we're
even alive.</sarcastic joke>

So what do you guys think, makes some sense at least?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
