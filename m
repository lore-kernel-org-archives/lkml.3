Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab3JRRbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:31:18 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:62809 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445Ab3JRRbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:31:17 -0400
Message-ID: <52617061.7000107@gmail.com>
Date: Fri, 18 Oct 2013 11:31:13 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v2 4/4] perf-top: add --max-stack option to limit callchain
 stack scan
References: <1382107129-2010-1-git-send-email-Waiman.Long@hp.com> <1382107129-2010-5-git-send-email-Waiman.Long@hp.com>
In-Reply-To: <1382107129-2010-5-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/13 8:38 AM, Waiman Long wrote:
> When the callgraph function is enabled (-G), it may take a long time to
> scan all the stack data and merge them accordingly.
>
> This patch adds a new --max-stack option to perf-top to limit the depth
> of callchain stack data to look at to reduce the time it takes for
> perf-top to finish its processing. It reduces the amount of information
> provided to the user in exchange for faster speed.
>
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> ---
>   tools/perf/Documentation/perf-top.txt |    8 ++++++++
>   tools/perf/builtin-top.c              |    8 ++++++--
>   tools/perf/util/top.h                 |    1 +
>   3 files changed, 15 insertions(+), 2 deletions(-)
>

Looks good to me. Acked-by: David Ahern <dsahern@gmail.com>


