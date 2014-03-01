Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaCAADm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 19:03:42 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:42747 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbaCAADl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 19:03:41 -0500
Message-ID: <531123D8.6000201@gmail.com>
Date: Fri, 28 Feb 2014 17:03:36 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 2/2] perf tools: Fix strict alias issue for find_first_bit
References: <1393622751-21513-1-git-send-email-acme@infradead.org> <1393622751-21513-3-git-send-email-acme@infradead.org> <20140228212923.GI14089@laptop.programming.kicks-ass.net>
In-Reply-To: <20140228212923.GI14089@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/28/14, 2:29 PM, Peter Zijlstra wrote:
> Hurm; didn't I suggest using -fno-strict-aliasing just like the kernel
> does? Because the C aliasing rules are bonghits heavy?

you, and Ingo in 2009 -- 65014ab3


