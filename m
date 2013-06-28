Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab3F1RYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 13:24:21 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:50580 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063Ab3F1RYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 13:24:20 -0400
Message-ID: <51CDC6BF.10301@gmail.com>
Date: Fri, 28 Jun 2013 11:24:15 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V3 13/15] perf tools: struct thread has a tid not a pid
References: <1372409006-8431-1-git-send-email-adrian.hunter@intel.com> <1372409006-8431-14-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1372409006-8431-14-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/28/13 2:43 AM, Adrian Hunter wrote:
> As evident from 'machine__process_fork_event()' and
> 'machine__process_exit_event()' the 'pid' member of
> struct thread is actually the tid.
>
> Rename 'pid' to 'tid' in struct thread accordingly.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: David Ahern <dsahern@gmail.com>

