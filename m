Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbaJHPZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:25:23 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:44333 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbaJHPZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:25:22 -0400
Message-ID: <5435575E.2090308@gmail.com>
Date: Wed, 08 Oct 2014 09:25:18 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@kernel.org>
Subject: Re: PERF_EVENT_IOC_SET_FILTER has different values based on bitness
References: <54347238.2060908@gmail.com> <20141008072355.GA10832@worktop.programming.kicks-ass.net> <54355592.6000604@gmail.com> <20141008152204.GN14113@kernel.org>
In-Reply-To: <20141008152204.GN14113@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/8/14, 9:22 AM, Arnaldo Carvalho de Melo wrote:
> I wonder how that works best, being on the receiving side of such requests
> from time to time.
>
> I guess that to scale, that would be better done by:
>
> 1. Reporter tests if the patch applies (and works) on the desired
> targets.
>
> 2. Reporter sends the request, with the above test results, to
> stable@kernel.org, following whatever conventions are to get the
> attention of the stable release maintainers.

My understanding is that subsystem maintainers do the stable requests.

A patch adjustment is needed for v3.4 and v3.10. I am willing to do the 
necessary patch mods for 3.4, 3.10, and 3.14.

David

