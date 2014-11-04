Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390AbaKDF7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 00:59:54 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:34559 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaKDF7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 00:59:53 -0500
Message-ID: <54586B52.4060502@hitachi.com>
Date: Tue, 04 Nov 2014 14:59:46 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 0/4 v2] ftracetests: Add ftrace tests to ftracetests
References: <20141103212737.696365174@goodmis.org>
In-Reply-To: <20141103212737.696365174@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/04 6:27), Steven Rostedt wrote:
> Second attempt. I took the advice from Masami Hiramatsu and modified
> my tests. I also added some helper functions to ftracetests as well.
> 
> I split the one function graph test into two. One to just test the
> filtering of the function graph and another to test with stack tracer.

This series looks good to me :)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

for this series.

Thank you!

> 
> Steven Rostedt (Red Hat) (4):
>       ftracetest: Add clear_trace() helper to reset the trace file
>       ftracetest: Add disable/enable_tracing() helper calls
>       ftracetest: Add helper reset_tracer() function
>       ftracetest: Add a couple of ftrace test cases
> 
> ----
>  tools/testing/selftests/ftrace/ftracetest          |  3 +
>  .../ftrace/test.d/ftrace/fgraph-filter-stack.tc    | 94 ++++++++++++++++++++++
>  .../ftrace/test.d/ftrace/fgraph-filter.tc          | 49 +++++++++++
>  .../ftrace/test.d/ftrace/func_profiler.tc          | 76 +++++++++++++++++
>  tools/testing/selftests/ftrace/test.d/functions    | 16 ++++
>  5 files changed, 238 insertions(+)
> 
> 
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


