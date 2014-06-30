Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbaF3Jjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:39:41 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:50299 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaF3Jjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:39:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140630070755.GA4766@pd.tnic>
References: <20140630070755.GA4766@pd.tnic>
Date: Mon, 30 Jun 2014 11:39:39 +0200
Message-ID: <CAFrcx1=ri4MO3SUn85KqRDc-OBdbRumM44-OsxbU6CckszhH=g@mail.gmail.com>
Subject: Re: crazy idea (was: Re: [PATCH] perf tool: Carve out ctype.h et al)
From: Jean Pihet <jean.pihet@linaro.org>
To: Borislav Petkov <bp@alien8.de>, Fu Wei <fu.wei@linaro.org>
Cc: Robert Richter <rric@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

-- added Fu Wei in the loop --

On 30 June 2014 09:07, Borislav Petkov <bp@alien8.de> wrote:
> On Sat, Jun 28, 2014 at 01:28:19AM +0200, Borislav Petkov wrote:
>> Ok, cool. So guys, can we apply this one so that I can continue with the
>> next round?
>
> Ok, I had this crazy idea recently:
>
> How about we copy the perf tool code we need for the RAS daemon and
> start hacking on it in a separate repo, somewhere else?
>
> This way we can start adding features and stuff and finally do some real
> work on it. The code which deals with opening a tracepoint and reading
> from it should be pretty stable by now so we won't have to sync back
> with perf too often. And if we do, we'll copy the changed bits.
>
> In the meantime, we can still work on the splitting of the kernel code
> if it is desired.
>
> In any case, I would definitely like to parallelize the work because
> if we wait for the split to happen, we won't have a RAS daemon with
> persistent events by Christmas 2050 and by then who knows whether we're
> even alive.</sarcastic joke>
>
> So what do you guys think, makes some sense at least?

That makes perfect sense since:
- we need the RAS daemon implementation soon (not just before the
final blackdown ;-),
- for other tools to exist (like RAS daemon) we need to split out the
perf code in small units. This will take a significant amount of work
and time to happen,
- the RAS daemon basically is a shrink-down perf with persistent events support.

How do we start the RAS daemon? As of today we have a prototype
implementation in C.

Fu Wei, can you confirm about the initial RAS daemon prototype?

Thx, regards,
Jean

>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
