Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab3KKUlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:41:11 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:59407 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab3KKUlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:41:04 -0500
Message-ID: <528140DB.90301@gmail.com>
Date: Mon, 11 Nov 2013 13:40:59 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 04/10] perf machine: Introduce synthesize_threads method
 out of open coded equivalent
References: <1384201353-23863-1-git-send-email-acme@infradead.org> <1384201353-23863-5-git-send-email-acme@infradead.org>
In-Reply-To: <1384201353-23863-5-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/13, 1:22 PM, Arnaldo Carvalho de Melo wrote:
> +	if (perf_target__has_task(target))
> +		return perf_event__synthesize_thread_map(tool, threads, process, machine, data_mmap);
> +	else if (perf_target__has_cpu(target))
> +		return perf_event__synthesize_threads(tool, process, machine, data_mmap);


Getting kind of long on the line lengths...
