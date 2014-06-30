Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbaF3Oul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 10:50:41 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:46348 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbaF3Ouj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 10:50:39 -0400
Date: Mon, 30 Jun 2014 16:50:31 +0200
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Jean Pihet <jean.pihet@linaro.org>, Fu Wei <fu.wei@linaro.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>
Subject: Re: crazy idea (was: Re: [PATCH] perf tool: Carve out ctype.h et al)
Message-ID: <20140630145031.GR27560@rric.localhost>
References: <20140630070755.GA4766@pd.tnic>
 <CAFrcx1=ri4MO3SUn85KqRDc-OBdbRumM44-OsxbU6CckszhH=g@mail.gmail.com>
 <20140630100115.GC4766@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630100115.GC4766@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.06.14 12:01:15, Borislav Petkov wrote:
> Well, do you have it as a standalong program? If so, you can put it in
> a repo somewhere and we can start hacking away and playing with it. If
> not, we will have to copy the perf code *into* the RAS daemon first so
> that we can have a separate source on which we all can work on.
> 
> Someone should be a maintainer of some sorts who merges the patches.
> 
> And we will continue working on the split so that once the perf tool is
> properly separated, we can switch to it in the RAS daemon and drop the
> copied code.
> 
> This is, to me at least, the best possible thing we can do right now so
> as not to slow us all down.
> 
> Any other opinions?

Perfectly fine with me.

-Robert
