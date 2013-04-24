Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262Ab3DXJaC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:30:02 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:52427 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390Ab3DXJ34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:29:56 -0400
X-AuditID: 9c930179-b7b5bae0000069d1-1b-5177a6138de6
From: Namhyung Kim <namhyung@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [RFC 00/14] perf tools: Introduce new 'ftrace' command
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
	<1366732681.9609.157.camel@gandalf.local.home>
	<CAOJsxLF16Edznsdis4NK-O1Sf=3Eswb5L=cfBDhjpr6F7UjTbg@mail.gmail.com>
Date: Wed, 24 Apr 2013 18:29:55 +0900
In-Reply-To: <CAOJsxLF16Edznsdis4NK-O1Sf=3Eswb5L=cfBDhjpr6F7UjTbg@mail.gmail.com>
	(Pekka Enberg's message of "Tue, 23 Apr 2013 20:19:37 +0300")
Message-ID: <87ehe0b7jg.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Tue, 23 Apr 2013 20:19:37 +0300, Pekka Enberg wrote:
> Hello,
>
> On Tue, 2013-04-23 at 17:30 +0900, Namhyung Kim wrote:
>>> This patchset implements a front-end tool for kernel's ftrace.  It
>>> uses function_graph tracer by default and normal function tracer is
>>> also supported.  (Of course you need to enable those tracers in your
>>> kernel first.)
>
> On Tue, Apr 23, 2013 at 6:58 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> Very nice Namhyung, thanks for doing this. I did a quick run through of
>> the patches and I have no complaints about them. I'm not sure how the
>> others will feel about it.
>
> I also skimmed through the patches and they look like a reasonable
> starting point. So FWIW,
>
> Acked-by: Pekka Enberg <penberg@kernel.org>

Thank you!


> Are there any plans in trying to consolidate 'perf trace' and this? As
> a user I don't really care what the underlying mechanism and would
> like things to just work out of the box.

No plans currently.  I'll try to think about it more..

Thanks,
Namhyung
