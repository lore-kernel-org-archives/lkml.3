Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbaJJUop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 16:44:45 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48673 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157AbaJJUon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 16:44:43 -0400
Date: Fri, 10 Oct 2014 22:44:32 +0200
From: Borislav Petkov <bp@alien8.de>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Robert Richter <rric@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/1] rasd: Use perf_evlist__open() instead of open coded
Message-ID: <20141010204432.GD13017@pd.tnic>
References: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com>
 <20141006212606.GF14113@kernel.org>
 <CAFrcx1=swP-3E_pxWEcozFJhL+5YaUBPavQX=OfMtc8h4e=bDg@mail.gmail.com>
 <20141007133236.GG14113@kernel.org>
 <20141007140433.GG30146@pd.tnic>
 <20141010200708.GB18775@kernel.org>
 <20141010202854.GC13017@pd.tnic>
 <20141010204158.GA13834@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141010204158.GA13834@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 05:41:58PM -0300, Arnaldo Carvalho de Melo wrote:
> Right, stoopid me, no need for some specific tracepoint, just to see
> that whatever tp it is, it will show up in "rasd"'s event loop. Ok, I'll
> try that later.
> 
> Next stuff I probably will do is to move the bare minimum used by rasd
> to tools/lib/api/perf/, i.e. there will be:
> 
> tools/lib/api/perf/evsel.c
> tools/perf/util/evsel.c
> 
> Both will share the perf_evsel__ namespace (which I thought at some
> point to make just: evsel__<METHOD_NAME>, wdyt?).
> 
> That way we just make public the bare minimum that already proved to be
> useful outside tools/perf/ and over time we move stuff from
> tools/perf/util/evsel.c (and from other tools in or out perf's repo)
> into the lib.

Abso-f*cking-lutely!

:-D

> Np, had to be done at some point :)

Yeah, cool. Let me know what I should do to help out.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
