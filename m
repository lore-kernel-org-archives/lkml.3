Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751115AbaKFB7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 20:59:00 -0500
Received: from mail-oi0-f47.google.com ([209.85.218.47]:56040 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaKFB66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 20:58:58 -0500
MIME-Version: 1.0
In-Reply-To: <20141105180521.1e12b87e@gandalf.local.home>
References: <20141104152845.521858531@goodmis.org> <20141104153028.602754370@goodmis.org>
 <87zjc6ulry.fsf@sejong.aot.lge.com> <5459E2AB.8020009@hitachi.com> <20141105180521.1e12b87e@gandalf.local.home>
From: Namhyung Kim <namhyung@kernel.org>
Date: Thu, 6 Nov 2014 10:58:37 +0900
X-Google-Sender-Auth: dxlhcpJ5oFQq0xjz2v6GP4MJbA0
Message-ID: <CAM9d7ch0OYOZ8Q5ruhvNPVQOwAWUY5XRjSgkW70CnDcra3MPbQ@mail.gmail.com>
Subject: Re: [PATCH 2/2 v4] ftracetest: Add a couple of ftrace test cases
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Thu, Nov 6, 2014 at 8:05 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Added three test cases to get the feel of adding tests to ftracetest.
> The three cases are:
>
>   function profiling test, to make sure function profiling still works
>    with function tracing (was a regression)
>
>   function graph filter test to make sure that function graph filtering works.
>
>   function graph filter with stack tracing test to make sure that the function
>    graph filter does filter and also continues to filter when another function tracer
>    is running (like the stack tracer)
>
> Link: http://lkml.kernel.org/r/20141103212737.696365174@goodmis.org
>
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

For this and previous patch 1/2,

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
