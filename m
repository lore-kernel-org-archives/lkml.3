Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab3JWGoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 02:44:25 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:64844 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab3JWGoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 02:44:24 -0400
Message-ID: <5267703F.8040807@gmail.com>
Date: Wed, 23 Oct 2013 07:44:15 +0100
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 12/14] perf sched: Fix optimized build time
References: <1382427258-17495-1-git-send-email-adrian.hunter@intel.com> <1382427258-17495-13-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1382427258-17495-13-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/13 8:34 AM, Adrian Hunter wrote:
> builtin-sched.c took a log time to build with
> -O6 optimization. This turned out to be caused
> by:
>
> 	.curr_pid = { [0 ... MAX_CPUS - 1] = -1 },
>
> Fix by initializing curr_pid programmatically.
>
> Signed-off-by: Adrian Hunter<adrian.hunter@intel.com>


Acked-by: David Ahern <dsahern@gmail.com>

