Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbaF3PSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:18:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45834 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbaF3PSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:18:07 -0400
Date: Mon, 30 Jun 2014 17:18:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Robert Richter <rric@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Fu Wei <fu.wei@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>
Subject: Re: crazy idea (was: Re: [PATCH] perf tool: Carve out ctype.h et al)
Message-ID: <20140630151802.GG4766@pd.tnic>
References: <20140630070755.GA4766@pd.tnic>
 <CAFrcx1=ri4MO3SUn85KqRDc-OBdbRumM44-OsxbU6CckszhH=g@mail.gmail.com>
 <20140630100115.GC4766@pd.tnic>
 <20140630145031.GR27560@rric.localhost>
 <20140630145831.GA4762@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140630145831.GA4762@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 11:58:31AM -0300, Arnaldo Carvalho de Melo wrote:
> Yeap, guess its the most sensible to do given how things went so far.
>
> Please submit patches when you fix things on code copied from
> tools/perf/ and generally when improving it.

Sure.

Btw, should I still be working on the split even if the RAS daemon is
out-of-tree?

If I do, the advantage is that there'll be no pressure on anyone and
we'll be applying patches as they come.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
