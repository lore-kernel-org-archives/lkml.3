Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbaJHPRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:17:46 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:33777 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbaJHPRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:17:42 -0400
Message-ID: <54355592.6000604@gmail.com>
Date: Wed, 08 Oct 2014 09:17:38 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@kernel.org>
Subject: Re: PERF_EVENT_IOC_SET_FILTER has different values based on bitness
References: <54347238.2060908@gmail.com> <20141008072355.GA10832@worktop.programming.kicks-ass.net>
In-Reply-To: <20141008072355.GA10832@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/8/14, 1:23 AM, Peter Zijlstra wrote:
> Should be fixed for a while now
>
> ---
> commit b3f207855f57b9c8f43a547a801340bb5cbc59e5
> Author: Pawel Moll <pawel.moll@arm.com>
> Date:   Fri Jun 13 16:03:32 2014 +0100
>
>      perf: Handle compat ioctl
>

that works. Can we get this queued to the stable releases (at least as 
far back as v3.4)?

Thanks,
David
