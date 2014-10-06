Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbaJFPCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:02:33 -0400
Received: from mail-yk0-f179.google.com ([209.85.160.179]:34105 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbaJFPCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:02:32 -0400
MIME-Version: 1.0
In-Reply-To: <20141006145856.GA14113@kernel.org>
References: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com>
	<20140930132416.GB2799@kernel.org>
	<20141006090726.GQ20170@rric.localhost>
	<20141006145856.GA14113@kernel.org>
Date: Mon, 6 Oct 2014 17:02:31 +0200
Message-ID: <CAFrcx1kdnjaJDqBD33t6RB6AMQuLDGJUxd1O0k-_uRiS3oiNAQ@mail.gmail.com>
Subject: Re: perf & rasd integration plan
From: Jean Pihet <jean.pihet@linaro.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Robert Richter <rric@kernel.org>, Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On 6 October 2014 16:58, Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
> Em Mon, Oct 06, 2014 at 11:07:26AM +0200, Robert Richter escreveu:
>> On 30.09.14 10:24:16, Arnaldo Carvalho de Melo wrote:
>> > Em Tue, Sep 30, 2014 at 11:06:21AM +0200, Jean Pihet escreveu:
>> > > The plan is to move the small and generic functions first: util,
>> > > xyarray, cpumap, thread_map etc; then evlist, evsel, trace-event,
>> > > trace-event-parse; and finally integrate rasd into the tools/ dir.
>
>> > > Any thought? Can evlist, evsel etc. be moved at once?
>
>> > > Patches should come soon, when time allows.
>
>> > Why don't you add it to tools/rasd/ and in tools/rasd/Makefile you just
>> > go on and add tools/perf/util/evlist.o et all to be linked directly, as
>> > a first step.
>
>> > Then, as a second step, we can create a tools/lib/perf/evlist.c having
>> > what is currently used by both tools/perf/ and tools/rasd/, i.e. what is
>> > proven to be useful for something other than perf.
>
>> It would be good to have tools/lib/perf or so with some base
>> implementation to setup and connect to perf buffers. This is useful
>> for tools not only in tools/. The rasd would be a good reference for
>
> Agreed, we can use rasd as a reference, I'm now looking for the git repo
> url to see what it is using to prototype how I think this should be
> done.
The latest patches have been submitted to linux-edac [1] and also are
available in the dev git tree [2].
[1] http://marc.info/?l=linux-edac&m=141234802311271&w=2
[2] https://git.linaro.org/people/jean.pihet/rasd.git

Thx,
Jean

>
> - Arnaldo
>
>> this regardless if it is in tools/ or not. I am not sure whether and
>> when rasd will be moved there.
>
> - Arnaldo
