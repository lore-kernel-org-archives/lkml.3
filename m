Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab3KVPrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:47:22 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:45398 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab3KVPrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:47:21 -0500
Subject: Re: [PATCH 21/22] perf tools: Add trace-event global object for
 tracepoint interface
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
In-Reply-To: <1385031680-9014-22-git-send-email-jolsa@redhat.com>
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
	 <1385031680-9014-22-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Nov 2013 00:47:14 +0900
Message-ID: <1385135234.1747.122.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-11-21 (목), 12:01 +0100, Jiri Olsa:
> In order to get the proper plugins processing we need to
> use full trace-event interface when creating tracepoint
> events. So far we were using shortcut to get the parsed
> format.
> 
> Moving current 'event_format__new' function into trace-event
> object as 'trace_event__tp_format'.
> 
> This function uses properly initialized global trace-event
> object, ensuring proper plugins processing.

I see this when I compile it on my old ubuntu 10.04 box (with gcc 4.4.3)

  CC       util/trace-event.o
cc1: warnings being treated as errors
util/trace-event.c: In function 'trace_event__tp_format':
util/trace-event.c:63: error: not protecting function: no buffer at
least 8 bytes long
make[1]: *** [util/trace-event.o] Error 1

Thanks,
Namhyung


