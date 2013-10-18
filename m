Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab3JRNaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:30:21 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:47162 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab3JRNaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:30:19 -0400
Message-ID: <526137E5.3050803@gmail.com>
Date: Fri, 18 Oct 2013 07:30:13 -0600
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
Subject: Re: [PATCH 07/19] perf script: Set up output options for in-stream
 attributes
References: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com> <1382099356-4918-8-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1382099356-4918-8-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/13 6:29 AM, Adrian Hunter wrote:
> Attributes (struct perf_event_attr) are recorded
> separately in the perf.data file.  perf script uses
> them to set up output options.  However attributes
> can also be in the event stream, for example when
> the input is a pipe (i.e. live mode).  This patch
> makes perf script process in-stream attributes in
> the same way as on-file attributes.

You have multiple changes in this patch -- expanding attribute 
processing to set output options per the description above and you are 
also making perf_script a stack variable. The latter should be a 
separate patch.

David
