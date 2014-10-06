Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbaJFPQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:16:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44643 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbaJFPQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:16:10 -0400
Date: Mon, 6 Oct 2014 17:16:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Robert Richter <rric@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: perf & rasd integration plan
Message-ID: <20141006151605.GE4372@pd.tnic>
References: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com>
 <20141006150741.GB14113@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141006150741.GB14113@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 12:07:41PM -0300, Arnaldo Carvalho de Melo wrote:
> So, why have you commented out the perf_missing_features fallbacks? Are
> they getting in the way somehow, what can we do upstream, i.e. in
> tools/perf/util/ so that it gets closer to what you want to have?
> 
> Ditto for all the other ifdef'ed code, can you elaborate on why each is
> needed? That will help in moving what is used by rasd from
> tools/perf/util/ to tools/perf/lib/ so that we can eliminate the
> duplicity.

Oh, the reason is very simple: so that it builds. We don't need those
facilities yet. We will enable them when needed but we wanted to
concentrate on rasd first and later clean up stuff as we go.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
