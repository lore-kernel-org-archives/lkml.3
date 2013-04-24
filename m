Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab3DXKgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 06:36:53 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:42865 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653Ab3DXKgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 06:36:52 -0400
X-AuditID: 9c93016f-b7b70ae0000038d5-0d-5177b5c26cd2
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 02/14] perf util: Use evsel->name to get tracepoint_paths
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
	<1366705872-12132-3-git-send-email-namhyung@kernel.org>
	<1366722440.9609.148.camel@gandalf.local.home>
Date: Wed, 24 Apr 2013 19:36:50 +0900
In-Reply-To: <1366722440.9609.148.camel@gandalf.local.home> (Steven Rostedt's
	message of "Tue, 23 Apr 2013 09:07:20 -0400")
Message-ID: <8761zcb4fx.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Apr 2013 09:07:20 -0400, Steven Rostedt wrote:
>> +
>> +		if (pos->name && strchr(pos->name, ':')) {
>> +			char *str = strchr(pos->name, ':');
>
> Why not make the above into:
>
> 	if (pos->name && (str = strchr(pos->name, ':'))) {
>
> ?

I wanted not to have an assignment in an if condition, just for my
preference.  I will change it.

Thanks,
Namhyung
