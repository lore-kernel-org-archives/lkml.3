Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbaFLNT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:19:57 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:59977 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792AbaFLNTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:19:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140612124918.GC4857@pd.tnic>
References: <1402561602-28807-1-git-send-email-jean.pihet@linaro.org>
	<20140612123432.GA2608@kernel.org>
	<20140612124918.GC4857@pd.tnic>
Date: Thu, 12 Jun 2014 15:19:50 +0200
Message-ID: <CAFrcx1kfUkFF9ROy2C0gcFe88aOHfv2qJBfO+uv+Z7ZW5HxQCw@mail.gmail.com>
Subject: Re: [PATCH] tools:perf: move tools/perf/util to tools/lib/perf_util
From: Jean Pihet <jean.pihet@linaro.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Robert Richter <rric@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 June 2014 14:49, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Jun 12, 2014 at 09:34:32AM -0300, Arnaldo Carvalho de Melo wrote:
>> Em Thu, Jun 12, 2014 at 10:26:42AM +0200, Jean Pihet escreveu:
>> > This is a first move of the perf code into a set of libraries, which
>> > allow the implementation of other external tools.
>> >
>> > The first users of the perf libraries would be:
>> > - perf itself,
>> > - the RAS daemon.
>> >
>> > The commit includes:
>> > - the move of the code from util to lib/perf_util,
>> > - creation of Makefile in perf_util,
>> > - update of Makefile.perf to build a library for perf_util,
>> > - fix of the include paths, eg. "../perf.h" to <perf.h>, "util/hist.h" to
>> >   <hist.h>
>>
>> Can't you just go moving what you actually use? Or do you really plan to
>> use all that?
>
> You asked me that same question when I was doing that. :-)
The idea is to move the re-usable code in libraries, so that other
tools than perf can use it as well.

>
> And I told Jean repeatedly that this needs to be splitted slowly, in
> smaller libraries like we've been discussing it numerous times.
Hrrr. I see it as a first move, later the rest of the code can be
moved the same way.
Now it seems that moving all from util/ at once is too much. How do
you see it happening?

Note: moving some code in the perf source is hairy enough (cf. the
simplicity of the Makefiles ;-) and so I do not want to re-do it all
over again too many times.

Thx for looking!
Jean

>
> :-\
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
