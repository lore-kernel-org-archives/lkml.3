Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452AbaJNPUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 11:20:35 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:58209 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145AbaJNPUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 11:20:34 -0400
MIME-Version: 1.0
In-Reply-To: <20141014151723.GB19895@nazgul.tnic>
References: <20141007133236.GG14113@kernel.org>
	<20141007140433.GG30146@pd.tnic>
	<20141010200708.GB18775@kernel.org>
	<20141010202854.GC13017@pd.tnic>
	<20141010204158.GA13834@kernel.org>
	<20141010204432.GD13017@pd.tnic>
	<CAFrcx1nm4pqWPsUtj1h5qQqo6dghiafRM60-9asaYXx7NLqAEQ@mail.gmail.com>
	<20141014135631.GA32308@krava.fdxtended.com>
	<20141014140223.GC3198@kernel.org>
	<20141014142213.GB32308@krava.fdxtended.com>
	<20141014151723.GB19895@nazgul.tnic>
Date: Tue, 14 Oct 2014 17:20:33 +0200
Message-ID: <CAFrcx1kL6ZvM4ELC7JmtPpwNvx=+81ys=+UVVwDxShNpg2eFBQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] rasd: Use perf_evlist__open() instead of open coded
From: Jean Pihet <jean.pihet@linaro.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Robert Richter <rric@kernel.org>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 October 2014 17:17, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Oct 14, 2014 at 04:22:13PM +0200, Jiri Olsa wrote:
>> right.. is there more planned for RAS daemon to do? because at this
>> point it looks to me more like new perf functionality (in trace or
>> some other new command)
>>
>> >
>> > Anyway, its beeing an interesting exercise and will result in a lot of
>> > untanglement, which is good in any case.
>>
>> yea, I dont mind untangling the interface.. I noticed in the thread
>> people want this anyway - simple 'events open' interface.. I often
>> need something simple for test programs
>
> Right, we simply need a way to get the tracepoint data into userspace.
> Nothing else. And right now I cannot think about needing any other perf
> tool functionality. But who knows.., if we need more, we'll untangle
> more.
The persistent events stuff still needs some work and is needed by rasd.

>
> :-)
;-P

>
> --
> Regards/Gruss,
>     Boris.
> --

Cheers,
Jean
