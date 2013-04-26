Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab3DZNfB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 09:35:01 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:60029 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab3DZNe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 09:34:59 -0400
Message-ID: <517A827B.1080905@gmail.com>
Date: Fri, 26 Apr 2013 07:34:51 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 05/14] perf tools: Introduce new 'ftrace' tool
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>  <1366705872-12132-6-git-send-email-namhyung@kernel.org>  <20130424140918.GF971@krava.brq.redhat.com>  <87fvyf9maa.fsf@sejong.aot.lge.com>  <20130425090956.GA1033@krava.brq.redhat.com>  <87r4hz7xal.fsf@sejong.aot.lge.com> <1366895121.10248.12.camel@gandalf.local.home>
In-Reply-To: <1366895121.10248.12.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/25/13 7:05 AM, Steven Rostedt wrote:
>   Perf was added in 2.6.31, but do all
> functionalities still work that far back?


perf was accepted into 2.6.28 - first commit is 0793a61d.

It does have limited functionality (H/W and S/W counters) until 2.6.31.

David
