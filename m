Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaJGOCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:02:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34521 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbaJGOCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:02:35 -0400
Date: Tue, 7 Oct 2014 16:02:29 +0200
From: Borislav Petkov <bp@alien8.de>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Robert Richter <rric@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Matt Fleming <matt@console-pimps.org>
Subject: Re: perf & rasd integration plan
Message-ID: <20141007140229.GF30146@pd.tnic>
References: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com>
 <20141006150741.GB14113@kernel.org>
 <20141006151605.GE4372@pd.tnic>
 <20141006191227.GD14113@kernel.org>
 <20141006195349.GE20739@pd.tnic>
 <20141006212243.GE14113@kernel.org>
 <20141007112342.GC30146@pd.tnic>
 <20141007134021.GH14113@kernel.org>
 <20141007134912.GE30146@pd.tnic>
 <20141007135531.GI14113@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141007135531.GI14113@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 10:55:31AM -0300, Arnaldo Carvalho de Melo wrote:
> So you say that if we change a method, say, perf_evlist__open() to
> accept a new argument, or change the type of one of its arguments,
> with a good reason, it is acceptable and with just a change in the
> README explaining why the build fails, which helps in finding how to fix
> it in a particular project using these "source libraries" then it would
> be ok?

Right, exactly.

Updating the perf bits used in another project will require a
recompilation anyway so adjusting stuff here and there should not be of
issue.

> That would be fine with me.

Yeah.

> We should take care to make sure that the build _fails_ in such cases,
> i.e.avoid changing the semantic of the Nth argument but keeping its
> type kind of changes.

Yep.

> At some point there will be no more reasons to change things, and that
> will be noticed by how long since the last change was made to a
> particular class, at that point we may well think about making library
> type promises.

I was about to say the same thing - once the code doesn't change anymore
and gets even boring, doing the library promise is probably pretty easy.

See, no need for you to get over to LCE: we're practically done :-)

We'll run the proposal in jolsa's timeslot again and make sure to poke
holes in it. But it looks good from where I'm standing.

Btw, did we just solve the compatibility problem of libraries by
delivering source libraries first!?!

Haha.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
