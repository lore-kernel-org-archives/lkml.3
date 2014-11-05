Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbaKEHmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 02:42:44 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:38088 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaKEHmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 02:42:43 -0500
X-Original-SENDERIP: 10.177.222.33
X-Original-MAILFROM: byungchul.park@lge.com
Date: Wed, 5 Nov 2014 16:42:28 +0900
From: Byungchul Park <byungchul.park@lge.com>
To: rostedt@goodmis.org, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, seungho1.park@lge.com, jolsa@redhat.com
Subject: Re: [PATCH v2 0/3] tracing: signaling large duration and delay
Message-ID: <20141105074228.GC3393@byungchulpark-X58A-UD3R>
References: <1415171806-5063-1-git-send-email-byungchul.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415171806-5063-1-git-send-email-byungchul.park@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 04:16:46PM +0900, byungchul.park@lge.com wrote:
> From: Byungchul Park <byungchul.park@lge.com>
> 
> Changes from v1 to v2
> * update Document/trace/ftrace.txt
> * seperate the implementation as a macro
> * apply the implementation to delay printing, too
> 
> Hello.
> 
> When I analysis the exit_mm() function to find out the reason why the
> function spends much time occasionally, this patch was very useful.
> I thought this patch cannot be useful only for me, but can be also
> useful for anybody who want to be signaled for very large function
> execution time, so I decided to submit this patchset.
> 
> Nobody who have such a demand? :)
> 
> Thanks,
> Byungchul.
> 
> Byungchul Park (3):
>   tracing, function_graph: fix micro seconds notation in comment
>   tracing, function_graph: add additional marks to signal very large
>     function execution time
>   tracing: add additional marks to signal very large delay
> 
>  Documentation/trace/ftrace.txt       |   10 +++++++---
>  kernel/trace/trace.h                 |   14 ++++++++++++++
>  kernel/trace/trace_functions_graph.c |   23 +++++++++++++----------
>  kernel/trace/trace_output.c          |   15 ++++++++++-----
>  4 files changed, 44 insertions(+), 18 deletions(-)
> 
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

REALLY REALLY SORRY for sending cover-letter twice. :(
I will be carefull.

