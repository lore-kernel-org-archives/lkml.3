Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbaFYVVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 17:21:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47778 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbaFYVVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 17:21:30 -0400
Date: Wed, 25 Jun 2014 23:21:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH] perf tool: Carve out ctype.h et al
Message-ID: <20140625212124.GE13845@pd.tnic>
References: <1403688184-6917-1-git-send-email-bp@alien8.de>
 <20140625192547.GF1153@krava.brq.redhat.com>
 <20140625203836.GD13845@pd.tnic>
 <20140625211757.GD18773@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140625211757.GD18773@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 06:17:57PM -0300, Arnaldo Carvalho de Melo wrote:
> Yeah, and albeit it can take time, its how it would be done if this
> was touching core kernel code, right? So lets try to do it that way
> ;-)

Oh sure, I'm not complaining - I'm just discussing our process and how
to optimize it.

> I'd say work on tip/perf/core, if it doesn't apply on mine or jolsa's,
> we'll fix it up, right Jiri?
>
> We try not to keep too much stuff queued up, so there should be no
> problems 99.9% of the time...

Ok, good.

I'll rebase the patch ontop of it tomorrow. Now back to the football
game! :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
