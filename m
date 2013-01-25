Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab3AYP2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 10:28:33 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:53474 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab3AYP2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 10:28:30 -0500
MIME-Version: 1.0
In-Reply-To: <20130125085514.GA31478@gmail.com>
References: <1359040242-8269-1-git-send-email-eranian@google.com>
	<20130125085514.GA31478@gmail.com>
Date: Fri, 25 Jan 2013 16:28:29 +0100
Message-ID: <CABPqkBQtOeNmoHhrsVBUTeCHdBZLN+UWJ+bcu3PDQ+sMfs92pw@mail.gmail.com>
Subject: Re: [PATCH v7 00/18] perf: add memory access sampling support
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 9:55 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>> This patch series had a new feature to the kernel perf_events
>> interface and corresponding user level tool, perf.
>
> Can I add your Signed-off-by tag to the patches you picked up
> from Andi?
>
Yes. But note that I have to simplify one of them because it included
TSX changes. It's the following patch:

[PATCH v7 05/18] perf, tools: Add support for weight v7 (modified)

I was going to suggest to him that he breaks his original into two or
move it earlier in his stack so has to make it independent of HSW
specific extensions.


> Thanks,
>
>         Ingo
