Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab3DWRTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 13:19:40 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:38891 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529Ab3DWRTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 13:19:39 -0400
MIME-Version: 1.0
In-Reply-To: <1366732681.9609.157.camel@gandalf.local.home>
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
	<1366732681.9609.157.camel@gandalf.local.home>
Date: Tue, 23 Apr 2013 20:19:37 +0300
X-Google-Sender-Auth: 2PkT6SCOvZQA6v3sibnK62rvZAM
Message-ID: <CAOJsxLF16Edznsdis4NK-O1Sf=3Eswb5L=cfBDhjpr6F7UjTbg@mail.gmail.com>
Subject: Re: [RFC 00/14] perf tools: Introduce new 'ftrace' command
From: Pekka Enberg <penberg@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, 2013-04-23 at 17:30 +0900, Namhyung Kim wrote:
>> This patchset implements a front-end tool for kernel's ftrace.  It
>> uses function_graph tracer by default and normal function tracer is
>> also supported.  (Of course you need to enable those tracers in your
>> kernel first.)

On Tue, Apr 23, 2013 at 6:58 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Very nice Namhyung, thanks for doing this. I did a quick run through of
> the patches and I have no complaints about them. I'm not sure how the
> others will feel about it.

I also skimmed through the patches and they look like a reasonable
starting point. So FWIW,

Acked-by: Pekka Enberg <penberg@kernel.org>

Are there any plans in trying to consolidate 'perf trace' and this? As
a user I don't really care what the underlying mechanism and would
like things to just work out of the box.

                        Pekka
