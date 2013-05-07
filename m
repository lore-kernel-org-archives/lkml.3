Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab3EGOw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:52:56 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:19780 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab3EGOwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:52:55 -0400
Message-ID: <5189152C.4010703@hp.com>
Date: Tue, 07 May 2013 10:52:28 -0400
From: Waiman Long <Waiman.Long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120601 Thunderbird/10.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf: fix symbol processing bug and greatly improve performance
References: <1367847833-4932-1-git-send-email-Waiman.Long@hp.com> <20130507070127.GA17830@gmail.com> <51890D71.9080600@hp.com>
In-Reply-To: <51890D71.9080600@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 10:19 AM, Waiman Long wrote:
> The slowdown that I was trying to fix was in the "perf record" part of 
> the profiling process, not the "perf report" part. I didn't try 
> perf-record on perf-record as the performance counters are limited 
> resources and I don't want resource conflicts to affect the results. 
> As the slow-down was entirely in the user space, I decided to use 
> gprof to do the profiling.

Just to clarify that the post-processing time that I referred to in the 
patch is the time spent after the workload finishes in the perf-record 
session and the perf command itself quits. I could take a really long 
time for perf to quit without the patch.

Regards,
Longman

