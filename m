Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab3J3TGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:06:23 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:34857 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab3J3TGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:06:21 -0400
Date: Wed, 30 Oct 2013 20:06:18 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/2] perf list: Add usage
Message-ID: <20131030190618.GA5623@gmail.com>
References: <1383149707-1008-1-git-send-email-dsahern@gmail.com>
 <1383149707-1008-2-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383149707-1008-2-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> Currently perf list is not very helpful if you forget the syntax:
>   $ perf list -h
> 
>   List of pre-defined events (to be used in -e):
> 
> After:
>   $ perf list -h
> 
>    usage: perf list [hw|sw|cache|tracepoint|pmu|event_glob]
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Stephane Eranian <eranian@google.com>
> ---
>  tools/perf/builtin-list.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)

Acked-by: Ingo Molnar <mingo@kernel.org>

	Ingo
