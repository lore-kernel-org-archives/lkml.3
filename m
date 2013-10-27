Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab3J0PjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 11:39:21 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:58518 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab3J0PjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 11:39:20 -0400
Message-ID: <526D33A5.2030200@gmail.com>
Date: Sun, 27 Oct 2013 09:39:17 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
CC: Corey Ashford <cjashfor@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 4/4] perf tools: Add readable output for callchain debug
References: <20131026120336.GA24439@gmail.com> <1382797536-32303-1-git-send-email-jolsa@redhat.com> <1382797536-32303-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1382797536-32303-5-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/13 8:25 AM, Jiri Olsa wrote:
> Adding people readable output for callchain debug,
> to get following '-v' output:
>
>    $ perf record -v -g ls
>    callchain: type DWARF
>    callchain: stack dump size 4096
>    ...

Kind of ugly that the -v has to be first to actually get the debug 
output. Other debug options have the same problem though. So,

Tested-Reviewed-by: David Ahern <dsahern@gmail.com>

