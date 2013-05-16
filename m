Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab3EPCv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 22:51:57 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:58688 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab3EPCv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 22:51:56 -0400
X-AuditID: 9c93017d-b7b62ae000004f69-7c-519449caee0b
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 03/15] perf util: Save pid-cmdline mapping into tracing header
References: <1368526439-31966-1-git-send-email-namhyung@kernel.org>
	<1368526439-31966-4-git-send-email-namhyung@kernel.org>
	<20130515212124.GC5814@krava.redhat.com>
Date: Thu, 16 May 2013 11:51:54 +0900
In-Reply-To: <20130515212124.GC5814@krava.redhat.com> (Jiri Olsa's message of
	"Wed, 15 May 2013 23:21:24 +0200")
Message-ID: <877giz4oxh.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 May 2013 23:21:24 +0200, Jiri Olsa wrote:
> On Tue, May 14, 2013 at 07:13:47PM +0900, Namhyung Kim wrote:
>> +void parse_saved_cmdline(struct pevent *pevent,
>> +			 char *file, unsigned int size __maybe_unused)
>
> any reason for the size parameter? I can see some other
> functions already following this prototype, but I dont
> see the reason.. just curious ;)

I don't know, but copied those. ;)  I guess we can get rid of it.
Steve, any comments?

Thanks,
Namhyung

>
> void parse_ftrace_printk(struct pevent *pevent,
>                          char *file, unsigned int size __maybe_unused)
>
> void parse_proc_kallsyms(struct pevent *pevent,
>                          char *file, unsigned int size __maybe_unused)
>
>
> jirka
