Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457Ab3JWGoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 02:44:06 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:39467 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3JWGoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 02:44:05 -0400
Message-ID: <5267702B.6080104@gmail.com>
Date: Wed, 23 Oct 2013 07:43:55 +0100
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
Subject: Re: [PATCH V2 11/14] perf sched: Make struct perf_sched sched a local
 variable
References: <1382427258-17495-1-git-send-email-adrian.hunter@intel.com> <1382427258-17495-12-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1382427258-17495-12-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/13 8:34 AM, Adrian Hunter wrote:
> Change "struct perf_sched sched" from being global
> to being local.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>   tools/perf/builtin-sched.c | 41 ++++++++++++++++++++---------------------
>   1 file changed, 20 insertions(+), 21 deletions(-)
>

Acked-by: David Ahern <dsahern@gmail.com>

